Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbbH2CRD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 22:17:03 -0400
Date: Sat, 29 Aug 2015 04:16:59 +0200
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
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: Linux Firmware Signing
Message-ID: <20150829021659.GN8051@wotan.suse.de> (sfid-20150829_041726_994681_4FC94200)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440719673.2118.84.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2015 at 07:54:33PM -0400, Mimi Zohar wrote:
> On Thu, 2015-08-27 at 23:29 +0200, Luis R. Rodriguez wrote:
> > On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
> > > > Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > > >
> > > >> "PKCS#7: Add an optional authenticated attribute to hold firmware name"
> > > >> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e730213good
> > > >>
> > > >>         1.3.6.1.4.1.2312.16     Linux kernel
> > > >>         1.3.6.1.4.1.2312.16.2   - PKCS#7/CMS SignerInfo attribute types
> > > >>         1.3.6.1.4.1.2312.16.2.1   - firmwareName
> > > >>
> > > >> I take it you are referring to this?
> > > >
> > > > Yes.
> > > >
> > > >> If we follow this model we'd then need something like:
> > > >>
> > > >>         1.3.6.1.4.1.2312.16.2.2   - seLinuxPolicyName
> > > >>
> > > >> That should mean each OID that has different file names would need to be
> > > >> explicit about and have a similar entry on the registry. I find that
> > > >> pretty redundant and would like to avoid that if possible.
> > > >
> > > > firmwareName is easy for people to understand - it's the name the kernel
> > > > asks for and the filename of the blob.  seLinuxPolicyName is, I think, a
> > > > lot more tricky since a lot of people don't use SELinux, and most that do
> > > > don't understand it (most people that use it aren't even really aware of
> > > > it).
> > > >
> > > > If you can use the firmwareName as the SELinux/LSM key, I would suggest
> > > > doing so - even if you dress it up as a path
> > > > (/lib/firmware/<firmwareName>).
> > > 
> > > In conversation with Mimi last week she was very keen on the model where
> > > we load modules & firmware in such a fashion that the kernel has access to
> > > the original inode -- by passing in a fd,
> > 
> > Sure, so let's be specific to ensure what Mimi needs is there. I though there
> > was work needed on modules but that seems covered and work then seems only
> > needed for kexec and SELinux policy files (and a review of other possible file
> > consumers in the kernel) for what you describe. 

Correct me if I'm wrong:

> At last year's LSS linux-integrity status update, I mentioned 6
> measurement/appraisal gaps, kernel modules (linux-3.7), 

Done.

> firmware (linux-3.17), 

I'm working on it, but as far as LSMs are concerned the LSM hook
is in place.

> kexec,

I'll note kexec has both a kernel and initramfs :) so just keep that
in mind. Technically it should vet for both. It seems we just need
an LSM hook there.

> initramfs, 

Hm, what code path?

> eBPF/seccomp 

Same here, where's this?

> and policies,

Which ones?

>  that have
> been or need to be addressed.  Since then, a new kexec syscall, file
> descriptor based, was upstreamed that appraises the image.  Until we can
> preserve the measurement list across kexec,

I'm sorry I do not follow, can you elaborate on what you mean by this.
Its not clear to me what you mean by the measurement list. Do you mean
all the above items?

> it doesn't make sense to
> measure the image just to have it thrown away.  (skipping initramfs as
> that isn't related to LSM hooks

Hrm, it can be, I mean at least for the kexec case its a fd that is passed
as part of the syscall, not sure of the other case you mentioned yet
as I haven't reviewed that code yet.

>.)  Lastly, measuring/appraising policies
> (eg. IMA, SELinux, Smack, iptables/ebtables) 

OK for each of these:

how do we load the data? Is that the full list? Note we should
be able to use grammar rules to hunt these down, I just haven't
sat down to write them but if this is important well we should.

> or any other files consumed
> by the kernel.

:D likewise

