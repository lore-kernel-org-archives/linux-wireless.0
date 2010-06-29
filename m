Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54833 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab0F2RcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 13:32:14 -0400
Received: by iwn7 with SMTP id 7so1410159iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 10:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C2A24D2.4070007@openwrt.org>
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
	<4C29284C.5050707@openwrt.org>
	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>
	<4C2A1776.2080508@openwrt.org>
	<AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>
	<4C2A24D2.4070007@openwrt.org>
Date: Tue, 29 Jun 2010 19:32:12 +0200
Message-ID: <AANLkTikw3l6FIxLtIwxofGaqGQD_b7LO25uu-JV45UL6@mail.gmail.com>
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/6/29 Felix Fietkau <nbd@openwrt.org>:
> Please add another print to the end of ath9k_hw_check_alive() before the
> 'return false'. Make sure it prints the value of the 'reg' variable.
> If you see it in the log, then it's probably the baseband getting stuck.

Yes, hw reset is due to reg = 0x01702400 every 4 - 40 seconds or so:
...
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 0 [tsf 4495367
tsftu 4390 intval 100] vif 80944e70
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 3 [tsf 4520967
tsftu 4415 intval 100] vif (null)
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 2 [tsf 4546567
tsftu 4440 intval 100] vif (null)
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: ath9k_hw_check_alive:
reg = 0x01702400
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: Reset due to hw dead
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: Reset HW!
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: ah->misc_mode 0xc
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: Setting CFG 0x10a
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 0 [tsf 79211
tsftu 77 intval 100] vif 80944e70
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: missed 1 consecutive beacons
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: resume beacon xmit
after 1 misses
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 3 [tsf 117796
tsftu 115 intval 100] vif (null)
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 2 [tsf 143366
tsftu 140 intval 100] vif (null)
Jan  1 00:03:21 OpenWrt user.debug kernel: ath: slot 1 [tsf 168967
tsftu 165 intval 100] vif (null)
...

> - Felix

/Björn
