Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbIAXnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 19:43:10 -0400
Date: Wed, 2 Sep 2015 01:43:05 +0200
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
Message-ID: <20150901234305.GU8051@wotan.suse.de> (sfid-20150902_014328_062998_1A013E88)
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <1440719673.2118.84.camel@linux.vnet.ibm.com>
 <20150829021659.GN8051@wotan.suse.de>
 <1441030735.2647.70.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441030735.2647.70.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2015 at 10:18:55AM -0400, Mimi Zohar wrote:
> On Sat, 2015-08-29 at 04:16 +0200, Luis R. Rodriguez wrote:
> > On Thu, Aug 27, 2015 at 07:54:33PM -0400, Mimi Zohar wrote:
> > > On Thu, 2015-08-27 at 23:29 +0200, Luis R. Rodriguez wrote:
> > > > On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
> > > > > > Luis R. Rodriguez <mcgrof@suse.com> wrote:
> 
> > > > > In conversation with Mimi last week she was very keen on the model where
> > > > > we load modules & firmware in such a fashion that the kernel has access to
> > > > > the original inode -- by passing in a fd,
> > > > 
> > > > Sure, so let's be specific to ensure what Mimi needs is there. I though there
> > > > was work needed on modules but that seems covered and work then seems only
> > > > needed for kexec and SELinux policy files (and a review of other possible file
> > > > consumers in the kernel) for what you describe. 
> > 
> > Correct me if I'm wrong:
> > 
> > > At last year's LSS linux-integrity status update, I mentioned 6
> > > measurement/appraisal gaps, kernel modules (linux-3.7), 
> > 
> > Done.
> > 
> > > firmware (linux-3.17), 
> > 
> > I'm working on it, but as far as LSMs are concerned the LSM hook
> > is in place.
> 
> Right, the LSM hooks are used by LSMs, but also used by the integrity
> subsystem, like here, to measure the file and verify the integrity of
> the file.    

Great.

>  int security_kernel_fw_from_file(struct file *file, char *buf, size_t size)
> {
>         int ret;
> 
>         ret = call_int_hook(kernel_fw_from_file, 0, file, buf, size);
>         if (ret)
>                 return ret;
>         return ima_fw_from_file(file, buf, size);
> }
> 
> > > kexec,
> > 
> > I'll note kexec has both a kernel and initramfs :) so just keep that
> > in mind. Technically it should vet for both. It seems we just need
> > an LSM hook there.
> 
> Distros build the initramfs on the target system, so the initramfs can't
> come signed.

This seems to apply for some distributions.

> But for those systems that the initramfs can be signed, we
> should be verifying it.

Right so there are different solutions to this problem, it will depend on the
distribution and solution they have in place for this. For instance maybe some
distros may be satisfied with the integrity of the initramfs for kexec *iff*
they can vet for the integrity of the components that build the initramfs on
the target system, or perhaps they distribute the initramfs used by some
systems so they use singing facilities trusted by the kernel, or in the IMA
case you do boot up vetting through xatrrs and IMA.

A lot of this means a lot of these signing facilities then should be optional
and work in a permissive mode. Part of my earlier work (already merged) on the firmware
signing stuff was to take out from module signing code the part that let it be
permissive with my goal to re-share the same strategy for other purposes. This
is accomplished by using the bool_enable_only module parameter, for instance fw
signing will use:

+static bool sysdata_sig_enforce = IS_ENABLED(CONFIG_SYSTEM_DATA_SIG_FORCE);
+#ifndef CONFIG_SYSTEM_DATA_SIG_FORCE
+module_param(sysdata_sig_enforce, bool_enable_only, 0644);
+#endif /* !CONFIG_SYSTEM_DATA_SIG_FORCE */

Technically it should also be possible to remove the #ifndef provided we can
all rest assured no bullets can be put through it. Anyway, that's the gist of
the permissive model copied from module signing. If we have a lot of similar
users it begs the question if we should somehow drivertize a generic interface
for these things so that the actual implemenation that deals with permissivity
is shared, its perhaps too early to do that now but something to keep in mind
as it does sound like we will have a bit of users of the same mechanisms /
strategy. Exactly how they need to be differentiated remains to be seen.

