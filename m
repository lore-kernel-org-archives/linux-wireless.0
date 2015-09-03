Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60934 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbICDBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 23:01:13 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 3 Sep 2015 08:31:11 +0530
Message-ID: <1441249230.4172.75.camel@linux.vnet.ibm.com> (sfid-20150903_050145_738987_138FAE5B)
Subject: Re: Linux Firmware Signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
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
	=?UTF-8?Q?Vojt=C4=9Bch_Pavl=C3=ADk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 02 Sep 2015 23:00:30 -0400
In-Reply-To: <20150903002914.GM8051@wotan.suse.de>
References: <1440464705.2737.36.camel@linux.vnet.ibm.com>
	 <14540.1440599584@warthog.procyon.org.uk>
	 <31228.1440671938@warthog.procyon.org.uk>
	 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	 <20150827212907.GF8051@wotan.suse.de>
	 <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
	 <20150902000915.GW8051@wotan.suse.de>
	 <1441164905.17898.86.camel@linux.vnet.ibm.com>
	 <20150902184604.GB8051@wotan.suse.de>
	 <1441238736.4172.12.camel@linux.vnet.ibm.com>
	 <20150903002914.GM8051@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-09-03 at 02:29 +0200, Luis R. Rodriguez wrote:
> On Wed, Sep 02, 2015 at 08:05:36PM -0400, Mimi Zohar wrote:
> > On Wed, 2015-09-02 at 20:46 +0200, Luis R. Rodriguez wrote:
> > > On Tue, Sep 01, 2015 at 11:35:05PM -0400, Mimi Zohar wrote:

> > > We want something that is not only useful for IMA but any other LSM,
> > > and FILE_CHECK seems very broad, not sure what BPRM_CHECK is even upon
> > > inspecting kernel code. Likewise for POST_SETATTR. POLICY_CHECK might
> > > be broad, perhaps its best we define then a generic set of enums to
> > > which IMA can map them to then and let it decide. This would ensure
> > > that the kernel defines each use caes for file inspection carefully,
> > > documents and defines them and if an LSM wants to bunch a set together
> > > it can do so easily with a switch statement to map set of generic
> > > file checks in kernel to a group it already handles.
> > 
> > The names are based on the calling security hook.   For a description of
> > each of these security hooks refer to include/linux/lsm_hooks.h.
> 
> I see, thanks, ok so BPRM_CHECK = for binary loading, are you folks
> really wanting to unify LSM hooks for firmware, modules, and binary
> data ?

You're asking me?!  From my point of view that it is already unified.
The same mechanism used for appraising files in general could be used
for appraising those mentioned.  :) 

The main issue is having the file data and metadata (eg. signatures)
distributed together.  Thanks to Fionnula and Florian support for
including file signatures in rpm packages was released today -
http://lists.rpm.org/pipermail/rpm-maint/2015-September/003962.html.

> POST_SETATTR seems to be for inode_post_setxattr, so that as well?

No.  The IMA policy rules can be defined in terms of file metadata (eg.
uid).  Changing the file metadata might result in files that previously
weren't appraised, now need to be appraised.   The EVM security xattr is
an hmac of the file metadata.  So that needs to be updated to reflect
the change.

> POLICY_CHECK seems broad, not sure what to relate that to exactly.
> Is this just SELinux polify files? Or is this something more broad?

This hook is currently limited to verifying the IMA policy signature,
but could be the basis for a more generalized hook.

Mimi

