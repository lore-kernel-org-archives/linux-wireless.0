Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IVJpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 05:45:02 -0400
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Brett Rudley <brudley@broadcom.com>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110922003523.0bf6a460@milhouse> (sfid-20110922_003558_097592_9972A2E0)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
	 <20110920140020.GA11386@kroah.com>
	 <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
	 <20110922003523.0bf6a460@milhouse> (sfid-20110922_003558_097592_9972A2E0)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 11:44:35 +0200
Message-ID: <1316684675.3899.25.camel@jlt3.sipsolutions.net> (sfid-20110922_114513_084125_EC710A3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 00:35 +0200, Michael Büsch wrote:

> And for that single reason I do not see either b43 or brcmsmac being dropped
> in favor of the other one any time soon.
> 
> You guys obviously don't want to support legacy hardware. So there is absolutely
> no way to drop b43 in favor of brcmsmac. That is _impossible_.
> And I do agree that it would be completely insane for you guys to support the legacy
> b43 802.11g code.
> 
> The other way around, dropping brcmsmac in favor of b43 would be insanely stupid, too.
> It would basically be dropping broadcom-linux-wlan support. Nobody wants that.

All good points. The most rational I've seen in all of this discussion
really.

> I do, however, think that a separate broadcom-supported PHY module should be created,
> that is used by both brcmsmac and b43.

I agree that would be nice. However, I don't think that it should be
required for brcmsmac to get into mainline, nor do I think that there
should be a big rearchitecture for this. In fact, brcmsmac has a PHY
abstraction layer that looks perfectly usable to me. b43 has one too,
but it's nowhere near as fleshed out for all corner cases afaict.

Really the more important issue is support though. Rafal by himself
cannot possibly provide the level of support we're hoping to see from
Broadcom who I expect will eventually ship this driver to their
customers and support it, just like they do now with the driver it is
derived from.

Overall, the way I see it this really is a no-brainer. I really don't
see why we're even discussing this so much.
brcmsmac should be accepted into mainline as soon as possible (and I
think all the recent patchsets go a long way). After that, the Broadcom
team can easily port it to bcma, I expect that would happen within a few
weeks. Adding features to it should be fairly simple too, and go much
faster than adding any features to b43. (*)


b43 is really my child too. I spent a very long time on the reverse
engineering. But let's let it "die" peacefully. It has no reason to be
competing with a Broadcom-supported driver that supports the same chips.

johannes


(*) Rafal: Also, get a grip. Your much touted "monitor mode" is probably
a 50-100 line patch to brcmsmac. You're making yourself look extremely
childish by talking about it all the time as if it was the best thing
since sliced bread.


