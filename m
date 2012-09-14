Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34103 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2INJsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 05:48:08 -0400
From: Sven Eckelmann <sven@narfation.org>
To: ath9k-devel@lists.ath9k.org
Cc: nbd@openwrt.org, adrian.chadd@gmail.com,
	linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	lindner_marek@yahoo.de, Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC] ath9k: Work around complete stuck of hw
Date: Fri, 14 Sep 2012 11:47:25 +0200
Message-Id: <1347616045-29336-1-git-send-email-sven@narfation.org> (sfid-20120914_114813_664381_BB4B0023)
In-Reply-To: <50521E02.4030809@openwrt.org>
References: <50521E02.4030809@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9330 and most likely other chips like AR9285 seem to get stuck completely
after they worked a long period of time in special environments. It is
currently unknown which parameters causes this problem.

Symptom of these stuck is the exposure of 0xdeadbeef through different hardware
registers. An interface down/up change seems to help the hardware to recover
from the problem.

A workaround is to periodically test register AR_CFG for 0xdeadbeef and force
an reset when 0xdeadbeef would be unexpected.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
This check is currently tested. This takes quite a long time and maybe someone
with more knowledge of atheros devices can check whether this one is completely
and utterly wrong.

The type RESET_TYPE_FATAL_INT was chosen in this test to allow us to see
whether this condition was already true by reading from
/sys/kernel/debug/ieee80211/phy0/ath9k/reset

 drivers/net/wireless/ath/ath9k/link.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7b88b9c..89467e2 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -69,10 +69,20 @@ void ath_hw_check(struct work_struct *work)
 	int busy;
 	u8 is_alive, nbeacon = 1;
 	enum ath_reset_type type;
+	u32 reg;
 
 	ath9k_ps_wakeup(sc);
 	is_alive = ath9k_hw_check_alive(sc->sc_ah);
 
+	/* check for stucked MAC */
+	reg = REG_READ(sc->sc_ah, AR_CFG);
+	if (reg == 0xdeadbeef && sc->sc_ah->power_mode == ATH9K_PM_AWAKE) {
+		ath_dbg(common, RESET,
+			"Hang is detected. Schedule chip reset\n");
+		type = RESET_TYPE_FATAL_INT;
+		goto sched_reset;
+	}
+
 	if (is_alive && !AR_SREV_9300(sc->sc_ah))
 		goto out;
 	else if (!is_alive && AR_SREV_9300(sc->sc_ah)) {
-- 
1.7.10.4

