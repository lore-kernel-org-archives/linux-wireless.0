Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9398C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7127F2177B
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392056AbfAKPNA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:13:00 -0500
Received: from smtp3.goneo.de ([85.220.129.37]:49330 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388326AbfAKPM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 10:12:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 3A79E24002C;
        Fri, 11 Jan 2019 16:12:56 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wyqHAU6GjzwM; Fri, 11 Jan 2019 16:12:54 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 8351823FB7C;
        Fri, 11 Jan 2019 16:12:54 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v5 6/7] nfc: pn533: Add autopoll capability
Date:   Fri, 11 Jan 2019 17:18:09 +0100
Message-Id: <20190111161812.26325-6-poeschel@lemonage.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190111161812.26325-1-poeschel@lemonage.de>
References: <20190111161812.26325-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

pn532 devices support an autopoll command, that lets the chip
automatically poll for selected nfc technologies instead of manually
looping through every single nfc technology the user is interested in.
This is faster and less cpu and bus intensive than manually polling.
This adds this autopoll capability to the pn533 driver.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/pn533.c | 193 +++++++++++++++++++++++++++++++++++++-
 drivers/nfc/pn533/pn533.h |  10 +-
 2 files changed, 197 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 3689f0502f6a..a8e127487ada 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -197,6 +197,32 @@ struct pn533_cmd_jump_dep_response {
 	u8 gt[];
 } __packed;
 
+struct pn532_autopoll_resp {
+	u8 type;
+	u8 ln;
+	u8 tg;
+	u8 tgdata[];
+} __packed;
+
+/* PN532_CMD_IN_AUTOPOLL */
+#define PN532_AUTOPOLL_POLLNR_INFINITE	0xff
+#define PN532_AUTOPOLL_PERIOD		0x03 /* in units of 150 ms */
+
+#define PN532_AUTOPOLL_TYPE_GENERIC_106		0x00
+#define PN532_AUTOPOLL_TYPE_GENERIC_212		0x01
+#define PN532_AUTOPOLL_TYPE_GENERIC_424		0x02
+#define PN532_AUTOPOLL_TYPE_JEWEL		0x04
+#define PN532_AUTOPOLL_TYPE_MIFARE		0x10
+#define PN532_AUTOPOLL_TYPE_FELICA212		0x11
+#define PN532_AUTOPOLL_TYPE_FELICA424		0x12
+#define PN532_AUTOPOLL_TYPE_ISOA		0x20
+#define PN532_AUTOPOLL_TYPE_ISOB		0x23
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106	0x40
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212	0x41
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424	0x42
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106	0x80
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_212	0x81
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_424	0x82
 
 /* PN533_TG_INIT_AS_TARGET */
 #define PN533_INIT_TARGET_PASSIVE 0x1
@@ -1401,6 +1427,101 @@ static int pn533_poll_dep(struct nfc_dev *nfc_dev)
 	return rc;
 }
 
