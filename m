Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53246 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbbIAUIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 16:08:47 -0400
From: "Roberts, William C" <william.c.roberts@intel.com>
To: Joshua Brindle <brindle@quarksecurity.com>,
	Paul Moore <paul@paul-moore.com>
CC: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>,
	David Howells <dhowells@redhat.com>,
	Peter Jones <pjones@redhat.com>,
	"selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Kees Cook <keescook@chromium.org>,
	=?iso-8859-1?Q?Vojtech_Pavl=EDk?= <vojtech@suse.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joey Lee <jlee@suse.de>, Kyle McMartin <kyle@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Andy Lutomirski" <luto@amacapital.net>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"David Woodhouse" <dwmw2@infradead.org>
Subject: RE: Linux Firmware Signing
Date: Tue, 1 Sep 2015 20:08:45 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC560105E5D3@ORSMSX103.amr.corp.intel.com> (sfid-20150901_220901_646712_77255FF8)
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
 <CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com>
 <20150829020301.GM8051@wotan.suse.de>
 <CAHC9VhTTRr7N2bqU-7jm2oG72t5wgqH_SmXk4icqs3h3_=EMzg@mail.gmail.com>
 <55E5B257.6070205@quarksecurity.com>
In-Reply-To: <55E5B257.6070205@quarksecurity.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: owner-linux-security-module@vger.kernel.org [mailto:owner-linux-
> security-module@vger.kernel.org] On Behalf Of Joshua Brindle
> Sent: Tuesday, September 1, 2015 7:13 AM
> To: Paul Moore
> Cc: Luis R. Rodriguez; Takashi Iwai; Ming Lei; David Howells; Peter Jones;
> selinux@tycho.nsa.gov; Schaufler, Casey; Stephen Smalley; Matthew Garrett;
> Kees Cook; Vojtech Pavlík; Seth Forshee; james.l.morris@oracle.com; Dmitry
> Kasatkin; Johannes Berg; Joey Lee; Kyle McMartin; linux-
> wireless@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Lutomirski; linux-
> security-module@vger.kernel.org; Greg Kroah-Hartman; Vitaly Kuznetsov; David
> Woodhouse
> Subject: Re: Linux Firmware Signing
> 
> Paul Moore wrote:
> <snip>
> >
> > Yes, there are lots of way we could solve the signed policy format
> > issue, I just don't have one in mind at this moment.  Also, to be
> > honest, there are enough limitations to signing SELinux policies that
> > this isn't very high onmy personal SELinux priority list.

Yes I would say this is low on my end. Especially if we can kill off
Reloadable policy support on Android, my need for this goes away 100%.

> >
> 
> The fact that there are so many userspace specific parts of the policy that never
> make it into the kernel precludes any meaningful verification anyway.

Yes and no. On Android, if I was able to load a policy I could grant myself capabilities that
We're not possible via the userspace portions, i.e. relabeling, etc. Granted, not checking the
userspace portions Is not great. In an ideal world, everything is checked. However, the main
reason to doing it in the kernel is where you want your trust to be. For instance, If I trust that
userspace Loader, then I need to trust that + the kernel. In the case of verifying the policy signature
In the kernel, I need to trust only the kernel.

As far as the desktop environment, I claim ignorance and have no input there.

> 
> And SELinux already has a mechanism for raising the integrity of a process to do
> things like signature checking in userspace, the domain transition. If someone
> wants validation of the SELinux policy they just need to eliminate every domains
> ability to load policy except for a trusted policy loader that does signature
> checking.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
