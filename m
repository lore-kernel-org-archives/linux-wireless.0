Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 032/113] rtl8xxxu: Do BT_WLAN_CALIBRATION before doing IQK calibration
Date: Mon, 29 Feb 2016 17:04:30 -0500
Message-Id: <1456783551-28315-33-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231040_710845_13533D4E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer generation chips require the firmware be notified before we
start the IQK calibration.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 20 +++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  4 ++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3139890..3829687 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1497,7 +1497,7 @@ static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv,
 	} while (retry--);
 
 	if (!retry) {
-		dev_dbg(dev, "%s: Mailbox busy\n", __func__);
+		dev_info(dev, "%s: Mailbox busy\n", __func__);
 		retval = -EBUSY;
 		goto error;
 	}
@@ -3877,6 +3877,20 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	}
 }
 
+static void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
+{
+	struct h2c_cmd h2c;
+
+	if (priv->fops->mbox_ext_width < 4)
+		return;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.bt_wlan_calibration.cmd = H2C_8723B_BT_WLAN_CALIBRATION;
+	h2c.bt_wlan_calibration.data = start;
+
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
+}
+
 static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
@@ -3888,6 +3902,8 @@ static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 	s32 reg_tmp = 0;
 	bool simu;
 
+	rtl8xxxu_prepare_calibrate(priv, 1);
+
 	memset(result, 0, sizeof(result));
 	candidate = -1;
 
@@ -3975,6 +3991,8 @@ static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 
 	rtl8xxxu_save_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
 			   priv->bb_recovery_backup, RTL8XXXU_BB_REGS);
+
+	rtl8xxxu_prepare_calibrate(priv, 0);
 }
 
 static void rtl8723a_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 47898ff..07533ac 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -727,6 +727,10 @@ struct h2c_cmd {
 			u8 arg;
 			__le16 mask_lo;
 		} __packed ramask;
+		struct {
+			u8 cmd;
+			u8 data;
+		} __packed bt_wlan_calibration;
 	};
 };
 
-- 
2.5.0

