Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33761 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbcDYSY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 14:24:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Alan Liu <alanliu@qca.qualcomm.com>
Subject: [PATCH] ath10k: add max_tx_power for QCA6174 WLAN.RM.2.0 firmware
Date: Mon, 25 Apr 2016 21:24:30 +0300
Message-ID: <1461608670-15386-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20160425_202512_641827_88873B68)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Liu <alanliu@qca.qualcomm.com>

QCA6174 WLAN.RM.2.0 firmware uses max_tx_power instead of using max_reg_power
to set transmission power. The tx power was about -50dbm, after applying this
change, it become -32dbm.

Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

v2:

* rename the patch from:

    Add max_tx_power member to set max transmission power for WLAN.RM.2.0 firmware.

  to:

    ath10k: add max_tx_power for QCA6174 WLAN.RM.2.0 firmware

* CC ath10k list

* add an empty line

 drivers/net/wireless/ath/ath10k/wmi.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a1afb2e2b05a..260070db2512 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1633,6 +1633,7 @@ void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 	ch->max_power = arg->max_power;
 	ch->reg_power = arg->max_reg_power;
 	ch->antenna_max = arg->max_antenna_gain;
+	ch->max_tx_power = arg->max_power;
 
 	/* mode & flags share storage */
 	ch->mode = arg->mode;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index db2553522d8b..fe36b2c99018 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1795,6 +1795,7 @@ struct wmi_channel {
 		__le32 reginfo1;
 		struct {
 			u8 antenna_max;
+			u8 max_tx_power;
 		} __packed;
 	} __packed;
 } __packed;
-- 
1.7.9.5