+static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
+			       struct sk_buff *resp)
+{
+	u8 nbtg;
+	int rc;
+	struct pn532_autopoll_resp *apr;
+	struct nfc_target nfc_tgt;
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+
+		nfc_err(dev->dev, "%s  autopoll complete error %d\n",
+			__func__, rc);
+
+		if (rc == -ENOENT) {
+			if (dev->poll_mod_count != 0)
+				return rc;
+			goto stop_poll;
+		} else if (rc < 0) {
+			nfc_err(dev->dev,
+				"Error %d when running autopoll\n", rc);
+			goto stop_poll;
+		}
+	}
+
+	nbtg = resp->data[0];
+	if ((nbtg > 2) || (nbtg <= 0))
+		return -EAGAIN;
+
+	apr = (struct pn532_autopoll_resp *)&resp->data[1];
+	while (nbtg--) {
+		memset(&nfc_tgt, 0, sizeof(struct nfc_target));
+		switch (apr->type) {
+		case PN532_AUTOPOLL_TYPE_ISOA:
+			dev_dbg(dev->dev, "ISOA");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_FELICA212:
+		case PN532_AUTOPOLL_TYPE_FELICA424:
+			dev_dbg(dev->dev, "FELICA");
+			rc = pn533_target_found_felica(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_JEWEL:
+			dev_dbg(dev->dev, "JEWEL");
+			rc = pn533_target_found_jewel(&nfc_tgt, apr->tgdata,
+						      apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_ISOB:
+			dev_dbg(dev->dev, "ISOB");
+			rc = pn533_target_found_type_b(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_MIFARE:
+			dev_dbg(dev->dev, "Mifare");
+			rc = pn533_target_found_type_a(&nfc_tgt, apr->tgdata,
+						       apr->ln - 1);
+			break;
+		default:
+			nfc_err(dev->dev,
+				    "Unknown current poll modulation");
+			rc = -EPROTO;
+		}
+
+		if (rc)
+			goto done;
+
+		if (!(nfc_tgt.supported_protocols & dev->poll_protocols)) {
+			nfc_err(dev->dev,
+				    "The Tg found doesn't have the desired protocol");
+			rc = -EAGAIN;
+			goto done;
+		}
+
+		dev->tgt_available_prots = nfc_tgt.supported_protocols;
+		apr = (struct pn532_autopoll_resp *)
+			(apr->tgdata + (apr->ln - 1));
+	}
+
+	pn533_poll_reset_mod_list(dev);
+	nfc_targets_found(dev->nfc_dev, &nfc_tgt, 1);
+
+done:
+	dev_kfree_skb(resp);
+	return rc;
+
+stop_poll:
+	nfc_err(dev->dev, "autopoll operation has been stopped\n");
+
+	pn533_poll_reset_mod_list(dev);
+	dev->poll_protocols = 0;
+	return rc;
+}
+
 static int pn533_poll_complete(struct pn533 *dev, void *arg,
 			       struct sk_buff *resp)
 {
@@ -1546,6 +1667,7 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 	struct pn533_poll_modulations *cur_mod;
 	u8 rand_mod;
 	int rc;
+	struct sk_buff *skb;
 
 	dev_dbg(dev->dev,
 		"%s: im protocols 0x%x tm protocols 0x%x\n",
@@ -1569,9 +1691,73 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 			tm_protocols = 0;
 	}
 
-	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 	dev->poll_protocols = im_protocols;
 	dev->listen_protocols = tm_protocols;
+	if (dev->device_type == PN533_DEVICE_PN532_AUTOPOLL) {
+		skb = pn533_alloc_skb(dev, 4 + 6);
+		if (!skb)
+			return -ENOMEM;
+
+		*((u8 *)skb_put(skb, sizeof(u8))) =
+			PN532_AUTOPOLL_POLLNR_INFINITE;
+		*((u8 *)skb_put(skb, sizeof(u8))) = PN532_AUTOPOLL_PERIOD;
+
+		if ((im_protocols & NFC_PROTO_MIFARE_MASK) &&
+				(im_protocols & NFC_PROTO_ISO14443_MASK) &&
+				(im_protocols & NFC_PROTO_NFC_DEP_MASK))
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_GENERIC_106;
+		else {
+			if (im_protocols & NFC_PROTO_MIFARE_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_MIFARE;
+
+			if (im_protocols & NFC_PROTO_ISO14443_MASK)
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_ISOA;
+
+			if (im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212;
+				*((u8 *)skb_put(skb, sizeof(u8))) =
+					PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424;
+			}
+		}
+
+		if (im_protocols & NFC_PROTO_FELICA_MASK ||
+				im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA212;
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_FELICA424;
+		}
+
+		if (im_protocols & NFC_PROTO_JEWEL_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_JEWEL;
+
+		if (im_protocols & NFC_PROTO_ISO14443_B_MASK)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_ISOB;
+
+		if (tm_protocols)
+			*((u8 *)skb_put(skb, sizeof(u8))) =
+				PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106;
+
+		rc = pn533_send_cmd_async(dev, PN533_CMD_IN_AUTOPOLL, skb,
+				pn533_autopoll_complete, NULL);
+
+		if (rc < 0)
+			dev_kfree_skb(skb);
+		else
+			dev->poll_mod_count++;
+
+		return rc;
+	}
+
+	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
 
 	/* Do not always start polling from the same modulation */
 	get_random_bytes(&rand_mod, sizeof(rand_mod));
@@ -2471,7 +2657,8 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 	if (dev->phy_ops->dev_up)
 		dev->phy_ops->dev_up(dev);
 
-	if (dev->device_type == PN533_DEVICE_PN532) {
+	if ((dev->device_type == PN533_DEVICE_PN532) ||
+		(dev->device_type == PN533_DEVICE_PN532_AUTOPOLL)) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
 		if (rc)
@@ -2518,6 +2705,7 @@ static int pn533_setup(struct pn533 *dev)
 	case PN533_DEVICE_PASORI:
 	case PN533_DEVICE_ACR122U:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		max_retries.mx_rty_atr = 0x2;
 		max_retries.mx_rty_psl = 0x1;
 		max_retries.mx_rty_passive_act =
@@ -2554,6 +2742,7 @@ static int pn533_setup(struct pn533 *dev)
 	switch (dev->device_type) {
 	case PN533_DEVICE_STD:
 	case PN533_DEVICE_PN532:
+	case PN533_DEVICE_PN532_AUTOPOLL:
 		break;
 
 	case PN533_DEVICE_PASORI:
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 1e54fc6c524f..27398966a95d 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -18,10 +18,11 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#define PN533_DEVICE_STD     0x1
-#define PN533_DEVICE_PASORI  0x2
-#define PN533_DEVICE_ACR122U 0x3
-#define PN533_DEVICE_PN532   0x4
+#define PN533_DEVICE_STD		0x1
+#define PN533_DEVICE_PASORI		0x2
+#define PN533_DEVICE_ACR122U		0x3
+#define PN533_DEVICE_PN532		0x4
+#define PN533_DEVICE_PN532_AUTOPOLL	0x5
 
 #define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK |\
 			     NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK |\
@@ -87,6 +88,7 @@
 #define PN533_CMD_IN_ATR 0x50
 #define PN533_CMD_IN_RELEASE 0x52
 #define PN533_CMD_IN_JUMP_FOR_DEP 0x56
+#define PN533_CMD_IN_AUTOPOLL 0x60
 
 #define PN533_CMD_TG_INIT_AS_TARGET 0x8c
 #define PN533_CMD_TG_GET_DATA 0x86
-- 
2.20.1

