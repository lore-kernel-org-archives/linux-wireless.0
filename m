Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44346 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbHaOUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 10:20:04 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Tue, 1 Sep 2015 00:20:02 +1000
Message-ID: <1441030735.2647.70.camel@linux.vnet.ibm.com> (sfid-20150831_162059_747644_6D095063)
Subject: Re: Linux Firmware Signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?Q?=22Vojt=C4=9Bch_Pavl=C3=ADk=22?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 31 Aug 2015 10:18:55 -0400
In-Reply-To: <20150829021659.GN8051@wotan.suse.de>
References: <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
	 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
	 <1440462367.2737.4.camel@linux.vnet.ibm.com>
	 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	 <1440464705.2737.36.camel@linux.vnet.ibm.com>
	 <14540.1440599584@warthog.procyon.org.uk>
	 <31228.1440671938@warthog.procyon.org.uk>
	 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	 <20150827212907.GF8051@wotan.suse.de>
	 <1440719673.2118.84.camel@linux.vnet.ibm.com>
	 <20150829021659.GN8051@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-08-29 at 04:16 +0200, Luis R. Rodriguez wrote:
> On Thu, Aug 27, 2015 at 07:54:33PM -0400, Mimi Zohar wrote:
> > On Thu, 2015-08-27 at 23:29 +0200, Luis R. Rodriguez wrote:
> > > On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
> > > > > Luis R. Rodriguez <mcgrof@suse.com> wrote:

> > > > In conversation with Mimi last week she was very keen on the model where
> > > > we load modules & firmware in such a fashion that the kernel has access to
> > > > the original inode -- by passing in a fd,
> > > 
> > > Sure, so let's be specific to ensure what Mimi needs is there. I though there
> > > was work needed on modules but that seems covered and work then seems only
> > > needed for kexec and SELinux policy files (and a review of other possible file
> > > consumers in the kernel) for what you describe. 
> 
> Correct me if I'm wrong:
> 
> > At last year's LSS linux-integrity status update, I mentioned 6
> > measurement/appraisal gaps, kernel modules (linux-3.7), 
> 
> Done.
> 
> > firmware (linux-3.17), 
> 
> I'm working on it, but as far as LSMs are concerned the LSM hook
> is in place.

Right, the LSM hooks are used by LSMs, but also used by the integrity
subsystem, like here, to measure the file and verify the integrity of
the file.    

 int security_kernel_fw_from_file(struct file *file, char *buf, size_t size)
{
        int ret;

        ret = call_int_hook(kernel_fw_from_file, 0, file, buf, size);
        if (ret)
                return ret;
        return ima_fw_from_file(file, buf, size);
}

> > kexec,
> 
> I'll note kexec has both a kernel and initramfs :) so just keep that
> in mind. Technically it should vet for both. It seems we just need
> an LSM hook there.

Distros build the initramfs on the target system, so the initramfs can't
come signed.  But for those systems that the initramfs can be signed, we
should be verifying it.

> > initramfs, 
> 
> Hm, what code path?

In addition, the files within the initramfs should be measured and
verified.   There isn't a need for a new hook, but for xattr support in
CPIO.  I started adding that support last winter -
http://lwn.net/Articles/630101/ .   Others have requested other changes,
not related to xattrs, before bumping the CPIO magic number.   There
should be a discussion as to what else needs to be done.

> > eBPF/seccomp 
> 
> Same here, where's this?
> 
> > and policies,
> 
> Which ones?
> 
> >  that have
> > been or need to be addressed.  Since then, a new kexec syscall, file
> > descriptor based, was upstreamed that appraises the image.  Until we can
> > preserve the measurement list across kexec,
> 
> I'm sorry I do not follow, can you elaborate on what you mean by this.
> Its not clear to me what you mean by the measurement list. Do you mean
> all the above items?
 
A measurement is a hash of the file which is stored in the measurement
list <securityfs>/ima/ascii_runtime_measurements and is used to extend
the TPM (eg. PCR 10).   The measurement list, in conjunction with a
quote of the TPM PCRs, can be used to remotely detect whether a system
has been compromised.

David Safford's white paper "An Overview of the Linux Integrity
subsystem" -
http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf  goes into details of the different terms and concepts. (The IMA wiki is dated.) There's also a ic2e paper titled "Scalable Attestation: a step toward secure and trusted cloud".

> > it doesn't make sense to
> > measure the image just to have it thrown away.  (skipping initramfs as
> > that isn't related to LSM hooks
> 
> Hrm, it can be, I mean at least for the kexec case its a fd that is passed
> as part of the syscall, not sure of the other case you mentioned yet
> as I haven't reviewed that code yet.

Right, in those situations that the initramfs can be signed, it should
be verified.

> >.)  Lastly, measuring/appraising policies
> > (eg. IMA, SELinux, Smack, iptables/ebtables) 
> 
> OK for each of these:
> 
> how do we load the data? 

I'm not real happy about it, but since we can't break the existing ABI
of loading data into the kernel via a buffer, a stop gap method of
signing and verifying a buffer would be needed.

> Is that the full list? Note we should
> be able to use grammar rules to hunt these down, I just haven't
> sat down to write them but if this is important well we should.
> 
> > or any other files consumed
> > by the kernel.
> 
> :D likewise

< skip >

> It'd be good for us to do a further review to really vet *all* areas.
> I am not convinced we've covered them all.

Agreed

Mimi

