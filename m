Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59957 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1HMVLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 17:11:53 -0400
Received: by fxh19 with SMTP id 19so2928084fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 14:11:52 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: carl9170 does not like all frequencies
Date: Sat, 13 Aug 2011 23:11:46 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <j26l8a$ea9$1@dough.gmane.org> <201108132234.16886.chunkeey@googlemail.com> <4E46E3C5.5060403@fastmail.fm>
In-Reply-To: <4E46E3C5.5060403@fastmail.fm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201108132311.46792.chunkeey@googlemail.com> (sfid-20110813_231202_320707_506A426C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 August 2011 22:51:17 Bernd Schubert wrote:
> On 08/13/2011 10:34 PM, Christian Lamparter wrote:
> > On Saturday 13 August 2011 22:02:18 Bernd Schubert wrote:
> >> I bought a new usb wifi device with 2 antennas to get a better
> >> connection to my router.
> > So, you are saying that there was something wrong with the old
> > stick as well, right!?
> 
> There is nothing wrong with the previous zd1211rw device, its antenna is
> just a bit weak and so I only can use it, when my system is rather close
> to the router...
Then just stick with that :-D.

> >> From point of few of connection strength that worked out very well, from
> >> point of view of connection stability that is total disaster so far.
> > Sure, you are affected by constant "loud" noise on the frequency/band.
> > The hardware is unable to finish the noise floor calibration and therefore
> > gives up.
> > 
> >> With Ubuntus 2.6.38-something it connects and then entirely fails after
> >> sending a few bytes. So I checked git log and noticed carl9170 is being
> >> used in recent kernels and connection issues have been fixed in 3.1-git.
> > what commits are you talking about?
> 
> 
> For example:
> 
> 582965672831180b2e1f5e15ea1f7dc6f5b93018
> "carl9170: set beacon xmit power to the max"
This change is not relevant for station mode. 
 
> >>> [ 1058.936551] cfg80211: Calling CRDA to update world regulatory domain
> >>> [ 1058.945510] cfg80211: World regulatory domain updated:
> >>> [ 1058.945519] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> >>> [ 1058.945529] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>> [ 1058.945538] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> >>> [ 1058.945547] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> >>> [ 1058.945555] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>> [ 1058.945563] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>> [ 1058.945604] cfg80211: Calling CRDA for country: 97
> >>> [ 1061.373997] ieee80211 phy1: channel change: 2417 -> 2422 failed (2).
> >>> [ 1061.682115] ieee80211 phy1: channel change: -1 -> 2422 failed (2).
> >>> [ 1061.682132] usb 10-1.2: restart device (7)
> >>> [ 1062.096523] cfg80211: Calling CRDA to update world regulatory domain
> >>> [ 1062.105469] cfg80211: World regulatory domain updated:
> >>
> >> Any idea what is going on here? Do I need a crda tool? Or is something
> >> else failing?
> > Yes, you need crda, if you haven't installed it already.
> 
> Sorry, I forgot "update" there. So I asked if I would need to update
> crda. I just did that, but I just don't want to disconnect right now to
> see if it connects any faster. Those messages still appear every 16
> seconds and spam my logs :(
Luis, do you know what causes these CRDA spamming?
(Also, the country code should be "DE" in his case, or?)

> >> Update: While writing this up and after I plugged in my zd1211rw device,
> >> eventually also my tp-link carl9170 device connected a few minutes
> >> later. Do I always have to wait for 20 minutes to get a connection now?
> > That's odd. TP-Link does not sell any AR9170 anymore, in fact they dropped it
> > more than a year ago and replaced the line-up with AR7010+AR9287? so where
> > did you get this obsolete device?
> 
> The device is a TL-WN822N available widely here, I think.
Well, there's a WN822N v1 and there's a WN822N v2. You got the
old v1, probably because someone else returned it. AR9170 is long
gone, in fact Qualcomm Atheros has does not even list the product on
their website anymore.

Regards,
	Chr
