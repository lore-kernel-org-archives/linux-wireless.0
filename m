Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbcHCRno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 13:43:44 -0400
Date: Wed, 3 Aug 2016 19:10:44 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	"mmarek@suse.com" <mmarek@suse.com>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160803171044.GP3296@wotan.suse.de> (sfid-20160803_194351_166219_FA282CB9)
References: <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com>
 <20160722221523.GM5537@wotan.suse.de>
 <874m738m02.fsf@kamboji.qca.qualcomm.com>
 <20160802141610.GJ3296@wotan.suse.de>
 <ae734397-6179-d0ba-3d8a-0cffc63a0fd8@broadcom.com>
 <20160803142119.GL3296@wotan.suse.de>
 <87ziot51x9.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ziot51x9.fsf@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2016 at 03:04:39PM +0000, Valo, Kalle wrote:
> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> 
> > On Wed, Aug 03, 2016 at 01:33:31PM +0200, Arend van Spriel wrote:
> >> On 02-08-16 16:16, Luis R. Rodriguez wrote:
> >> > On Tue, Aug 02, 2016 at 11:10:22AM +0000, Valo, Kalle wrote:
> >> >> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> >> >>
> >> >>> I was considering this as a future extension to the firmware API
> >> >>> through the new extensible firmware API, the sysdata API.
> >> >>
> >> >> I think Linus mentioned this already, but I want to reiterate anyway.
> >> >> The name "sysdata" is horrible, I didn't have any idea what it means
> >> >> until I read your description. Please continue to use the term
> >> >> "firmware", anyone already know what it means.
> >> > 
> >> > We've gone well past using the firmware API for firmware though, if
> >> > we use it for 802.11 to replace CRDA for instance its really odd to
> >> > be calling it firmware. But sure... I will rebrand again to firmware...
> >> 
> >> I tend to agree. Although some people even call an OpenWrt image
> >> firmware. Guess it is just in the eye of the beholder.
> >
> > Sure...
> >
> > Come to think of it I'll still go with "sysdata", this is a very minor
> > detail, do let me know if there is anything technical rather than
> > the color of the bikeshed [0] over the patches.
> 
> Well, you don't seem to care but I prefer that the terminology is clear
> and I don't want to waste people's time browsing the source to find out
> what something means.

Its not that I don't care, its this is a super trivial matter, like the
color of a bikeshed, and I'd much prefer to put energy and review on
technical matters.

> Even "driverdata" would be more descriptive for me
> than "sysdata".
> 
> Actually, what does the "sys" refer here, system? And what system is
> that exactly?

Yes system, so as in system data file. "driver_data" is just as good.
Although who knows, others may want to paint the bikeshed a different
color.

The core reason why the name change is to make emphasis of the fact that
we've gone way past the point where the APIs are used for non-firmware
and I expect this use will only grow.

  Luis
