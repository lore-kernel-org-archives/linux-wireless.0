Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54748 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab2FFKHq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:46 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 19/29] NFC: Configure pn533 RF timings
Date: Wed,  6 Jun 2012 12:16:36 +0200
Message-Id: <1338977806-30279-20-git-send-email-sameo@linux.intel.com> (sfid-20120606_120749_487556_C2B9832D)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those define the ATR_RES response timeout after which the pn533 considers the
target to be mute.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 2a7e4e8..d976344 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -104,8 +104,14 @@ struct pn533_fw_version {
 };
 
 /* PN533_CMD_RF_CONFIGURATION */
+#define PN533_CFGITEM_TIMING 0x02
 #define PN533_CFGITEM_MAX_RETRIES 0x05
 
+#define PN533_CONFIG_TIMING_102 0xb
+#define PN533_CONFIG_TIMING_204 0xc
+#define PN533_CONFIG_TIMING_409 0xd
+#define PN533_CONFIG_TIMING_819 0xe
+
 #define PN533_CONFIG_MAX_RETRIES_NO_RETRY 0x00
 #define PN533_CONFIG_MAX_RETRIES_ENDLESS 0xFF
 
@@ -115,6 +121,12 @@ struct pn533_config_max_retries {
 	u8 mx_rty_passive_act;
 } __packed;
 
+struct pn533_config_timing {
+	u8 rfu;
+	u8 atr_res_timeout;
+	u8 dep_timeout;
+} __packed;
+
 /* PN533_CMD_IN_LIST_PASSIVE_TARGET */
 
 /* felica commands opcode */
@@ -2004,6 +2016,7 @@ static int pn533_probe(struct usb_interface *interface,
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
 	struct pn533_config_max_retries max_retries;
+	struct pn533_config_timing timing;
 	int in_endpoint = 0;
 	int out_endpoint = 0;
 	int rc = -ENOMEM;
@@ -2115,6 +2128,18 @@ static int pn533_probe(struct usb_interface *interface,
 		goto unregister_nfc_dev;
 	}
 
+	timing.rfu = PN533_CONFIG_TIMING_102;
+	timing.atr_res_timeout = PN533_CONFIG_TIMING_204;
+	timing.dep_timeout = PN533_CONFIG_TIMING_409;
+
+	rc = pn533_set_configuration(dev, PN533_CFGITEM_TIMING,
+				(u8 *) &timing, sizeof(timing));
+	if (rc) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error on setting RF timings");
+		goto unregister_nfc_dev;
+	}
+
 	return 0;
 
 unregister_nfc_dev:
-- 
1.7.9.1

