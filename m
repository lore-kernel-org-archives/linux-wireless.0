Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbbICASs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 20:18:48 -0400
Date: Thu, 3 Sep 2015 02:18:44 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
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
	=?utf-8?B?IlZvanTEm2NoIFBhdmzDrWsi?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: Linux Firmware Signing
Message-ID: <20150903001844.GL8051@wotan.suse.de> (sfid-20150903_021909_016775_A4DE70DD)
References: <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <1440719673.2118.84.camel@linux.vnet.ibm.com>
 <20150829021659.GN8051@wotan.suse.de>
 <1441030735.2647.70.camel@linux.vnet.ibm.com>
 <20150901234305.GU8051@wotan.suse.de>
 <1441238053.4172.3.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441238053.4172.3.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 02, 2015 at 07:54:13PM -0400, Mimi Zohar wrote:
> On Wed, 2015-09-02 at 01:43 +0200, Luis R. Rodriguez wrote:
> > On Mon, Aug 31, 2015 at 10:18:55AM -0400, Mimi Zohar wrote:
> > > On Sat, 2015-08-29 at 04:16 +0200, Luis R. Rodriguez wrote:
> > > > On Thu, Aug 27, 2015 at 07:54:33PM -0400, Mimi Zohar wrote:
> > > > > On Thu, 2015-08-27 at 23:29 +0200, Luis R. Rodriguez wrote:
> 
> > Right so there are different solutions to this problem, it will depend on the
> > distribution and solution they have in place for this. For instance maybe some
> > distros may be satisfied with the integrity of the initramfs for kexec *iff*
> > they can vet for the integrity of the components that build the initramfs on
> > the target system, or perhaps they distribute the initramfs used by some
> > systems so they use singing facilities trusted by the kernel, or in the IMA
> > case you do boot up vetting through xatrrs and IMA.
> > 
> > A lot of this means a lot of these signing facilities then should be optional
> > and work in a permissive mode. Part of my earlier work (already merged) on the firmware
> > signing stuff was to take out from module signing code the part that let it be
> > permissive with my goal to re-share the same strategy for other purposes. This
> > is accomplished by using the bool_enable_only module parameter, for instance fw
> > signing will use:
> > 
> > +static bool sysdata_sig_enforce = IS_ENABLED(CONFIG_SYSTEM_DATA_SIG_FORCE);
> > +#ifndef CONFIG_SYSTEM_DATA_SIG_FORCE
> > +module_param(sysdata_sig_enforce, bool_enable_only, 0644);
> > +#endif /* !CONFIG_SYSTEM_DATA_SIG_FORCE */
> > 
> > Technically it should also be possible to remove the #ifndef provided we can
> > all rest assured no bullets can be put through it. Anyway, that's the gist of
> > the permissive model copied from module signing. If we have a lot of similar
> > users it begs the question if we should somehow drivertize a generic interface
> > for these things so that the actual implemenation that deals with permissivity
> > is shared, its perhaps too early to do that now but something to keep in mind
> > as it does sound like we will have a bit of users of the same mechanisms /
> > strategy. Exactly how they need to be differentiated remains to be seen.
> 
> Ok.  Each "hook" would require a separate config option to allow
> flexibility.  With this design, the decision for requiring signatures
> would be made at build.  Do we really want policy hard coded into the
> kernel?   (IMA is policy based.)

The thing is module signing is a policy built into the kernel, and as such
firmware signing is following that tradition as well. The way historically
module signing has evolved over time as LSMs have is through separate
frameworks as such naturally its only now we've started to consider module
signign through the eyes of a possible future core-LSM that others can stack
over. Even with this long term possibility its still a kernel policy. Other
similar functionality will natrally follow suit.

> > > > > initramfs, 
> > > > 
> > > > Hm, what code path?
> > > 
> > > In addition, the files within the initramfs should be measured and
> > > verified.   There isn't a need for a new hook, but for xattr support in
> > > CPIO.  I started adding that support last winter -
> > > http://lwn.net/Articles/630101/ .   Others have requested other changes,
> > > not related to xattrs, before bumping the CPIO magic number.   There
> > > should be a discussion as to what else needs to be done.
> > 
> > I see, thanks. Another way to do this is to copy the module signing
> > strategy and since the initramfs is linked in just peg the sinagure of the
> > blog at the end. This of course would mean you have to be permissive to
> > only enable folks who want this feature.
> 
> At the same time the boot loader verifies the kernel signature, it could
> verify the the initramfs signature.  kexec should emulate whatever the
> boot loader's method for verifying the initramfs signature.

Up to you guys :)

> > > > >  that have
> > > > > been or need to be addressed.  Since then, a new kexec syscall, file
> > > > > descriptor based, was upstreamed that appraises the image.  Until we can
> > > > > preserve the measurement list across kexec,
> > > > 
> > > > I'm sorry I do not follow, can you elaborate on what you mean by this.
> > > > Its not clear to me what you mean by the measurement list. Do you mean
> > > > all the above items?
> > >  
> > > A measurement is a hash of the file which is stored in the measurement
> > > list <securityfs>/ima/ascii_runtime_measurements and is used to extend
> > > the TPM (eg. PCR 10).   The measurement list, in conjunction with a
> > > quote of the TPM PCRs, can be used to remotely detect whether a system
> > > has been compromised.
> > 
> > I see thanks. In light of that its unclear why you'd want to "preserve"
> > the measurement list from one boot onto another.
> 
> The TPM is reset on a hard reboot, not a soft one like kexec.  Without
> preserving the measurement list across kexec, we would not be able to
> validate the quote.

I see. Anyone doing that work?

> > > > >.)  Lastly, measuring/appraising policies
> > > > > (eg. IMA, SELinux, Smack, iptables/ebtables) 
> > > > 
> > > > OK for each of these:
> > > > 
> > > > how do we load the data? 
> > > 
> > > I'm not real happy about it, but since we can't break the existing ABI
> > > of loading data into the kernel via a buffer, a stop gap method of
> > > signing and verifying a buffer would be needed.
> > 
> > Right so if such a solution were really desirable it would seem we'd be
> > wanting to change a histical approach to user <--> kernel interfaces.
> > This is a pretty significant change in paradigm. Is everyone on board?
> 
> Perhaps defining a common method and converting an example or two would
> make sense,  before making sure "everyone" is on board.   The IMA policy
> could be the first. Dmitry has already added support for verifying the
> policy's signature for those systems without an initramfs.  I can look
> into generalizing that solution.

That would be nice. I think you want a pretty board audience review. The
change in paradigm is pretty significant.

  Luis
