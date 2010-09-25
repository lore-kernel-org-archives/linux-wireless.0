Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0IYW5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 18:57:46 -0400
Received: by fxm3 with SMTP id 3so1275527fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Sep 2010 15:57:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dale Turner <rx_guy@hotmail.com>
Subject: Re: carl9170 problem
Date: Sun, 26 Sep 2010 00:57:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <SNT113-W182B461295E717BB27130BF1630@phx.gbl>
In-Reply-To: <SNT113-W182B461295E717BB27130BF1630@phx.gbl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009260057.38286.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 September 2010 02:34:26 Dale Turner wrote:
> 
> Hello everyone.
> 
> Thanks for releasing the carl9170 driver in the 
> compat-wireless package.
I recommend using wireless-testing.git over
compat-wireless + old kernel.

> I have been able to compile the driver, so that is great.
> The connection seems to be a bit inconsistent.
> I get the following quite often in /var/log/messages :

> kernel: ieee80211 phy9: channel change: 2472 -> 2462 failed (2)
That's a noise floor calibration error. Check if your compat-wireless
source  includes "carl9170: reinit phy after HT settings have changed".
Also check if there is another device active on the same (primary/
secondary) channel like a microwave oven, DECT phone or another wifi
network, or wifi network peer. 

> kernel: ieee80211 phy9: invalid plcp cck rate (0)
This is a known bug, the driver received a invalid stream frame
from the hardware. This only happens a lot when the AP ignores
the device's ampdu spacing.
(Do you have an older draft-n AP, if so what chip?)

> kernel: ieee80211 phy9: FW: MAC RESET
The device failed to send pending data for more than 150ms(HT40) - 300ms,
either because the medium was busy, or the AP failed to response at all
mostly because it has crashed first.
(check if your AP's TSF is no where near your AP's uptime)

> When
>  that happens (which can be as often as every few minutes) my reported 
> connection speed in network manager drops to 6 or 1 Mb/s. The network 
> speed is noticeably reduced (for instance download speeds drastically 
> reduce, online videos stutter, or music streaming from a different 
> computer pauses, etc).
Network manager has a feature called "background scanning".
The advantage is that you'll always have a up-to-date site survey.
The disadvantage is that it needs to perform a periodically scan
(as in every few minutes) which on some occasions result in a
channel change failed hiccup.

> 
> My previous adapter TP-Link TL-WN721N (ath9k_htc driver) did not behave like this.
Why did you go back to the previous generation? 
ath9k_htc (for AR9271) is in fact the replacement for AR9170.

Regards,
	Chr
