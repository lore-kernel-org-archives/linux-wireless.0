Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9502 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2FMP6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 11:58:18 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 3.0+] ath9k: Fix softlockup in AR9485(backported)
Date: Wed, 13 Jun 2012 21:28:09 +0530
Message-ID: <1339603089-16090-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120613_175822_409145_CB99D380)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Please note this is the backported version for the linux
stable tree, while the patch for wireless-testing tree
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/92608

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

ensure that the PLL-WAR for AR9485/AR9340 is executed only if the STA is
associated (or) IBSS/AP mode had started beaconing. Ideally this WAR
is needed to recover from some rare beacon stuck during stress testing.
Before the STA is associated/IBSS had started beaconing, PLL4(0x1618c)
always seem to have zero even though we had configured PLL3(0x16188) to
query about PLL's locking status. When we keep on polling infinitely PLL4's
8th bit(ie check for PLL locking measurements is done), machine hangs
due to softlockup.

fixes https://bugzilla.redhat.com/show_bug.cgi?id=811142

Reported-by: Rolf Offermanns <rolf.offermanns@gmx.net>
Cc: stable@vger.kernel.org [3.0+]
Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4de4473..41096f6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -971,6 +971,15 @@ void ath_hw_pll_work(struct work_struct *work)
 					    hw_pll_work.work);
 	u32 pll_sqsum;
 
+	/*
+	 * ensure that the PLL WAR is executed only
+	 * after the STA is associated (or) if the
+	 * beaconing had started in interfaces that
+	 * uses beacons.
+	 */
+	if (!(sc->sc_flags & SC_OP_BEACONS))
+		return;
+
 	if (AR_SREV_9485(sc->sc_ah)) {
 
 		ath9k_ps_wakeup(sc);
-- 
1.7.4.1

