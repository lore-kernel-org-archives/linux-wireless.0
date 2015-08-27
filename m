Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40502 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbbH0Xyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 19:54:52 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Fri, 28 Aug 2015 05:24:49 +0530
Message-ID: <1440719673.2118.84.camel@linux.vnet.ibm.com> (sfid-20150828_015457_687224_A0B5A348)
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
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 27 Aug 2015 19:54:33 -0400
In-Reply-To: <20150827212907.GF8051@wotan.suse.de>
References: <20150824225713.GJ8051@wotan.suse.de>
	 <CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
	 <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
	 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
	 <1440462367.2737.4.camel@linux.vnet.ibm.com>
	 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	 <1440464705.2737.36.camel@linux.vnet.ibm.com>
	 <14540.1440599584@warthog.procyon.org.uk>
	 <31228.1440671938@warthog.procyon.org.uk>
	 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	 <20150827212907.GF8051@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-27 at 23:29 +0200, Luis R. Rodriguez wrote:
> On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
> > > Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > >
> > >> "PKCS#7: Add an optional authenticated attribute to hold firmware name"
> > >> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e730213good
> > >>
> > >>         1.3.6.1.4.1.2312.16     Linux kernel
> > >>         1.3.6.1.4.1.2312.16.2   - PKCS#7/CMS SignerInfo attribute types
> > >>         1.3.6.1.4.1.2312.16.2.1   - firmwareName
> > >>
> > >> I take it you are referring to this?
> > >
> > > Yes.
> > >
> > >> If we follow this model we'd then need something like:
> > >>
> > >>         1.3.6.1.4.1.2312.16.2.2   - seLinuxPolicyName
> > >>
> > >> That should mean each OID that has different file names would need to be
> > >> explicit about and have a similar entry on the registry. I find that
> > >> pretty redundant and would like to avoid that if possible.
> > >
> > > firmwareName is easy for people to understand - it's the name the kernel
> > > asks for and the filename of the blob.  seLinuxPolicyName is, I think, a
> > > lot more tricky since a lot of people don't use SELinux, and most that do
> > > don't understand it (most people that use it aren't even really aware of
> > > it).
> > >
> > > If you can use the firmwareName as the SELinux/LSM key, I would suggest
> > > doing so - even if you dress it up as a path
> > > (/lib/firmware/<firmwareName>).
> > 
> > In conversation with Mimi last week she was very keen on the model where
> > we load modules & firmware in such a fashion that the kernel has access to
> > the original inode -- by passing in a fd,
> 
> Sure, so let's be specific to ensure what Mimi needs is there. I though there
> was work needed on modules but that seems covered and work then seems only
> needed for kexec and SELinux policy files (and a review of other possible file
> consumers in the kernel) for what you describe. 

At last year's LSS linux-integrity status update, I mentioned 6
measurement/appraisal gaps, kernel modules (linux-3.7), firmware
(linux-3.17), kexec, initramfs, eBPF/seccomp and policies, that have
been or need to be addressed.  Since then, a new kexec syscall, file
descriptor based, was upstreamed that appraises the image.  Until we can
preserve the measurement list across kexec, it doesn't make sense to
measure the image just to have it thrown away.  (skipping initramfs as
that isn't related to LSM hooks.)  Lastly, measuring/appraising policies
(eg. IMA, SELinux, Smack, iptables/ebtables) or any other files consumed
by the kernel.

> I also went ahead and studied
> areas where we can share code now as I was looking at this code now, and also
> would like to recap on the idea of possibly just sharing the same LSM hook
> for all "read this special file from the fs in the kernel" cases. Details below.
> 
> Fortnately the LSM hooks uses struct file and with this you can get the inode
> with this:
> 
> 	struct inode *inode = file_inode(file);
> 
> For modules we have this LSM hook:
> 
> int (*kernel_module_from_file)(struct file *file);
> 
> This can be used for finit_module(). Its used as follows, the fd comes from
> finit_module() syscall.
> 
> SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
> {
> 	...
> 	err = copy_module_from_fd(fd, &info);                                   
> 	if (err)                                                                
> 		return err; 
> 	...
> }
> 
> static int copy_module_from_fd(int fd, struct load_info *info)
> {
> 	struct fd f = fdget(fd);
> 	...
> 	err = security_kernel_module_from_file(f.file);                         
> 	if (err)                                                                
> 		goto out;
> }
> 
> For firmware we have this LSM hook:
> 
> int (*kernel_fw_from_file)(struct file *file, char *buf, size_t size);  
> 
> > or in the firmware case by doing the fs lookup directly.
> 
> Right so now that firmware usermode helper is behind us (systemd ripped it) we
> do the fs lookup directly ourselves. One of my side goals with the extensible
> firmware API was also to allow for us to take a leap and let drivers
> skip completely the usermode helper so we can then phase that code to the
> only required remainign user: the dell-rbu driver. Anyway, once we have the
> path built up we use it as follows.
> 
> static int fw_read_file(const char *path, void **_buf, size_t *_size)           
> {
> 	struct file *file;
> 	...
> 	file = filp_open(path, O_RDONLY, 0);                                    
> 	if (IS_ERR(file))                                                       
> 		return PTR_ERR(file);  
> 	...
> 	rc = security_kernel_fw_from_file(file, buf, size);                     
> 	if (rc)                                                                 
> 		goto err_buf;  
> 	...
> }
> 
> I was under the impression that work was needed to add an LSM hook which would
> grant the LSM access to the file specific data for modules but that's already
> there with finit_module()! So Mimi needs is already there for modules as well
> now.
> 
> We have no LSM hook for kexec, even though the kernel does have access to the
> fd, so if you wanted the struct file for an LSM it should be possible as the
> syscall for kexec is:
> 
> SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,                
>                 unsigned long, cmdline_len, const char __user *, cmdline_ptr,   
>                 unsigned long, flags) 
> {
> 	...
> }
> 
> I noted earlier however that kexec is currently an x86 thing only though, and
> Howells clarified that this is because we want kernel image signing as an
> option (its a Kconfig option), and only PE supports a built-in signing method.
> Its unclear to me who extends ELF and if its worthwhile to consider adding
> support there for a signing method. Howells noted that there are rumours other
> archs would support kexec, its unclear what they would use.
> 
> Even though kexec remains x86 specific an LSM for it should easily be possible
> to add, but more on this below...

