Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:52435 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYLPDbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 22:31:47 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2798398rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 19:31:46 -0800 (PST)
From: Colin McCabe <colin@cozybit.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
Subject: [PATCH 2/3] libertas: Update libertas core with GSPI constants
Date: Mon, 15 Dec 2008 19:27:31 -0800
Message-Id: <1229398052-27465-3-git-send-email-colin@cozybit.com> (sfid-20081216_043155_395415_2116E00D)
In-Reply-To: <1229398052-27465-2-git-send-email-colin@cozybit.com>
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
 <1229398052-27465-2-git-send-email-colin@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add GSPI constants to libertas core.

Fix misleading comment in lbs_setup_firmware.

Signed-off-by: Colin McCabe <colin@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/host.h    |    1 +
 drivers/net/wireless/libertas/hostcmd.h |    8 ++++++++
 drivers/net/wireless/libertas/main.c    |    5 ++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index a17b778..b2b617f 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -66,6 +66,7 @@
 #define CMD_802_11_LED_GPIO_CTRL		0x004e
 #define CMD_802_11_EEPROM_ACCESS		0x0059
 #define CMD_802_11_BAND_CONFIG			0x0058
+#define CMD_GSPI_BUS_CONFIG			0x005a
 #define CMD_802_11D_DOMAIN_INFO			0x005b
 #define CMD_802_11_KEY_MATERIAL			0x005e
 #define CMD_802_11_SLEEP_PARAMS			0x0066
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index c6d5771..3c15611 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -221,6 +221,14 @@ struct cmd_ds_mac_multicast_adr {
 	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
 } __attribute__ ((packed));
 
+struct cmd_ds_gspi_bus_config {
+	struct cmd_header hdr;
+	__le16 action;
+	__le16 bus_delay_mode;
+	__le16 host_time_delay_to_read_port;
+	__le16 host_time_delay_to_read_register;
+} __attribute__ ((packed));
+
 struct cmd_ds_802_11_authenticate {
 	u8 macaddr[ETH_ALEN];
 	u8 authtype;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index a00d232..cc36a54 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -951,9 +951,8 @@ void lbs_resume(struct lbs_private *priv)
 EXPORT_SYMBOL_GPL(lbs_resume);
 
 /**
- *  @brief This function downloads firmware image, gets
- *  HW spec from firmware and set basic parameters to
- *  firmware.
+ * @brief This function gets the HW spec from the firmware and sets
+ *        some basic parameters.
  *
  *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   0 or -1
-- 
1.5.6.3

