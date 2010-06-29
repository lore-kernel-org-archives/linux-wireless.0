Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36936 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0F2Pzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 11:55:39 -0400
Message-ID: <4C2A1776.2080508@openwrt.org>
Date: Tue, 29 Jun 2010 17:55:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>	<4C29284C.5050707@openwrt.org> <AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>
In-Reply-To: <AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-29 5:20 PM, Björn Smedman wrote:
> 2010/6/29 Felix Fietkau <nbd@openwrt.org>:
>> IMHO the most likely problem source is stuck beacons. Please compile the
>> driver with the debug option enabled and load it with
>> insmod ath9k debug=0x00000100
> 
> It looks like it could be:
> 
> ...
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 2 [tsf 1986567
> tsftu 1940 intval 100] vif (null)
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 1 [tsf 2012168
> tsftu 1965 intval 100] vif (null)
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 0 [tsf 2037767
> tsftu 1990 intval 100] vif 80945e70
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 0 [tsf 79033
> tsftu 77 intval 100] vif 80945e70
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: resume beacon xmit
> after 1 misses
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 3 [tsf 117790
> tsftu 115 intval 100] vif (null)
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 2 [tsf 143368
> tsftu 140 intval 100] vif (null)
> Jan  1 00:06:21 OpenWrt user.debug kernel: ath: slot 1 [tsf 168967
> tsftu 165 intval 100] vif (null)
> ...
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 1 [tsf 14197768
> tsftu 13865 intval 100] vif (null)
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 0 [tsf 14223368
> tsftu 13890 intval 100] vif 80945e70
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 3 [tsf 14248967
> tsftu 13915 intval 100] vif (null)
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 0 [tsf 79180
> tsftu 77 intval 100] vif 80945e70
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: resume beacon xmit
> after 1 misses
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 3 [tsf 117791
> tsftu 115 intval 100] vif (null)
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 2 [tsf 143366
> tsftu 140 intval 100] vif (null)
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 1 [tsf 168967
> tsftu 165 intval 100] vif (null)
> Jan  1 00:09:08 OpenWrt user.debug kernel: ath: slot 0 [tsf 194567
> tsftu 190 intval 100] vif 80945e70
> ...
> 
> What can cause a missed beacon? Are they just a "fact of life"?
> 
> In any case I can't find any code that resets the tsf in this (single
> missed beacon) case. Will the hardware reset the tsf automatically
> whenever a single beacon is missed? Isn't that a bit overkill? Will it
> not cause problems for clients?
One beacon miss should never cause a TSF reset. Only a lot of
consecutive beacon misses trigger a hardware reset, which then resets
the TSF. Looking at your log, it appears that the beacon miss is a
symptom rather than a cause of the TSF jumps.
Can you add a debug statement to the hw reset function to see if it's
called before the TSF jumps?

- Felix
