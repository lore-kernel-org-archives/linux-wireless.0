Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbbH0TgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 15:36:10 -0400
Date: Thu, 27 Aug 2015 21:36:05 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Paul Moore <paul@paul-moore.com>
Cc: David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	dwmw2@infradead.org, Ming Lei <ming.lei@canonical.com>,
	Joey Lee <jlee@suse.de>,
	=?utf-8?Q?Vojt=C4=9Bch_Pavl=C3=ADk?= <vojtech@suse.com>,
	Gary Ching-Pang Lin <glin@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Linux Firmware Signing
Message-ID: <20150827193605.GD8051@wotan.suse.de> (sfid-20150827_213629_876024_EB361200)
References: <20150824225713.GJ8051@wotan.suse.de>
 <CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
 <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <20150826232622.GC8051@wotan.suse.de>
 <CAHC9VhR9z2WVp+Q1hBkr5jduAH-J1DW12-k7U1eaQGgrP4c1Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHC9VhR9z2WVp+Q1hBkr5jduAH-J1DW12-k7U1eaQGgrP4c1Yw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:35:19PM -0400, Paul Moore wrote:
> On Wed, Aug 26, 2015 at 7:26 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Wed, Aug 26, 2015 at 03:33:04PM +0100, David Howells wrote:
> > Now let's review the SELinux stuff before we jump back into firmware / system
> > data stuff again as there is a joint criteria to consider for all of these.
> > For other people's refrence the enum you quote above was added through your
> > patch pending on linux-next:
> >
> > "PKCS#7: Appropriately restrict authenticated attributes and content type"
> >
> > Based on what Roberts seems to want to do for SELinux policy files it would
> > seems we may also need VERIFYING_SELINUX_POLICY. SELinux policy loading is
> > unique in the at it uses its own fs and uses a load trigger node (sel_load_ops)
> > to kick off  security_load_policy(data, count), so its not exactly a
> > yet-another-API to read arbitrary files from the file system. Its policy files
> > are also very distribution specific. Because of all this its not really
> > suitable for /lib/firmware/ or sharing code even futher. It seems its a prime
> > candidate already to make use of the system_verify_data() APIs you added David,
> > provided the items below are taken care of as well.
> 
> One thing to keep in mind is that not only are SELinux policy files
> distribution specific, they are machine specific as administrators
> can, and do, customize the policy for their usage.  I really like the
> idea of providing signed SELinux policies to the kernel but I question
> how practical it will be for normal users/admins.

Yeah that makes it harder. Possible but harder.

> Some of the Machine Owner Key (MOK) work would likely be necessary for
> signed SELinux policies to be even remotely practical.

Matthew, Peter and Gary are Cc'd, so they can feel free to chime in.

There are other alternatives as well:

 * Is there wide use of SELinux + IMA ? If so that may be another option.

 * The kernel cert stuff can also allow for installing keys *later* which
   could be trusted specifically for SELinux Policy files, but that'd
   mean having to generate / sign these someway up in the food chain.

These are all worth considering not just for SELinux but any other form of
machine-specific data from files which might need to be fed to the kernel.

Are there other use cases other than SELinux policy files?

Anyway, its good we're reviewing this early before patches for SELinux
policy file stuff for signing are brewed. The APIs will be there, but need
to be advanced slightly for firmware signing anyway so there is time for
you folks to think about what route you want to go. If you *do* determine
you need it, it seems pretty easy to handle.

> Assuming I'm understanding the firmwareName attribute idea correctly,
> we don't need to worry about that from a SELinux policy point of view.
> As others have already stated, the kernel just reads a binary blob
> that is pushed into it by userspace using securityfs.

Ah thanks, great, one less thing to think about. So it would just be
the enum and OID that would be needed, should you guys go down the
kernel signing route.

  Luis
