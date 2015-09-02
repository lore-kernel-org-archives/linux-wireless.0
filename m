Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbbIBSqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 14:46:08 -0400
Date: Wed, 2 Sep 2015 20:46:04 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>,
	SE Linux <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?utf-8?Q?Vojt=C4=9Bch_Pavl=C3=ADk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: Linux Firmware Signing
Message-ID: <20150902184604.GB8051@wotan.suse.de> (sfid-20150902_204630_244825_4AE39F69)
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
 <20150902000915.GW8051@wotan.suse.de>
 <1441164905.17898.86.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441164905.17898.86.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2015 at 11:35:05PM -0400, Mimi Zohar wrote:
> > OK great, I think that instead of passing the actual routine name we should
> > instead pass an enum type for to the LSM, that'd be easier to parse and we'd
> > then have each case well documented. Each LSM then could add its own
> > documetnation for this and can switch on it. If we went with a name we'd have
> > to to use something like __func__ and then parse that, its not clear if we need
> > to get that specific.
> 
> Agreed.  IMA already defines an enumeration.
> 
> /* IMA policy related functions */
> enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK,
>                  FIRMWARE_CHECK, POLICY_CHECK, POST_SETATTR };
> 

We want something that is not only useful for IMA but any other LSM,
and FILE_CHECK seems very broad, not sure what BPRM_CHECK is even upon
inspecting kernel code. Likewise for POST_SETATTR. POLICY_CHECK might
be broad, perhaps its best we define then a generic set of enums to
which IMA can map them to then and let it decide. This would ensure
that the kernel defines each use caes for file inspection carefully,
documents and defines them and if an LSM wants to bunch a set together
it can do so easily with a switch statement to map set of generic
file checks in kernel to a group it already handles.

For instance at least in the short term we'd try to unify:

security_kernel_fw_from_file()
security_kernel_module_from_file()

to perhaps:

security_kernel_from_file()

As far, as far as I can tell, the only ones we'd be ready to start
grouping immediately or with small amount of work rather soon:

/**
 *
 * enum security_filecheck - known kernel security file checks types
 *
 * @__SECURITY_FILECHECK_UNSPEC: attribute 0 reserved
 * @SECURITY_FILECHECK_MODULE: the file being processed is a Linux kernel module
 * @SECURITY_FILECHECK_SYSDATA: the file being processed is either a firmware
 *	file or a system data file read from /lib/firmware/* by firmware_class
 * @SECURITY_FILECHECK_KEXEC_KERNEL: the file being processed is a kernel file
 * 	used by kexec
 * @SECURITY_FILECHECK_KEXEC_INITRAMFS: the file being processed is an initramfs
 * 	used by kexec

 * The kernel reads files directly from the filesystem for a series of
 * operations.  The list of files the kernel reads from the filesystem are
 * limited and each type of file consumed may have a different format and
 * security vetting procedures. The kernel enables LSMs to vet for these files
 * through a shared LSM hook prior to consumption. This list documents the
 * different special kernel file types read by the kernel, it enables LSMs
 * to vet for each differently if needed.
enum security_filecheck {
	SECURITY_FILECHECK_UNSPEC,
	SECURITY_FILECHECK_MODULE,
	SECURITY_FILECHECK_SYSDATA,
	SECURITY_FILECHECK_KEXEC_KERNEL,
	SECURITY_FILECHECK_KEXEC_INITRAMFS,
};

Provided the MOK thing or alternative gets addressed we could also soon add
something for SELinux policy files but that needs to be discussed further
it seems. If MOK is used would SECURITY_FILECHECK_POLICY_MOK be OK? Again
this would likely need further discussion, its why I didn't list it above.

  Luis
