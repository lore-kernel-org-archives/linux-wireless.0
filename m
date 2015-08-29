Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbbH2CDE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 22:03:04 -0400
Date: Sat, 29 Aug 2015 04:03:01 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Paul Moore <paul@paul-moore.com>
Cc: "Roberts, William C" <william.c.roberts@intel.com>,
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
Message-ID: <20150829020301.GM8051@wotan.suse.de> (sfid-20150829_040327_582345_69952F47)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2015 at 06:26:05PM -0400, Paul Moore wrote:
> On Fri, Aug 28, 2015 at 7:20 AM, Roberts, William C
> <william.c.roberts@intel.com> wrote:
> > Even triggered updates make sense, since you can at least have some form of trust
> > of where that binary policy came from.
> 
> It isn't always that simple, see my earlier comments about
> customization and manipulation by the policy loading tools.

If the customization of the data is done in kernel then the kernel
can *first* verify the file's signature prior to doing any data
modification. If userspace does the modification then the signature
stuff won't work unless the tool will have access to the MOK and can
sign it pre-flight to the kernel selinuxfs.

> > Huh, not following? Perhaps, I am not following what your laying down here.
> >
> >  Right now there is no signing on the selinux policy file. We should be able
> > to just use the firmware signing api's as is (I have not looked on linux-next yet)
> > to unpack the blob.
> 
> I haven't looked at the existing fw signing hook in any detail to be
> able to comment on its use as a policy verification hook.  As long as
> we preserve backwards compatibility and don't introduce a new
> mechanism/API for loading SELinux policy I doubt I would have any
> objections.

You'd just have to implement a permissive model as we are with the
fw signing. No radical customizations, except one thing to note is
that on the fw signing side of things we're going to have the signature
of the file *detached* in separate file. I think what you're alluding
to is the issue of where that signature would be stuff in the SELinux
policy file and its correct that you'd need to address that. You could
just borrow the kernel's model and reader / sucker that strips out the
signature. Another possibility would be two files but then I guess
you'd need a trigger to annotate both are in place.

  Luis