> > I also went ahead and studied
> > areas where we can share code now as I was looking at this code now, and also
> > would like to recap on the idea of possibly just sharing the same LSM hook
> > for all "read this special file from the fs in the kernel" cases. Details below.
> > 
> > Fortnately the LSM hooks uses struct file and with this you can get the inode
> > with this:
> > 
> > 	struct inode *inode = file_inode(file);
> > 
> > For modules we have this LSM hook:
> > 
> > int (*kernel_module_from_file)(struct file *file);
> > 
> > This can be used for finit_module(). Its used as follows, the fd comes from
> > finit_module() syscall.
> > 
> > SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
> > {
> > 	...
> > 	err = copy_module_from_fd(fd, &info);                                   
> > 	if (err)                                                                
> > 		return err; 
> > 	...
> > }
> > 
> > static int copy_module_from_fd(int fd, struct load_info *info)
> > {
> > 	struct fd f = fdget(fd);
> > 	...
> > 	err = security_kernel_module_from_file(f.file);                         
> > 	if (err)                                                                
> > 		goto out;
> > }
> > 
> > For firmware we have this LSM hook:
> > 
> > int (*kernel_fw_from_file)(struct file *file, char *buf, size_t size);  
> > 
> > > or in the firmware case by doing the fs lookup directly.
> > 
> > Right so now that firmware usermode helper is behind us (systemd ripped it) we
> > do the fs lookup directly ourselves. One of my side goals with the extensible
> > firmware API was also to allow for us to take a leap and let drivers
> > skip completely the usermode helper so we can then phase that code to the
> > only required remainign user: the dell-rbu driver. Anyway, once we have the
> > path built up we use it as follows.
> > 
> > static int fw_read_file(const char *path, void **_buf, size_t *_size)           
> > {
> > 	struct file *file;
> > 	...
> > 	file = filp_open(path, O_RDONLY, 0);                                    
> > 	if (IS_ERR(file))                                                       
> > 		return PTR_ERR(file);  
> > 	...
> > 	rc = security_kernel_fw_from_file(file, buf, size);                     
> > 	if (rc)                                                                 
> > 		goto err_buf;  
> > 	...
> > }
> > 
> > I was under the impression that work was needed to add an LSM hook which would
> > grant the LSM access to the file specific data for modules but that's already
> > there with finit_module()! So Mimi needs is already there for modules as well
> > now.
> > 
> > We have no LSM hook for kexec, even though the kernel does have access to the
> > fd, so if you wanted the struct file for an LSM it should be possible as the
> > syscall for kexec is:
> > 
> > SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,                
> >                 unsigned long, cmdline_len, const char __user *, cmdline_ptr,   
> >                 unsigned long, flags) 
> > {
> > 	...
> > }
> > 
> > I noted earlier however that kexec is currently an x86 thing only though, and
> > Howells clarified that this is because we want kernel image signing as an
> > option (its a Kconfig option), and only PE supports a built-in signing method.
> > Its unclear to me who extends ELF and if its worthwhile to consider adding
> > support there for a signing method. Howells noted that there are rumours other
> > archs would support kexec, its unclear what they would use.
> > 
> > Even though kexec remains x86 specific an LSM for it should easily be possible
> > to add, but more on this below...
> 
> > > So surely you have all the SELinux labelling you need?
> > 
> > SELinux uses: security_load_policy(data, len), refer to selinuxfs sel_load_ops.
> > Since its write operation on its file_operation is sel_write_load() and that
> > is as follows:
> > 
> > static ssize_t sel_write_load(struct file *file, const char __user *buf,        
> > 			      size_t count, loff_t *ppos) 
> > {
> > 	...
> > }
> > 
> > We should be able to add yet-another LSM hook here to let the kernel / LSM have
> > access to the inode, is that LSM hook desirable ?
> 
> Reading files from the kernel was frowned upon until recently.

Well, to be clear there is an exception that was made to firmware and that
reads things from /lib/firmware. Then other than this we have modules, kexec.
SELinuxfs uses its own fs... not sure of others.

Note, CRDA does have a custom path and userspace reads it from a custom
path, then tosses it via netlink to the kernel, I'm changing that to just
use /lib/firmware/ and repurpose the firmware API calls as generic "system data"
fetchers. But this is just because we found it reasonable for us to deploy
the regulatory.bin file into /lib/firmware.

A review would be needed for the other users. People can't just assume they
can use /lib/firmware for everything. I mean, its used now even for CPU
microcode so... just keep that in mind ;)

> So both
> SELinux and IMA, not sure about Smack,  read the policy from userspace
> into memory and pass it to the kernel.

