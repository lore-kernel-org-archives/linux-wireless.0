Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2E3QKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:10:31 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: [RFC] ath9k: Fix softlockup in AR9485
Date: Wed, 30 May 2012 21:40:22 +0530
Message-ID: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120530_181036_428681_2E86F6AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

steps to recreate:
load latest ath9k driver with AR9485
stop the network-manager and wpa_supplicant
bring the interface up

	Call Trace:
	[<ffffffffa0517490>] ? ath_hw_check+0xe0/0xe0 [ath9k]
	[<ffffffff812cd1e8>] __const_udelay+0x28/0x30
	[<ffffffffa03bae7a>] ar9003_get_pll_sqsum_dvc+0x4a/0x80 [ath9k_hw]
	[<ffffffffa05174eb>] ath_hw_pll_work+0x5b/0xe0 [ath9k]
	[<ffffffff810744fe>] process_one_work+0x11e/0x470
	[<ffffffff8107530f>] worker_thread+0x15f/0x360
	[<ffffffff810751b0>] ? manage_workers+0x230/0x230
	[<ffffffff81079af3>] kthread+0x93/0xa0
	[<ffffffff815fd3a4>] kernel_thread_helper+0x4/0x10
	[<ffffffff81079a60>] ? kthread_freezable_should_stop+0x70/0x70
	[<ffffffff815fd3a0>] ? gs_change+0x13/0x13

before the STA is associated PLL4(0x1618c) always seem to dump
zero, which causes a softlockup as we keep on polling infinitely
PLL4's 8th bit. Once PLL4'S 8th bit is set indicates we can take
PLL3(0x16188) readings which tells us whether PLL is locked or not.
if the PLL is not locked we have a rx hang.
It does not looks safe to poll PLL4 before the STA is associated.
so it is safe to check this  rx hang after association, where we might
have a possibility of rx hang under stress testing. digging into the
PLL stuff did not yield anything much better.

previously the register dumped 0xdeadbeef and the hw_pll_work
itself is cancelled by ath_radio_disable(obselete)

fixes https://bugzilla.redhat.com/show_bug.cgi?id=811142

Reported-by: Rolf Offermanns <rolf.offermanns@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dfa78e8..a03ad3e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -970,6 +970,9 @@ void ath_hw_pll_work(struct work_struct *work)
 					    hw_pll_work.work);
 	u32 pll_sqsum;
 
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF))
+		return;
+
 	if (AR_SREV_9485(sc->sc_ah)) {
 
 		ath9k_ps_wakeup(sc);
-- 
1.7.0.4