> > > initramfs, 
> > 
> > Hm, what code path?
> 
> In addition, the files within the initramfs should be measured and
> verified.   There isn't a need for a new hook, but for xattr support in
> CPIO.  I started adding that support last winter -
> http://lwn.net/Articles/630101/ .   Others have requested other changes,
> not related to xattrs, before bumping the CPIO magic number.   There
> should be a discussion as to what else needs to be done.

I see, thanks. Another way to do this is to copy the module signing
strategy and since the initramfs is linked in just peg the sinagure of the
blog at the end. This of course would mean you have to be permissive to
only enable folks who want this feature.

> > > eBPF/seccomp 

OK I knew nothing about this but I just looked into it, here are my notes:

  * old BPF - how far do we want to go? This goes so far as to parsing
    user passed void __user *arg data through ioctls which typically
    gets copy_from_user()'d and eventually gets BPF_PROG_RUN().

  * eBPF:
	                     seccomp() & prctl_set_seccomp()
					|
					V
	                     do_seccomp()
					|
					V
	                     seccomp_set_mode_filter()
					|
					V
	                     seccomp_prepare_user_filter()
					|
	                                V
	bpf_prog_create_from_user() (seccomp) \
	bpf_prog_create()                      > bpf_prepare_filter()
	sk_attach_filter()                    /

    All approaches come from user passed data, nothing fd based.

    For both old BPF and eBPF then:

    If we wanted to be paranoid I suppose the Machine Owner Key (MOK)
    Paul had mentioned up could be used to vet for passed filters, or
    a new interface to enable fd based filters. This really would limit
    the dynamic nature of these features though.

    eBPF / secccomp would not be the only place in the kernel that would have
    issues with user passed data, we have tons of places the same applies so
    implicating the old BPF / eBPF / seccomp approaches can easily implicate
    many other areas of the kernel, that's pretty huge but from the looks of
    it below you seem to enable that to be a possibility for us to consider.

> > > and policies,
> > 
> > Which ones?

Again not clear which ones.

> > >  that have
> > > been or need to be addressed.  Since then, a new kexec syscall, file
> > > descriptor based, was upstreamed that appraises the image.  Until we can
> > > preserve the measurement list across kexec,
> > 
> > I'm sorry I do not follow, can you elaborate on what you mean by this.
> > Its not clear to me what you mean by the measurement list. Do you mean
> > all the above items?
>  
> A measurement is a hash of the file which is stored in the measurement
> list <securityfs>/ima/ascii_runtime_measurements and is used to extend
> the TPM (eg. PCR 10).   The measurement list, in conjunction with a
> quote of the TPM PCRs, can be used to remotely detect whether a system
> has been compromised.

I see thanks. In light of that its unclear why you'd want to "preserve"
the measurement list from one boot onto another.

> David Safford's white paper "An Overview of the Linux Integrity
> subsystem" -
> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf  goes into details of the different terms and concepts. (The IMA wiki is dated.) There's also a ic2e paper titled "Scalable Attestation: a step toward secure and trusted cloud".
> 
> > > it doesn't make sense to
> > > measure the image just to have it thrown away.  (skipping initramfs as
> > > that isn't related to LSM hooks
> > 
> > Hrm, it can be, I mean at least for the kexec case its a fd that is passed
> > as part of the syscall, not sure of the other case you mentioned yet
> > as I haven't reviewed that code yet.
> 
> Right, in those situations that the initramfs can be signed, it should
> be verified.

OK.

> > >.)  Lastly, measuring/appraising policies
> > > (eg. IMA, SELinux, Smack, iptables/ebtables) 
> > 
> > OK for each of these:
> > 
> > how do we load the data? 
> 
> I'm not real happy about it, but since we can't break the existing ABI
> of loading data into the kernel via a buffer, a stop gap method of
> signing and verifying a buffer would be needed.

Right so if such a solution were really desirable it would seem we'd be
wanting to change a histical approach to user <--> kernel interfaces.
This is a pretty significant change in paradigm. Is everyone on board?

> > Is that the full list? Note we should
> > be able to use grammar rules to hunt these down, I just haven't
> > sat down to write them but if this is important well we should.
> > 
> > > or any other files consumed
> > > by the kernel.
> > 
> > :D likewise
> 
> < skip >
> 
> > It'd be good for us to do a further review to really vet *all* areas.
> > I am not convinced we've covered them all.
> 
> Agreed

  Luis