> > So surely you have all the SELinux labelling you need?
> 
> SELinux uses: security_load_policy(data, len), refer to selinuxfs sel_load_ops.
> Since its write operation on its file_operation is sel_write_load() and that
> is as follows:
> 
> static ssize_t sel_write_load(struct file *file, const char __user *buf,        
> 			      size_t count, loff_t *ppos) 
> {
> 	...
> }
> 
> We should be able to add yet-another LSM hook here to let the kernel / LSM have
> access to the inode, is that LSM hook desirable ?

Reading files from the kernel was frowned upon until recently.  So both
SELinux and IMA, not sure about Smack,  read the policy from userspace
into memory and pass it to the kernel.  The 'file' defined here is not
the policy itself, but the selinuxfs file.  'buf' contains the policy.
I'm obviously in favor of such a change, as it would allow us to both
measure and appraise the policy.

>  But folks, before you answer
> note that there's a growing trend here! Its point 1 Kees had made earlier.  I
> was hesitant to go into details as I think fw signing needs to be baked first
> but.. since we're reviewing all these details now it seems logical to go down
> the rabbit hole further.
> 
> Everywhere where we fetch a file from within the kernel either directly (say
> firmware load, 802.11 regulatory request) or from userspace request (SELinux
> policy load node) we end up having to sprinkle a new LSM hook. In fact for
> modules and kexec there were syscalls added too. There might be a possiblity
> for sharing some of these requests / code so some review is in order for it.

Instead of passing a buffer, the new syscalls are called with the file
descriptor.   This allows the file to be both measured and appraised.

> Here's my review if we wanted to try sharing things, in consideration and
> review of:
> 
>   * SELinux policy files
>   * modules
>   * firmware / system data (consider replacing CRDA)
>   * kexec
> 
> ----
> 
>   * SELinux policy files:
> 
> sel_write_load() is very specific, its part of the selinuxfs and it just
> uses copy_from_user() to dump the data from the file onto a vmalloc'd
> piece of memory. We don't exactly read arbitrary files from the fs then.
> If we *really* wanted to generalize things further we probably could
> but I'm not going to lead any discussion about design over selinuxfs,
> I'll let the folks behind it think about that themselves.
> 
>   * modules
>   * firmware / system data
> 
> modules + firmware: there seems to be some code sharing we could possibly do
> for both fw_read_file() and copy_module_from_fd(), note we are going to use
> different keys for vetting each of these. It may be possible to share the
> LSM hook here. All parties would just need to agree.

Depending on the calling function, different validation requirements may
be desirable.  I would include the calling function (existing hook).
For example, IMA-appraisal permits files to be hashed or signed.
Depending on the calling function, a hash might be acceptable for some,
but all of the hooks.

>   * kexec
> 
> kexec works by reading files and setting up pointers for the different
> segments it needs for bootup, it does this for both the kernel and initrd
> if present. It however uses its own copy_file_from_fd() routine and no
> surprise here, there's code that can be shared as well. We'd be using
> a separate signature for kexec, so that'd be vetted on its own already.
> It may be possible to share the same LSM hook here, again all parties
> would just need to agree.
> 
> ----
> 
> So conclusion:
> 
> After fw signing gets baked (or I'll do that as I work with the system data
> helpers) there is possible work here to consolidate firmware's fw_read_file(),
> module's fw_read_file(), and kexec's copy_file_from_fd() into a core kernel
> tiny helper that gets it done right for all. If we really wanted to we could
> also just use the same LSM hook for all, this hook would surely have the
> struct file as Mimi wants as well. Unless I misunderstood things, at the
> Linux security summit it seemed folks thought this was reasonable and
> desirable. One of the gains then would be that the kernel can grow for
> different use cases and files can be fetched as needed but we wouldn't have to
> add yet-another-LSM hook for each new purpose, we'd just be sharing the same
> fetch / LSM hook. Please discuss and let me know if this still stands, I'll
> work towards any agreed upon direction with the fw signing code.

Thank you for coordinating this.

> And again, there may other parts of the kernel that do similar work, just
> as we found out about SELinux policy files. Those need to be identified
> and studied separatley. I guess we can use grammar to hunt these down.

I mentioned a few others above.

Mimi


