Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbbH2B44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 21:56:56 -0400
Date: Sat, 29 Aug 2015 03:56:50 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Paul Moore <paul@paul-moore.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>,
	"selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	Vojtech =?iso-8859-1?Q?Pavl=EDk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Linux Firmware Signing
Message-ID: <20150829015650.GL8051@wotan.suse.de> (sfid-20150829_035731_704416_5135E3AB)
References: <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
 <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
 <31228.1440671938@warthog.procyon.org.uk>
 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
 <20150827212907.GF8051@wotan.suse.de>
 <CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2015 at 11:20:10AM +0000, Roberts, William C wrote:
> > -----Original Message-----
> > From: Paul Moore [mailto:paul@paul-moore.com]
> > 
> > While I question the usefulness of a SELinux policy signature in the general case,
> > there are some situations where it might make sense, e.g. embedded systems
> > with no post-build customizations, and I'm not opposed to added a signature to
> > the policy file for that reason.
> 
> Even triggered updates make sense, since you can at least have some form of trust
> of where that binary policy came from. 

The problem that Paul describes stems from the requirement of such trust
needing post-boot / install / setup keys.  It may be possible for an
environment to exist where there's a food chain that enables some CA's to
easily hand out keys to each install, but that seems impractical. This is why
Paul had mentioned the Machine Owner Key (MOK) thing.

> > However, I haven't given any serious thought yet to how we would structure the
> > new blob format so as to support both signed/unsigned policies as well as
> > existing policies which predate any PKCS #7 changes.
> > 
> 
> Huh, not following? Perhaps, I am not following what your laying down here.
> 
>  Right now there is no signing on the selinux policy file. We should be able
> to just use the firmware signing api's as is (I have not looked on linux-next yet)

Nitpick: its the system_verify_data() API, the fw signing stuff will make use
of this API as well.

> to unpack the blob.

Nitpick: to verify the data.

> In the case of falling back to loading an unsigned blob, we could do it ala kernel
> module style. If it fails do to invalid format fall back to attempting to read it as a straight policy file.
> If it fails on signature verification, we could still unpack it and pass it on. So you would want to 
> be able to control if the signed unpacking from pkcs7 fails, whether or not its fatal.
> 
> We would also likely want to convey this state, the ability to change this setting to userspace in a 
> Controlled fashion via selinuxfs. Ie I would want to know that I can load modules without valid signatures,
> And that my current policy file is in fact invalid or valid.

Sure that would work. Its how the module stuff can work in permissive mode.
We'd embrace the same practice for permissive fw signing as well.

  Luis
