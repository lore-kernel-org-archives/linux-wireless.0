Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbIBAJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 20:09:18 -0400
Date: Wed, 2 Sep 2015 02:09:15 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Kees Cook <keescook@chromium.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
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
Message-ID: <20150902000915.GW8051@wotan.suse.de> (sfid-20150902_020922_128466_F4575D37)
References: <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
 <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2015 at 01:20:37PM -0700, Kees Cook wrote:
> On Thu, Aug 27, 2015 at 2:29 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Thu, Aug 27, 2015 at 10:57:23AM -0000, David Woodhouse wrote:
> > Right so now that firmware usermode helper is behind us (systemd ripped it) we
> > do the fs lookup directly ourselves. One of my side goals with the extensible
> 
> Totally agreed: nothing uses the usermode helper any more, so we
> should ignore that moving forward.

Great the patches I have in place for the system data helpers let us
deprecate this and put that code in a dark corner.

> > We have no LSM hook for kexec, even though the kernel does have access to the
> > fd, so if you wanted the struct file for an LSM it should be possible as the
> > syscall for kexec is:
> 
> I can send a patch to add this; it should be trivial. :) (It's not
> high on my TODO list at the moment just because Chrome OS doesn't use
> kexec.)

If there are no users for it and since we are talking about bringing
things together I'd prefer if we try to come up with a shared solution
for that as it seems it can wait for kexec.

> > Everywhere where we fetch a file from within the kernel either directly (say
> > firmware load, 802.11 regulatory request) or from userspace request (SELinux
> > policy load node) we end up having to sprinkle a new LSM hook. In fact for
> > modules and kexec there were syscalls added too. There might be a possiblity
> > for sharing some of these requests / code so some review is in order for it.
> 
> Those syscalls were needed because the original ones were designed a
> long time ago. :)

OK fine :)

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
> As long as the LSM know what kind of file it's loading, and has access
> to the fd (and for IMA, the blob loaded from that fd), that should be
> everything it needs. IMA has the name and blob, loadpin has the fd,
> and a future signature-checking LSM could be able to look up signature
> type from the load type, and split the key off (or fetch the key file)
> itself.

OK great, I think that instead of passing the actual routine name we should
instead pass an enum type for to the LSM, that'd be easier to parse and we'd
then have each case well documented. Each LSM then could add its own
documetnation for this and can switch on it. If we went with a name we'd have
to to use something like __func__ and then parse that, its not clear if we need
to get that specific.

> If we expect to stack signature checkers, we can optimize the
> signature parsing/loading infrastructure then. But since we have
> neither the sigchecking LSM nor multiple ones, we can leave that to
> later.

Sure.

  Luis
