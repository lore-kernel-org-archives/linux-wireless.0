Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12826 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0DTGmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 02:42:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 23:42:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19405.19620.199172.233574@gargle.gargle.HOWL>
Date: Tue, 20 Apr 2010 12:11:40 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k-htc: speedup disconnect handling
In-Reply-To: <y2ud82e647a1004192259nec8aad6dy836b76b2211b6a40@mail.gmail.com>
References: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
	<19405.11838.119234.371361@gargle.gargle.HOWL>
	<y2ud82e647a1004192259nec8aad6dy836b76b2211b6a40@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> If ATH_DBG_RESET is enabled, you will find the debug messages
> below[1] during disconnecting.  From the messages, the short hang should
> be caused by the 'RTC stuck in MAC reset'. Once the patch is applied,
> no such issue will happen.

I take it that you didn't have ATH_DBG_WMI in your debug mask.
A simpler way to fix this issue is to deny all WMI commands once
the target has been unplugged - something like the attached patch.

Can you check if it fixes your issue ?

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index c765ff4..b771e20 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -329,6 +329,7 @@ struct htc_beacon_config {
 #define OP_ASSOCIATED     BIT(8)
 #define OP_ENABLE_BEACON  BIT(9)
 #define OP_LED_DEINIT     BIT(10)
+#define OP_UNPLUGGED      BIT(11)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a861896..701f2ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -744,6 +744,9 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
+	/* The device may have been unplugged earlier. */
+	priv->op_flags &= ~OP_UNPLUGGED;
+
 	ret = ath9k_init_device(priv, devid);
 	if (ret)
 		goto err_init;
@@ -760,6 +763,11 @@ err_free:
 void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 {
 	if (htc_handle->drv_priv) {
+
+		/* Check if the device has been yanked out. */
+		if (hotunplug)
+			htc_handle->drv_priv->op_flags |= OP_UNPLUGGED;
+
 		ath9k_deinit_device(htc_handle->drv_priv);
 		ath9k_deinit_wmi(htc_handle->drv_priv);
 		ieee80211_free_hw(htc_handle->drv_priv->hw);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index dc6c6fc..c688545 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -276,6 +276,9 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	int time_left, ret = 0;
 	unsigned long flags;
 
+	if (wmi->drv_priv->op_flags & OP_UNPLUGGED)
+		return 0;
+
 	if (!wmi)
 		return -EINVAL;
 
