Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38347
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935AbXC1Kmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:42:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG in bcm43xx/mac80211
Date: Wed, 28 Mar 2007 12:42:20 +0200
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1175009618.5710.10.camel@johannes.berg>
In-Reply-To: <1175009618.5710.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703281242.20906.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 March 2007 17:33, Johannes Berg wrote:
> I just rmmod'ed bcm43xx-mac80211, rc80211_simple and mac80211 all at
> once while wpa supplicant was running...
> 
> [17285.438218] BUG: sleeping function called from invalid context at kernel/mutex.c:86
> [17285.438226] in_atomic():1, irqs_disabled():0
> [17285.438231] Call Trace:
> [17285.438236] [EF7DDC70] [C0008D6C] show_stack+0x3c/0x194 (unreliable)
> [17285.438256] [EF7DDCA0] [C0025C00] __might_sleep+0xd4/0xe8
> [17285.438273] [EF7DDCB0] [C02CF1C8] mutex_lock+0x24/0x3c
> [17285.438289] [EF7DDCD0] [F2750960] bcm43xx_dev_set_key+0xe8/0x3e8 [bcm43xx_mac80211]
> [17285.438331] [EF7DDD10] [F2722004] sta_info_free+0xe4/0x1a4 [mac80211]
> [17285.438385] [EF7DDD50] [F2722140] sta_info_flush+0x7c/0xb4 [mac80211]

Is probably the mac80211 sta lock.

> [17285.438407] [EF7DDD70] [F272B538] ieee80211_if_reinit+0x130/0x2dc [mac80211]
> [17285.438432] [EF7DDDA0] [C02366E0] unregister_netdevice+0x120/0x268
> [17285.438446] [EF7DDDC0] [F272AE2C] __ieee80211_if_del+0x30/0x44 [mac80211]
> [17285.438469] [EF7DDDE0] [F2719F1C] ieee80211_unregister_hw+0x78/0x264 [mac80211]
> [17285.438491] [EF7DDE10] [F274FF44] bcm43xx_remove+0xa4/0xb0 [bcm43xx_mac80211]
> [17285.438510] [EF7DDE30] [F222B6A4] ssb_device_remove+0x38/0x58 [ssb]
> [17285.438548] [EF7DDE40] [C01D53A8] __device_release_driver+0x88/0xc8
> [17285.438561] [EF7DDE50] [C01D5B68] driver_detach+0x110/0x140
> [17285.438570] [EF7DDE70] [C01D4E3C] bus_remove_driver+0x8c/0xc8
> [17285.438580] [EF7DDE90] [C01D5BF0] driver_unregister+0x18/0x34
> [17285.438589] [EF7DDEB0] [F222B0F8] ssb_driver_unregister+0x14/0x24 [ssb]
> [17285.438604] [EF7DDEC0] [F2766530] bcm43xx_exit+0x18/0x3678 [bcm43xx_mac80211]
> [17285.438623] [EF7DDED0] [C004CAC0] sys_delete_module+0x1ac/0x210
> [17285.438633] [EF7DDF40] [C0010BD8] ret_from_syscall+0x0/0x38
> [17285.438646] --- Exception: c01 at 0xff6afd8
> [17285.438661]     LR = 0x10001214
> 
> 

-- 
Greetings Michael.
