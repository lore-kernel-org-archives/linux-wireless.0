Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-03.prod.phx3.secureserver.net ([173.201.192.104]:47315
	"EHLO p3plsmtpa06-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaAOBAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 20:00:12 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 1/3] NFC: iso15693 - Add ISO/IEC 15693 header definitions
Date: Tue, 14 Jan 2014 17:52:09 -0700
Message-Id: <1389747131-2577-2-git-send-email-mgreer@animalcreek.com> (sfid-20140115_020015_850342_B8FDDBDA)
In-Reply-To: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
References: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the header definitions required by upcoming
patches that add support for ISO/IEC 15693.

Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 include/net/nfc/digital.h | 4 ++++
 include/net/nfc/nfc.h     | 3 +++
 include/uapi/linux/nfc.h  | 9 ++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/net/nfc/digital.h b/include/net/nfc/digital.h
index 81af21e..1f0528d 100644
--- a/include/net/nfc/digital.h
+++ b/include/net/nfc/digital.h
@@ -35,6 +35,7 @@ enum {
 	NFC_DIGITAL_RF_TECH_106A = 0,
 	NFC_DIGITAL_RF_TECH_212F,
 	NFC_DIGITAL_RF_TECH_424F,
+	NFC_DIGITAL_RF_TECH_ISO15693,
 
 	NFC_DIGITAL_RF_TECH_LAST,
 };
@@ -57,6 +58,9 @@ enum {
 	NFC_DIGITAL_FRAMING_NFCF_NFC_DEP,
 	NFC_DIGITAL_FRAMING_NFC_DEP_ACTIVATED,
 
+	NFC_DIGITAL_FRAMING_ISO15693_INVENTORY,
+	NFC_DIGITAL_FRAMING_ISO15693_TVT,	/* Type V Tag (ISO/IEC 15693) */
+
 	NFC_DIGITAL_FRAMING_LAST,
 };
 
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 82fc4e4..44943e1 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -113,6 +113,9 @@ struct nfc_target {
 	u8 sensf_res[NFC_SENSF_RES_MAXSIZE];
 	u8 hci_reader_gate;
 	u8 logical_idx;
+	u8 is_iso15693;
+	u8 iso15693_dsfid;
+	u8 iso15693_uid[NFC_ISO15693_UID_MAXSIZE];
 };
 
 /**
diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index 6ad6cc0..9789dc9 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -150,6 +150,8 @@ enum nfc_commands {
  * @NFC_ATTR_SE_TYPE: Secure element type (UICC or EMBEDDED)
  * @NFC_ATTR_FIRMWARE_DOWNLOAD_STATUS: Firmware download operation status
  * @NFC_ATTR_APDU: Secure element APDU
+ * @NFC_ATTR_TARGET_ISO15693_DSFID: ISO 15693 Data Storage Format Identifier
+ * @NFC_ATTR_TARGET_ISO15693_UID: ISO 15693 Unique Identifier
  */
 enum nfc_attrs {
 	NFC_ATTR_UNSPEC,
@@ -178,6 +180,8 @@ enum nfc_attrs {
 	NFC_ATTR_SE_AID,
 	NFC_ATTR_FIRMWARE_DOWNLOAD_STATUS,
 	NFC_ATTR_SE_APDU,
+	NFC_ATTR_TARGET_ISO15693_DSFID,
+	NFC_ATTR_TARGET_ISO15693_UID,
 /* private: internal use only */
 	__NFC_ATTR_AFTER_LAST
 };
@@ -200,6 +204,7 @@ enum nfc_sdp_attr {
 #define NFC_SENSF_RES_MAXSIZE 18
 #define NFC_GB_MAXSIZE        48
 #define NFC_FIRMWARE_NAME_MAXSIZE 32
+#define NFC_ISO15693_UID_MAXSIZE 8
 
 /* NFC protocols */
 #define NFC_PROTO_JEWEL		1
@@ -208,8 +213,9 @@ enum nfc_sdp_attr {
 #define NFC_PROTO_ISO14443	4
 #define NFC_PROTO_NFC_DEP	5
 #define NFC_PROTO_ISO14443_B	6
+#define NFC_PROTO_ISO15693	7
 
-#define NFC_PROTO_MAX		7
+#define NFC_PROTO_MAX		8
 
 /* NFC communication modes */
 #define NFC_COMM_ACTIVE  0
@@ -227,6 +233,7 @@ enum nfc_sdp_attr {
 #define NFC_PROTO_ISO14443_MASK	  (1 << NFC_PROTO_ISO14443)
 #define NFC_PROTO_NFC_DEP_MASK	  (1 << NFC_PROTO_NFC_DEP)
 #define NFC_PROTO_ISO14443_B_MASK (1 << NFC_PROTO_ISO14443_B)
+#define NFC_PROTO_ISO15693_MASK	  (1 << NFC_PROTO_ISO15693)
 
 /* NFC Secure Elements */
 #define NFC_SE_UICC     0x1
-- 
1.8.3.4

