Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39668 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab1CJWiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 17:38:08 -0500
Received: by fxm17 with SMTP id 17so470642fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 14:38:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D794D17.4080809@openwrt.org>
References: <1299764499-76251-1-git-send-email-nbd@openwrt.org>
	<1299764499-76251-2-git-send-email-nbd@openwrt.org>
	<1299764499-76251-3-git-send-email-nbd@openwrt.org>
	<1299764499-76251-4-git-send-email-nbd@openwrt.org>
	<AANLkTik8CVL-XQvLxORWBcwyW8ZwT6Kk78HoyMAfpgmi@mail.gmail.com>
	<4D794D17.4080809@openwrt.org>
Date: Thu, 10 Mar 2011 17:36:37 -0500
Message-ID: <AANLkTinCO+se00U_7Za6muCUGyO=BwWonovU2+LMPxHf@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ath9k: improve reliability of beacon transmission
 and stuck beacon handling
From: Mark Mentovai <mark@moxienet.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, vasanth@atheros.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> On 2011-03-10 10:55 PM, Mark Mentovai wrote:
>> Based on the message you sent with patch 2/4, “I can no longer trigger
>> these messages on AR9380, and on AR9280 they become much more rare,”
>> and the fact that you left the message intact in that patch’s
>> ath_drain_all_txq, I wonder it’s appropriate to remove the message
>> from this function.
> Anything beacon related will report stuck beacons if frames stay in the
> queue until the next interval, so there is some degree of reporting
> there already.

OK, that makes sense. The stuck-beacon logging is ath_dbg, but that’s
probably enough given what ath_beacon_tasklet tries to do to recover
from a stuck beacon. I think I just get antsy when I see that
ath_reset might be called quietly, because it’s a big hammer.

No Big Deal.
