Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33572 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab0F2Qgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 12:36:32 -0400
Received: by iwn7 with SMTP id 7so1366018iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 09:36:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C2A1776.2080508@openwrt.org>
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
	<4C29284C.5050707@openwrt.org>
	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>
	<4C2A1776.2080508@openwrt.org>
Date: Tue, 29 Jun 2010 18:36:30 +0200
Message-ID: <AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/6/29 Felix Fietkau <nbd@openwrt.org>:
> One beacon miss should never cause a TSF reset. Only a lot of
> consecutive beacon misses trigger a hardware reset, which then resets
> the TSF. Looking at your log, it appears that the beacon miss is a
> symptom rather than a cause of the TSF jumps.
> Can you add a debug statement to the hw reset function to see if it's
> called before the TSF jumps?

Yup, seems to be a hardware reset. Added an ath_print ("Reset HW!") at
the beginning of ath9k_hw_reset() and used debug mask 0x101:

...
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 3 [tsf 14863367
tsftu 14515 intval 100] vif (null)
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 2 [tsf 14888967
tsftu 14540 intval 100] vif (null)
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 1 [tsf 14914568
tsftu 14565 intval 100] vif (null)
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Reset HW!
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: ah->misc_mode 0xc
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Setting CFG 0x10a
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 0 [tsf 80123
tsftu 78 intval 100] vif 80945e70
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Reset HW!
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: ah->misc_mode 0xc
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: Setting CFG 0x10a
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 0 [tsf 80989
tsftu 79 intval 100] vif 80945e70
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: resume beacon xmit
after 1 misses
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 3 [tsf 117792
tsftu 115 intval 100] vif (null)
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 2 [tsf 143368
tsftu 140 intval 100] vif (null)
Jan  1 00:01:59 OpenWrt user.debug kernel: ath: slot 1 [tsf 168967
tsftu 165 intval 100] vif (null)
...

> - Felix
>

/Björn
