Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64895 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZERSK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:10:56 -0400
Received: by fxm2 with SMTP id 2so3401797fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 11:10:56 -0700 (PDT)
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"alexander.bartha\@drz-wien.at" <alexander.bartha@drz-wien.at>,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath comes
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
	<43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
	<1242112310.3873.55.camel@johannes.local>
	<43e72e890905120014w13ca9317r8ec8fa270f2bbb1e@mail.gmail.com>
	<2da21fe50905120135h1cb8746foae4b3b4b37b3cb24@mail.gmail.com>
	<1242326667.14069.20.camel@jm-desktop>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 21:10:54 +0300
In-Reply-To: <1242326667.14069.20.camel@jm-desktop> (Jouni Malinen's message of "Thu\, 14 May 2009 21\:44\:27 +0300")
Message-ID: <878wkub7td.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <jouni.malinen@atheros.com> writes:

> On Tue, 2009-05-12 at 01:35 -0700, Davide Pesavento wrote:
>> I've already reported ath9k's issues with PS multiple times [1] [2]
>> [3], but the driver hasn't been fixed yet. You can find a verbose
>> debugging output at [4], I hope that helps in fixing the problem (I
>> can provide even more info if needed and I'm willing to test patches).
>
> I submitted a set of patches to resolve some of the PS issues in ath9k.
> I would expect these to hit wireless-testing.git eventually, but if you
> are willing to test the changes before that, you can find the patches
> from http://w1.fi/p/ps/
>
> One thing to note here is that there are still some issues with the
> timeout=0 case (use of PS-Poll to fetch buffered frames) which is
> enabled with "iwconfig wlan0 power on", so at this point, I would
> recommend running the test either with the default wireless-testing.git
> PS mode setting or by enabling power saving with "iwconfig wlan0 power
> timeout 500ms" which should result in the same configuration.

Most probably that's because mac80211 does not disable power save mode
when sending PS-Poll frames. So stlc45xx does not require disable of PSM
but then again ath9k requires it, we need to solve this somehow.

I have been thinking about separating power save mode and firmware
wakeup/sleep modes from each other in mac80211 API. To me it looks like
ath9k does more like firmware wakeup/sleep when power save mode is
changing. But this is just a wild idea, I have no idea if it's practical
or not.

-- 
Kalle Valo
