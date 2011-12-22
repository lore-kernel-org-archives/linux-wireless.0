Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64549 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab1LVJui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 04:50:38 -0500
Received: by obcwo16 with SMTP id wo16so3978154obc.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 01:50:37 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Export a new attribute nfcid1 in target info
Date: Thu, 22 Dec 2011 11:51:54 +0200
Message-Id: <1324547514-3237-1-git-send-email-ilane@ti.com> (sfid-20111222_105043_530296_966CFD6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

The nfcid1 is the NFC-A identifier.
It is exported as an attribute of the target info
(returned as a response to NFC_CMD_GET_TARGET).

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/linux/nfc.h   |    2 ++
 include/net/nfc/nfc.h |    3 +++
 net/nfc/nci/ntf.c     |    6 ++++++
 net/nfc/netlink.c     |    3 +++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 89fee4a..01d4e5d 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -88,6 +88,7 @@ enum nfc_commands {
  * @NFC_ATTR_TARGET_SENS_RES: NFC-A targets extra information such as NFCID
  * @NFC_ATTR_TARGET_SEL_RES: NFC-A targets extra information (useful if the
  *	target is not NFC-Forum compliant)
+ * @NFC_ATTR_TARGET_NFCID1: NFC-A targets identifier, max 10 bytes
  * @NFC_ATTR_COMM_MODE: Passive or active mode
  * @NFC_ATTR_RF_MODE: Initiator or target
  */
@@ -99,6 +100,7 @@ enum nfc_attrs {
 	NFC_ATTR_TARGET_INDEX,
 	NFC_ATTR_TARGET_SENS_RES,
 	NFC_ATTR_TARGET_SEL_RES,
+	NFC_ATTR_TARGET_NFCID1,
 	NFC_ATTR_COMM_MODE,
 	NFC_ATTR_RF_MODE,
 /* private: internal use only */
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index ccfe757..8696b77 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -65,12 +65,15 @@ struct nfc_ops {
 
 #define NFC_TARGET_IDX_ANY -1
 #define NFC_MAX_GT_LEN 48
+#define NFC_MAX_NFCID1_LEN 10
 
 struct nfc_target {
 	u32 idx;
 	u32 supported_protocols;
 	u16 sens_res;
 	u8 sel_res;
+	u8 nfcid1_len;
+	u8 nfcid1[NFC_MAX_NFCID1_LEN];
 };
 
 struct nfc_genl_data {
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 003846b..b2b04b8 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -137,6 +137,12 @@ static void nci_target_found(struct nci_dev *ndev,
 
 	nfc_tgt.sens_res = ntf->rf_tech_specific_params.nfca_poll.sens_res;
 	nfc_tgt.sel_res = ntf->rf_tech_specific_params.nfca_poll.sel_res;
+	nfc_tgt.nfcid1_len = ntf->rf_tech_specific_params.nfca_poll.nfcid1_len;
+	if (nfc_tgt.nfcid1_len > 0) {
+		memcpy(nfc_tgt.nfcid1,
+			ntf->rf_tech_specific_params.nfca_poll.nfcid1,
+			nfc_tgt.nfcid1_len);
+	}
 
 	if (!(nfc_tgt.supported_protocols & ndev->poll_prots)) {
 		pr_debug("the target found does not have the desired protocol\n");
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 43a1c47..6989dfa 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -67,6 +67,9 @@ static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
 				target->supported_protocols);
 	NLA_PUT_U16(msg, NFC_ATTR_TARGET_SENS_RES, target->sens_res);
 	NLA_PUT_U8(msg, NFC_ATTR_TARGET_SEL_RES, target->sel_res);
+	if (target->nfcid1_len > 0)
+		NLA_PUT(msg, NFC_ATTR_TARGET_NFCID1, target->nfcid1_len,
+				target->nfcid1);
 
 	return genlmsg_end(msg, hdr);
 
-- 
1.7.0.4

