Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19281 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488AbXHaE64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/6] adm8211: Move things from adm8211.c to adm8211.h
Date: Fri, 31 Aug 2007 00:55:43 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310055.43888.flamingice@sourmilk.net>
In-Reply-To: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
References: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Some definitions in adm8211.c should be in adm8211.h.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   54 ++--------------------------------------
 drivers/net/wireless/adm8211.h |   46 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index e307412..76b1a48 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -57,56 +57,6 @@ static struct pci_device_id adm8211_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
-#define ADM8211_INTMASK \
-(ADM8211_IER_NIE | ADM8211_IER_AIE | ADM8211_IER_RCIE | ADM8211_IER_TCIE | \
-ADM8211_IER_TDUIE | ADM8211_IER_GPTIE)
-
-#define PLCP_SIGNAL_1M		0x0a
-#define PLCP_SIGNAL_2M		0x14
-#define PLCP_SIGNAL_5M5		0x37
-#define PLCP_SIGNAL_11M		0x6e
-
-#define ADM8211_RX_MAX_SSI	100
-
-struct adm8211_tx_hdr {
-	u8 da[6];
-	u8 signal; /* PLCP signal / TX rate in 100 Kbps */
-	u8 service;
-	__le16 frame_body_size;
-	__le16 frame_control;
-	__le16 plcp_frag_tail_len;
-	__le16 plcp_frag_head_len;
-	__le16 dur_frag_tail;
-	__le16 dur_frag_head;
-	u8 addr4[6];
-
-#define ADM8211_TXHDRCTL_SHORT_PREAMBLE		(1 <<  0)
-#define ADM8211_TXHDRCTL_MORE_FRAG		(1 <<  1)
-#define ADM8211_TXHDRCTL_MORE_DATA		(1 <<  2)
-#define ADM8211_TXHDRCTL_FRAG_NO		(1 <<  3) /* ? */
-#define ADM8211_TXHDRCTL_ENABLE_RTS		(1 <<  4)
-#define ADM8211_TXHDRCTL_ENABLE_WEP_ENGINE	(1 <<  5)
-#define ADM8211_TXHDRCTL_ENABLE_EXTEND_HEADER	(1 << 15) /* ? */
-	__le16 header_control;
-	__le16 frag;
-	u8 reserved_0;
-	u8 retry_limit;
-
-	u32 wep2key0;
-	u32 wep2key1;
-	u32 wep2key2;
-	u32 wep2key3;
-
-	u8 keyid;
-	u8 entry_control;	// huh??
-	u16 reserved_1;
-	u32 reserved_2;
-} __attribute__ ((packed));
-
-
-#define RX_COPY_BREAK 128
-#define RX_PKT_SIZE 2500
-
 static void adm8211_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 {
 	struct adm8211_priv *priv = eeprom->data;
@@ -1602,7 +1552,9 @@ static int adm8211_open(struct ieee80211_hw *dev)
 		goto fail;
 	}
 
-	ADM8211_CSR_WRITE(IER, ADM8211_INTMASK);
+	ADM8211_CSR_WRITE(IER, ADM8211_IER_NIE | ADM8211_IER_AIE |
+			       ADM8211_IER_RCIE | ADM8211_IER_TCIE |
+			       ADM8211_IER_TDUIE | ADM8211_IER_GPTIE);
 	adm8211_update_mode(dev);
 	ADM8211_CSR_WRITE(RDR, 0);
 
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index fa80f5f..6bf6eac 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -451,6 +451,52 @@ struct adm8211_tx_ring_info {
 	struct ieee80211_hdr hdr;
 };
 
+#define PLCP_SIGNAL_1M		0x0a
+#define PLCP_SIGNAL_2M		0x14
+#define PLCP_SIGNAL_5M5		0x37
+#define PLCP_SIGNAL_11M		0x6e
+
+#define ADM8211_RX_MAX_SSI	100
+
+struct adm8211_tx_hdr {
+	u8 da[6];
+	u8 signal; /* PLCP signal / TX rate in 100 Kbps */
+	u8 service;
+	__le16 frame_body_size;
+	__le16 frame_control;
+	__le16 plcp_frag_tail_len;
+	__le16 plcp_frag_head_len;
+	__le16 dur_frag_tail;
+	__le16 dur_frag_head;
+	u8 addr4[6];
+
+#define ADM8211_TXHDRCTL_SHORT_PREAMBLE		(1 <<  0)
+#define ADM8211_TXHDRCTL_MORE_FRAG		(1 <<  1)
+#define ADM8211_TXHDRCTL_MORE_DATA		(1 <<  2)
+#define ADM8211_TXHDRCTL_FRAG_NO		(1 <<  3) /* ? */
+#define ADM8211_TXHDRCTL_ENABLE_RTS		(1 <<  4)
+#define ADM8211_TXHDRCTL_ENABLE_WEP_ENGINE	(1 <<  5)
+#define ADM8211_TXHDRCTL_ENABLE_EXTEND_HEADER	(1 << 15) /* ? */
+	__le16 header_control;
+	__le16 frag;
+	u8 reserved_0;
+	u8 retry_limit;
+
+	u32 wep2key0;
+	u32 wep2key1;
+	u32 wep2key2;
+	u32 wep2key3;
+
+	u8 keyid;
+	u8 entry_control;	// huh??
+	u16 reserved_1;
+	u32 reserved_2;
+} __attribute__ ((packed));
+
+
+#define RX_COPY_BREAK 128
+#define RX_PKT_SIZE 2500
+
 struct adm8211_eeprom {
 	__le16	signature;		/* 0x00 */
 	u8	major_version;		/* 0x02 */

