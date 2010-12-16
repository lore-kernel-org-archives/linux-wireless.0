Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30983 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab0LPDYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 22:24:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 19:24:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] cfg80211: fix null pointer dereference with a custom regulatory request
Date: Wed, 15 Dec 2010 19:24:11 -0800
Message-ID: <1292469852-2987-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292469852-2987-1-git-send-email-lrodriguez@atheros.com>
References: <1292469852-2987-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once we moved the core regulatory request to the queue and let
the scheduler process it last_request will have been left NULL
until the schedular decides to process the first request. When
this happens and we are loading a driver with a custom regulatory
request like all Atheros drivers we end up with a NULL pointer
dereference. We fix this by checking if the request was a
custom one.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffffa016de87>] freq_reg_info_regd.clone.2+0x27/0x130 [cfg80211]
PGD 71f91067 PUD 712b2067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/firmware/2-1/loading
CPU 0
Modules linked in: ath9k_htc(+) ath9k_common ath9k_hw ath <etc>
Pid: 3094, comm: insmod Tainted: G        W   2.6.37-rc5-wl #16 INVALID/28427ZQ
RIP: 0010:[<ffffffffa016de87>]  [<ffffffffa016de87>] freq_reg_info_regd.clone.2+0x27/0x130 [cfg80211]
RSP: 0018:ffff88007045db78  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffffa047d9a0 RCX: ffff88007045dbd0
RDX: 0000000000004e20 RSI: 000000000024cde0 RDI: ffff8800700483e0
RBP: ffff88007045db98 R08: ffffffffa02f5b40 R09: 0000000000000001
R10: 000000000000000e R11: 0000000000000001 R12: 0000000000000000
R13: ffff88007004e3b0 R14: 0000000000000000 R15: ffff880070048340
FS:  00007f635a707700(0000) GS:ffff880077400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 00000000708a9000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 3094, threadinfo ffff88007045c000, task ffff8800713e3ec0)
Stack:
 ffffffffa047d9a0 0000000000000000 ffff88007004e3b0 0000000000000000
 ffff88007045dc08 ffffffffa016e147 000000007045dc08 0000000000000002
 ffff8800700483e0 ffffffffa02f5b40 ffff88007045dbd8 0000000000000000
Call Trace:
 [<ffffffffa016e147>] wiphy_apply_custom_regulatory+0x137/0x1d0 [cfg80211]
 [<ffffffffa047a690>] ? ath9k_reg_notifier+0x0/0x50 [ath9k_htc]
 [<ffffffffa02f47f7>] ath_regd_init+0x347/0x430 [ath]
 [<ffffffffa047b1f5>] ath9k_htc_probe_device+0x6c5/0x960 [ath9k_htc]
 [<ffffffffa0472a2c>] ath9k_htc_hw_init+0xc/0x30 [ath9k_htc]
 [<ffffffffa04747e6>] ath9k_hif_usb_probe+0x216/0x3b0 [ath9k_htc]
 [<ffffffffa03bb6bc>] usb_probe_interface+0x10c/0x210 [usbcore]
 [<ffffffff812aec26>] driver_probe_device+0x96/0x1c0
 [<ffffffff812aedf3>] __driver_attach+0xa3/0xb0
 [<ffffffff812aed50>] ? __driver_attach+0x0/0xb0
 [<ffffffff812adaae>] bus_for_each_dev+0x5e/0x90
 [<ffffffff812ae8c9>] driver_attach+0x19/0x20
 [<ffffffff812ae438>] bus_add_driver+0x168/0x320
 [<ffffffff812af071>] driver_register+0x71/0x140
 [<ffffffff811fc4a8>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffffa03ba39c>] usb_register_driver+0xdc/0x190 [usbcore]
 [<ffffffffa03a2000>] ? ath9k_htc_init+0x0/0x4f [ath9k_htc]
 [<ffffffffa047499e>] ath9k_hif_usb_init+0x1e/0x20 [ath9k_htc]
 [<ffffffffa03a202b>] ath9k_htc_init+0x2b/0x4f [ath9k_htc]
 [<ffffffff8100212f>] do_one_initcall+0x3f/0x180
 [<ffffffff8109ef5b>] sys_init_module+0xbb/0x200
 [<ffffffff8100bf52>] system_call_fastpath+0x16/0x1b
Code: <etc, who cares>
RIP  [<ffffffffa016de87>] freq_reg_info_regd.clone.2+0x27/0x130 [cfg80211]
 RSP <ffff88007045db78>
CR2: 0000000000000004
---[ end trace 79e4193601c8b713 ]---

Reported-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |    4 +++-
 net/wireless/reg.c     |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 22be7c6..ef82664 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1419,7 +1419,9 @@ struct ieee80211_txrx_stypes {
 
 /**
  * struct wiphy - wireless hardware description
- * @reg_notifier: the driver's regulatory notification callback
+ * @reg_notifier: the driver's regulatory notification callback,
+ *	note that if your driver uses wiphy_apply_custom_regulatory()
+ *	the reg_notifier's request can be passed as NULL
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
  *	on the reg_notifier() if it chooses to ignore future
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5ed615f..99d4183 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -661,7 +661,8 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	 * Follow the driver's regulatory domain, if present, unless a country
 	 * IE has been processed or a user wants to help complaince further
 	 */
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	if (!custom_regd &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
 	    wiphy->regd)
 		regd = wiphy->regd;
-- 
1.7.3.2.90.gd4c43

