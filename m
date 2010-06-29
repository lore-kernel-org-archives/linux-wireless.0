Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36665 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab0F2Qwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 12:52:36 -0400
Message-ID: <4C2A24D2.4070007@openwrt.org>
Date: Tue, 29 Jun 2010 18:52:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>	<4C29284C.5050707@openwrt.org>	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>	<4C2A1776.2080508@openwrt.org> <AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>
In-Reply-To: <AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-29 6:36 PM, Björn Smedman wrote:
> 2010/6/29 Felix Fietkau <nbd@openwrt.org>:
>> One beacon miss should never cause a TSF reset. Only a lot of
>> consecutive beacon misses trigger a hardware reset, which then resets
>> the TSF. Looking at your log, it appears that the beacon miss is a
>> symptom rather than a cause of the TSF jumps.
>> Can you add a debug statement to the hw reset function to see if it's
>> called before the TSF jumps?
> 
> Yup, seems to be a hardware reset. Added an ath_print ("Reset HW!") at
> the beginning of ath9k_hw_reset() and used debug mask 0x101:
> 
> ...
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 3 [tsf 14863367
> tsftu 14515 intval 100] vif (null)
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 2 [tsf 14888967
> tsftu 14540 intval 100] vif (null)
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 1 [tsf 14914568
> tsftu 14565 intval 100] vif (null)
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Reset HW!
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: ah->misc_mode 0xc
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Setting CFG 0x10a
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 0 [tsf 80123
> tsftu 78 intval 100] vif 80945e70
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Reset HW!
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: ah->misc_mode 0xc
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Setting CFG 0x10a
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 0 [tsf 80989
> tsftu 79 intval 100] vif 80945e70
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: resume beacon xmit
> after 1 misses
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 3 [tsf 117792
> tsftu 115 intval 100] vif (null)
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 2 [tsf 143368
> tsftu 140 intval 100] vif (null)
> Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 1 [tsf 168967
> tsftu 165 intval 100] vif (null)
> ...
Please add another print to the end of ath9k_hw_check_alive() before the
'return false'. Make sure it prints the value of the 'reg' variable.
If you see it in the log, then it's probably the baseband getting stuck.

- Felix
