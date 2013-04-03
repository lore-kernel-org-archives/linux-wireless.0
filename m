Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4480 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/25] brcmfmac: add definitions for handling sk_buff
 control buffer data
Date: Wed, 3 Apr 2013 12:40:35 +0200
Message-ID: <1364985650-11719-11-git-send-email-arend@broadcom.com> (sfid-20130403_124305_277552_8B6F443A)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sk_buff structure contains a control buffer that can be used
by different layers in the networking stack for holding packet
associated information. In brcmfmac it is used to hold firmware
signalling related information.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  140 +++++++++++++++-----
 1 file changed, 107 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 69f460b..eba5106 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -138,6 +138,113 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_PSQ_LEN				256
 
 /**
+ * enum brcmf_fws_skb_state - indicates processing state of skb.
+ */
+enum brcmf_fws_skb_state {
+	WLFC_PKTTYPE_NEW,
+	WLFC_PKTTYPE_DELAYED,
+	WLFC_PKTTYPE_SUPPRESSED,
+	WLFC_PKTTYPE_MAX
+};
+
+/**
+ * struct brcmf_skbuff_cb - control buffer associated with skbuff.
+ *
+ * @if_flags: holds interface index and packet related flags.
+ * @da: destination MAC address extracted from skbuff once.
+ * @htod: host to device packet identifier (used in PKTTAG tlv).
+ * @needs_hdr: the packet does not yet have a BDC header.
+ * @state: transmit state of the packet.
+ * @mac: descriptor related to destination for this packet.
+ *
+ * This information is stored in control buffer struct sk_buff::cb, which
+ * provides 48 bytes of storage so this structure should not exceed that.
+ */
+struct brcmf_skbuff_cb {
+	u16 if_flags;
+	u8 da[ETH_ALEN];
+	u32 htod;
+	u8 needs_hdr;
+	enum brcmf_fws_skb_state state;
+	struct brcmf_fws_mac_descriptor *mac;
+};
+
+/**
+ * macro casting skbuff control buffer to struct brcmf_skbuff_cb.
+ */
+#define brcmf_skbcb(skb)	((struct brcmf_skbuff_cb *)((skb)->cb))
+
+/**
+ * sk_buff control if flags
+ *
+ *	b[11]  - packet sent upon firmware request.
+ *	b[10]  - packet only contains signalling data.
+ *	b[9]   - packet is a tx packet.
+ *	b[8]   - packet uses FIFO credit (non-pspoll).
+ *	b[7]   - interface in AP mode.
+ *	b[6:4] - AC FIFO number.
+ *	b[3:0] - interface index.
+ */
+#define BRCMF_SKB_IF_FLAGS_REQUESTED_MASK	0x0800
+#define BRCMF_SKB_IF_FLAGS_REQUESTED_SHIFT	11
+#define BRCMF_SKB_IF_FLAGS_SIGNAL_ONLY_MASK	0x0400
+#define BRCMF_SKB_IF_FLAGS_SIGNAL_ONLY_SHIFT	10
+#define BRCMF_SKB_IF_FLAGS_TRANSMIT_MASK        0x0200
+#define BRCMF_SKB_IF_FLAGS_TRANSMIT_SHIFT	9
+#define BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK	0x0100
+#define BRCMF_SKB_IF_FLAGS_CREDITCHECK_SHIFT	8
+#define BRCMF_SKB_IF_FLAGS_IF_AP_MASK		0x0080
+#define BRCMF_SKB_IF_FLAGS_IF_AP_SHIFT		7
+#define BRCMF_SKB_IF_FLAGS_FIFO_MASK		0x0070
+#define BRCMF_SKB_IF_FLAGS_FIFO_SHIFT		4
+#define BRCMF_SKB_IF_FLAGS_INDEX_MASK		0x000f
+#define BRCMF_SKB_IF_FLAGS_INDEX_SHIFT		0
+
+#define brcmf_skb_if_flags_set_field(skb, field, value) \
+	brcmu_maskset16(&(brcmf_skbcb(skb)->if_flags), \
+			BRCMF_SKB_IF_FLAGS_ ## field ## _MASK, \
+			BRCMF_SKB_IF_FLAGS_ ## field ## _SHIFT, (value))
+#define brcmf_skb_if_flags_get_field(skb, field) \
+	brcmu_maskget16(brcmf_skbcb(skb)->if_flags, \
+			BRCMF_SKB_IF_FLAGS_ ## field ## _MASK, \
+			BRCMF_SKB_IF_FLAGS_ ## field ## _SHIFT)
+
+/**
+ * sk_buff control packet identifier
+ *
+ * 32-bit packet identifier used in PKTTAG tlv from host to dongle.
+ *
+ * - Generated at the host (e.g. dhd)
+ * - Seen as a generic sequence number by firmware except for the flags field.
+ *
+ * Generation	: b[31]	=> generation number for this packet [host->fw]
+ *			   OR, current generation number [fw->host]
+ * Flags	: b[30:27] => command, status flags
+ * FIFO-AC	: b[26:24] => AC-FIFO id
+ * h-slot	: b[23:8] => hanger-slot
+ * freerun	: b[7:0] => A free running counter
+ */
+#define BRCMF_SKB_HTOD_TAG_GENERATION_MASK		0x80000000
+#define BRCMF_SKB_HTOD_TAG_GENERATION_SHIFT		31
+#define BRCMF_SKB_HTOD_TAG_FLAGS_MASK			0x78000000
+#define BRCMF_SKB_HTOD_TAG_FLAGS_SHIFT			27
+#define BRCMF_SKB_HTOD_TAG_FIFO_MASK			0x07000000
+#define BRCMF_SKB_HTOD_TAG_FIFO_SHIFT			24
+#define BRCMF_SKB_HTOD_TAG_HSLOT_MASK			0x00ffff00
+#define BRCMF_SKB_HTOD_TAG_HSLOT_SHIFT			8
+#define BRCMF_SKB_HTOD_TAG_FREERUN_MASK			0x000000ff
+#define BRCMF_SKB_HTOD_TAG_FREERUN_SHIFT			0
+
+#define brcmf_skb_htod_tag_set_field(skb, field, value) \
+	brcmu_maskset32(&(brcmf_skbcb(skb)->htod_tag), \
+			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
+			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT, (value))
+#define brcmf_skb_htod_tag_get_field(skb, field) \
+	brcmu_maskget32(brcmf_skbcb(skb)->htod_tag, \
+			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
+			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT)
+
+/**
  * struct brcmf_fws_mac_descriptor - firmware signalling data per node/interface
  *
  * @occupied: slot is in use.
@@ -160,39 +267,6 @@ struct brcmf_fws_mac_descriptor {
 	struct pktq psq;
 };
 
-/**
- * FWFC packet identifier
- *
- * 32-bit packet identifier used in PKTTAG tlv from host to dongle.
- *
- * - Generated at the host (e.g. dhd)
- * - Seen as a generic sequence number by wlc except the flags field
- *
- * Generation	: b[31]	=> generation number for this packet [host->fw]
- *			   OR, current generation number [fw->host]
- * Flags	: b[30:27] => command, status flags
- * FIFO-AC	: b[26:24] => AC-FIFO id
- * h-slot	: b[23:8] => hanger-slot
- * freerun	: b[7:0] => A free running counter
- */
-#define BRCMF_FWS_PKTTAG_GENERATION_MASK		0x80000000
-#define BRCMF_FWS_PKTTAG_GENERATION_SHIFT		31
-#define BRCMF_FWS_PKTTAG_FLAGS_MASK			0x78000000
-#define BRCMF_FWS_PKTTAG_FLAGS_SHIFT			27
-#define BRCMF_FWS_PKTTAG_FIFO_MASK			0x07000000
-#define BRCMF_FWS_PKTTAG_FIFO_SHIFT			24
-#define BRCMF_FWS_PKTTAG_HSLOT_MASK			0x00ffff00
-#define BRCMF_FWS_PKTTAG_HSLOT_SHIFT			8
-#define BRCMF_FWS_PKTTAG_FREERUN_MASK			0x000000ff
-#define BRCMF_FWS_PKTTAG_FREERUN_SHIFT			0
-
-#define brcmf_fws_pkttag_set_field(var, field, value) \
-	brcmu_maskset32((var), BRCMF_FWS_PKTTAG_ ## field ## _MASK, \
-			     BRCMF_FWS_PKTTAG_ ## field ## _SHIFT, (value))
-#define brcmf_fws_pkttag_get_field(var, field) \
-	brcmu_maskget32((var), BRCMF_FWS_PKTTAG_ ## field ## _MASK, \
-			     BRCMF_FWS_PKTTAG_ ## field ## _SHIFT)
-
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
-- 
1.7.10.4