That's how CRDA works too but we never implemetned a filesystem just to toss
things to the kernel, we however did have hooks for a netlink API to send it.
The userspace agent vetted for the file's integrity. We'll be switching this
to have the file vetted through a signature which we trust in the kernel.

What each of these do is up to them.

> The 'file' defined here is not
> the policy itself, but the selinuxfs file.  'buf' contains the policy.
> I'm obviously in favor of such a change, as it would allow us to both
> measure and appraise the policy.

Right, some technicalities in the implementation, but still its a file.

> >  But folks, before you answer
> > note that there's a growing trend here! Its point 1 Kees had made earlier.  I
> > was hesitant to go into details as I think fw signing needs to be baked first
> > but.. since we're reviewing all these details now it seems logical to go down
> > the rabbit hole further.
> > 
> > Everywhere where we fetch a file from within the kernel either directly (say
> > firmware load, 802.11 regulatory request) or from userspace request (SELinux
> > policy load node) we end up having to sprinkle a new LSM hook. In fact for
> > modules and kexec there were syscalls added too. There might be a possiblity
> > for sharing some of these requests / code so some review is in order for it.
> 
> Instead of passing a buffer, the new syscalls are called with the file
> descriptor.   This allows the file to be both measured and appraised.

Right!

> > Here's my review if we wanted to try sharing things, in consideration and
> > review of:
> > 
> >   * SELinux policy files
> >   * modules
> >   * firmware / system data (consider replacing CRDA)
> >   * kexec
> > 
> > ----
> > 
> >   * SELinux policy files:
> > 
> > sel_write_load() is very specific, its part of the selinuxfs and it just
> > uses copy_from_user() to dump the data from the file onto a vmalloc'd
> > piece of memory. We don't exactly read arbitrary files from the fs then.
> > If we *really* wanted to generalize things further we probably could
> > but I'm not going to lead any discussion about design over selinuxfs,
> > I'll let the folks behind it think about that themselves.
> > 
> >   * modules
> >   * firmware / system data
> > 
> > modules + firmware: there seems to be some code sharing we could possibly do
> > for both fw_read_file() and copy_module_from_fd(), note we are going to use
> > different keys for vetting each of these. It may be possible to share the
> > LSM hook here. All parties would just need to agree.
> 
> Depending on the calling function, different validation requirements may
> be desirable.  I would include the calling function (existing hook).

Seems reasonable to me. May require some macro hackery, not sure.

> For example, IMA-appraisal permits files to be hashed or signed.
> Depending on the calling function, a hash might be acceptable for some,
> but all of the hooks.

OK thanks will keep this in mind.

> >   * kexec
> > 
> > kexec works by reading files and setting up pointers for the different
> > segments it needs for bootup, it does this for both the kernel and initrd
> > if present. It however uses its own copy_file_from_fd() routine and no
> > surprise here, there's code that can be shared as well. We'd be using
> > a separate signature for kexec, so that'd be vetted on its own already.
> > It may be possible to share the same LSM hook here, again all parties
> > would just need to agree.
> > 
> > ----
> > 
> > So conclusion:
> > 
> > After fw signing gets baked (or I'll do that as I work with the system data
> > helpers) there is possible work here to consolidate firmware's fw_read_file(),
> > module's fw_read_file(), and kexec's copy_file_from_fd() into a core kernel
> > tiny helper that gets it done right for all. If we really wanted to we could
> > also just use the same LSM hook for all, this hook would surely have the
> > struct file as Mimi wants as well. Unless I misunderstood things, at the
> > Linux security summit it seemed folks thought this was reasonable and
> > desirable. One of the gains then would be that the kernel can grow for
> > different use cases and files can be fetched as needed but we wouldn't have to
> > add yet-another-LSM hook for each new purpose, we'd just be sharing the same
> > fetch / LSM hook. Please discuss and let me know if this still stands, I'll
> > work towards any agreed upon direction with the fw signing code.
> 
> Thank you for coordinating this.

Sure and thanks for the feedback.

> > And again, there may other parts of the kernel that do similar work, just
> > as we found out about SELinux policy files. Those need to be identified
> > and studied separatley. I guess we can use grammar to hunt these down.
> 
> I mentioned a few others above.

It'd be good for us to do a further review to really vet *all* areas.
I am not convinced we've covered them all.

  Luis
