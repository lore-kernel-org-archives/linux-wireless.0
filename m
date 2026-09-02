Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D3A4A9D54
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368108; cv=none; b=FLnfOQRcOiTmhiPZTEZXm1+YwTPzmwwKSrO5m6K8GTQg2moY34KJUN81FbEreP74Xlxu1TuG04Swrvqgaz8rN7Hv09QAYiyywqrDMa1gimy2ycHLZHAM02jXl24ukf1jSrxWTFVAqobr7QirIOk7e5Ce3NbaF9mu1QvpQi5i7Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368108; c=relaxed/simple;
	bh=HSqYFwb5qTdi2e5yPxX4ouRQA5XDh1QbwAviumkCjtA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKorAnqz5UASSot+ssi7/85Q8wLtpveiVk/a9lcQms53Ynz7LNrLIuJ3T9XYjDmjmJPgbLy/dc2FT+CHRBBKY9CKObbTjNYJc3S7UJdKWPtgICBCl/OTnycIVlJykBzz2GL0qhKBLIFO6jEDQNrDM963ON0ghw0tp4cj2W+FIws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=pSK1gnb4; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="pSK1gnb4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368103; x=1819904103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HSqYFwb5qTdi2e5yPxX4ouRQA5XDh1QbwAviumkCjtA=;
  b=pSK1gnb4DgyZWhO981E0rD3rjFyPpbTLewzOddq/5m9+YeHCjOCdh/oe
   vz2G4IxZCFxHRiNKH6ih4wbALNQf4/QYKWxKj/gjeowr4WwBoj/+UunaL
   mnpfbI9eNxw6So64gyz77Bb0BvbCMGgmKYQBiW4NNFFd9PyFTJ6WOmN5O
   c=;
X-CSE-ConnectionGUID: r+zCyI5tQPeKkPQfF/FjFw==
X-CSE-MsgGUID: 1V1PQMP6Rn+mvsWfj5HjVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="107705957"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="107705957"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:55:01 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:55:00 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:54:58 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 18/25] wifi: inffmac: add fwsignal.c/h
Date: Wed, 2 Sep 2026 16:50:49 +0000
Message-ID: <20260902165057.456447-19-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE827.infineon.com (172.23.29.20)

Implementation of the firmware signalling used for flow control during
Data transmission between Host Driver and Device firmware via the SDIO bus.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/fwsignal.c  | 3017 +++++++++++++++++
 .../net/wireless/infineon/inffmac/fwsignal.h  |   53 +
 2 files changed, 3070 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/fwsignal.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/fwsignal.h

diff --git a/drivers/net/wireless/infineon/inffmac/fwsignal.c b/drivers/net/wireless/infineon/inffmac/fwsignal.c
new file mode 100644
index 000000000000..637b50bd6499
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/fwsignal.c
@@ -0,0 +1,3017 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/if_ether.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/err.h>
+#include <linux/jiffies.h>
+#include <net/cfg80211.h>
+
+#include "main.h"
+#include "net.h"
+#include "utils.h"
+#include "chan.h"
+#include "debug.h"
+#include "dev_cmd.h"
+#include "dev_evt.h"
+#include "fwsignal.h"
+#include "cfg80211.h"
+#include "bus_proto.h"
+#include "bcdc.h"
+#include "chip.h"
+#include "sdio.h"
+
+/**
+ * DOC: Firmware Signalling
+ *
+ * Firmware can send signals to host and vice versa, which are passed in the
+ * data packets using TLV based header. This signalling layer is on top of the
+ * BDC bus protocol layer.
+ */
+/*
+ * enum inff_fws_tlv_type - definition of tlv identifiers.
+ */
+enum inff_fws_tlv_type {
+	INFF_FWS_TYPE_MAC_OPEN = 1,
+	INFF_FWS_TYPE_MAC_CLOSE = 2,
+	INFF_FWS_TYPE_MAC_REQUEST_CREDIT = 3,
+	INFF_FWS_TYPE_TXSTATUS = 4,
+	INFF_FWS_TYPE_PKTTAG = 5,
+	INFF_FWS_TYPE_MACDESC_ADD = 6,
+	INFF_FWS_TYPE_MACDESC_DEL = 7,
+	INFF_FWS_TYPE_RSSI = 8,
+	INFF_FWS_TYPE_INTERFACE_OPEN = 9,
+	INFF_FWS_TYPE_INTERFACE_CLOSE = 10,
+	INFF_FWS_TYPE_FIFO_CREDITBACK = 11,
+	INFF_FWS_TYPE_PENDING_TRAFFIC_BMP = 12,
+	INFF_FWS_TYPE_MAC_REQUEST_PACKET = 13,
+	INFF_FWS_TYPE_HOST_REORDER_RXPKTS = 14,
+	INFF_FWS_TYPE_TRANS_ID = 18,
+	INFF_FWS_TYPE_COMP_TXSTATUS = 19,
+	INFF_FWS_TYPE_FILLER = 255,
+	INFF_FWS_TYPE_INVALID
+};
+
+#define INFF_FWS_TYPE_FIFO_CREDITBACK_V2_LEN   12
+#define INFF_FIFO_CREDITBACK_TX_OFFSET         6
+
+/*
+ * enum inff_fws_tlv_len - definition of tlv lengths.
+ */
+enum inff_fws_tlv_len {
+	INFF_FWS_TYPE_MAC_OPEN_LEN = 1,
+	INFF_FWS_TYPE_MAC_CLOSE_LEN = 1,
+	INFF_FWS_TYPE_MAC_REQUEST_CREDIT_LEN = 2,
+	INFF_FWS_TYPE_TXSTATUS_LEN = 4,
+	INFF_FWS_TYPE_PKTTAG_LEN = 4,
+	INFF_FWS_TYPE_MACDESC_ADD_LEN = 8,
+	INFF_FWS_TYPE_MACDESC_DEL_LEN = 8,
+	INFF_FWS_TYPE_RSSI_LEN = 1,
+	INFF_FWS_TYPE_INTERFACE_OPEN_LEN = 1,
+	INFF_FWS_TYPE_INTERFACE_CLOSE_LEN = 1,
+	INFF_FWS_TYPE_FIFO_CREDITBACK_LEN = 6,
+	INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN = 2,
+	INFF_FWS_TYPE_MAC_REQUEST_PACKET_LEN = 3,
+	INFF_FWS_TYPE_HOST_REORDER_RXPKTS_LEN = 10,
+	INFF_FWS_TYPE_TRANS_ID_LEN = 6,
+	INFF_FWS_TYPE_COMP_TXSTATUS_LEN = 1,
+	INFF_FWS_TYPE_FILLER_LEN = 0
+};
+
+/* AMPDU rx reordering definitions */
+#define INFF_RXREORDER_FLOWID_OFFSET		0
+#define INFF_RXREORDER_MAXIDX_OFFSET		2
+#define INFF_RXREORDER_FLAGS_OFFSET		4
+#define INFF_RXREORDER_CURIDX_OFFSET		6
+#define INFF_RXREORDER_EXPIDX_OFFSET		8
+
+#define INFF_RXREORDER_DEL_FLOW		0x01
+#define INFF_RXREORDER_FLUSH_ALL		0x02
+#define INFF_RXREORDER_CURIDX_VALID		0x04
+#define INFF_RXREORDER_EXPIDX_VALID		0x08
+#define INFF_RXREORDER_NEW_HOLE		0x10
+
+#ifdef DEBUG
+/*
+ * inff_fws_tlv_names - array of tlv names.
+ */
+static struct {
+	enum inff_fws_tlv_type id;
+	const char *name;
+} inff_fws_tlv_names[] = {
+	{1, "MAC_OPEN"},
+	{2, "MAC_CLOSE"},
+	{3, "MAC_REQUEST_CREDIT"},
+	{4, "TXSTATUS"},
+	{5, "PKTTAG"},
+	{6, "MACDESC_ADD"},
+	{7, "MACDESC_DEL"},
+	{8, "RSSI"},
+	{9, "INTERFACE_OPEN"},
+	{10, "INTERFACE_CLOSE"},
+	{11, "FIFO_CREDITBACK"},
+	{12, "PENDING_TRAFFIC_BMP"},
+	{13, "MAC_REQUEST_PACKET"},
+	{14, "HOST_REORDER_RXPKTS"},
+	{18, "TRANS_ID"},
+	{19, "COMP_TXSTATUS"},
+	{255, "FILLER"}
+};
+
+static const char *inff_fws_get_tlv_name(enum inff_fws_tlv_type id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(inff_fws_tlv_names); i++)
+		if (inff_fws_tlv_names[i].id == id)
+			return inff_fws_tlv_names[i].name;
+
+	return "INVALID";
+}
+#else
+static const char *inff_fws_get_tlv_name(enum inff_fws_tlv_type id)
+{
+	return "NODEBUG";
+}
+#endif /* DEBUG */
+
+/*
+ * The PKTTAG tlv has additional bytes when firmware-signalling
+ * mode has REUSESEQ flag set.
+ */
+#define INFF_FWS_TYPE_SEQ_LEN				2
+
+/*
+ * flags used to enable tlv signalling from firmware.
+ */
+#define INFF_FWS_FLAGS_RSSI_SIGNALS			0x0001
+#define INFF_FWS_FLAGS_XONXOFF_SIGNALS			0x0002
+#define INFF_FWS_FLAGS_CREDIT_STATUS_SIGNALS		0x0004
+#define INFF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE	0x0008
+#define INFF_FWS_FLAGS_PSQ_GENERATIONFSM_ENABLE	0x0010
+#define INFF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE		0x0020
+#define INFF_FWS_FLAGS_HOST_RXREORDER_ACTIVE		0x0040
+
+#define INFF_FWS_MAC_DESC_TABLE_SIZE			32
+#define INFF_FWS_MAC_DESC_ID_INVALID			0xff
+
+#define INFF_FWS_HOSTIF_FLOWSTATE_OFF			0
+#define INFF_FWS_HOSTIF_FLOWSTATE_ON			1
+#define INFF_FWS_FLOWCONTROL_HIWATER			((256 * 8) - 256)
+#define INFF_FWS_FLOWCONTROL_LOWATER			256
+
+#define INFF_FWS_PSQ_PREC_COUNT		((INFF_FWS_FIFO_COUNT + 1) * 2)
+#define INFF_FWS_PSQ_LEN				(256 * 8)
+#define INFF_FWS_AFQ_PREC_COUNT		(INFF_FWS_FIFO_COUNT + 1)
+#define INFF_FWS_AFQ_LEN				(4096 * 8)
+
+#define INFF_FWS_HTOD_FLAG_PKTFROMHOST			0x01
+#define INFF_FWS_HTOD_FLAG_PKT_REQUESTED		0x02
+
+#define INFF_FWS_RET_OK_NOSCHEDULE			0
+#define INFF_FWS_RET_OK_SCHEDULE			1
+
+#define INFF_FWS_MODE_HANGER			1 /* use hanger */
+#define INFF_FWS_MODE_AFQ			2 /* use afq */
+#define INFF_FWS_MODE_IS_OLD_DEF(x)		(((x) & 3U) != 0)
+
+#define INFF_FWS_MODE_AFQ_SHIFT			2
+#define INFF_FWS_MODE_GET_AFQ(x)		(((x) >> INFF_FWS_MODE_AFQ_SHIFT) & 1)
+
+#define INFF_FWS_MODE_REUSESEQ_SHIFT			3	/* seq reuse */
+#define INFF_FWS_MODE_SET_REUSESEQ(x, val)	{ \
+		typeof(x) _x = (x); \
+		((_x) = \
+		((_x) & ~(1 << INFF_FWS_MODE_REUSESEQ_SHIFT)) | \
+		(((val) & 1) << INFF_FWS_MODE_REUSESEQ_SHIFT)); \
+		}
+#define INFF_FWS_MODE_GET_REUSESEQ(x)	\
+		(((x) >> INFF_FWS_MODE_REUSESEQ_SHIFT) & 1)
+
+#define INFF_FWS_MODE_REORDERSUPP_SHIFT		4
+#define INFF_FWS_MODE_GET_REORDERSUPP(x)	(((x) >> INFF_FWS_MODE_REORDERSUPP_SHIFT) & 1)
+
+static inline u32 inff_fws_mode_set_afq(u32 mode, u8 val)
+{
+	return (mode & ~(1 << INFF_FWS_MODE_AFQ_SHIFT)) |
+	       ((val & 1) << INFF_FWS_MODE_AFQ_SHIFT);
+}
+
+static inline u32 inff_fws_mode_set_reordersupp(u32 mode, u8 val)
+{
+	return (mode & ~(1 << INFF_FWS_MODE_REORDERSUPP_SHIFT)) |
+	       ((val & 1) << INFF_FWS_MODE_REORDERSUPP_SHIFT);
+}
+
+/**
+ * enum inff_fws_skb_state - indicates processing state of skb.
+ *
+ * @INFF_FWS_SKBSTATE_NEW: sk_buff is newly arrived in the driver.
+ * @INFF_FWS_SKBSTATE_DELAYED: sk_buff had to wait on queue.
+ * @INFF_FWS_SKBSTATE_SUPPRESSED: sk_buff has been suppressed by firmware.
+ * @INFF_FWS_SKBSTATE_TIM: allocated for TIM update info.
+ */
+enum inff_fws_skb_state {
+	INFF_FWS_SKBSTATE_NEW,
+	INFF_FWS_SKBSTATE_DELAYED,
+	INFF_FWS_SKBSTATE_SUPPRESSED,
+	INFF_FWS_SKBSTATE_TIM
+};
+
+/**
+ * struct inff_skbuff_cb - control buffer associated with skbuff.
+ *
+ * @bus_flags: 2 bytes reserved for bus specific parameters
+ * @if_flags: holds interface index and packet related flags.
+ * @htod: host to device packet identifier (used in PKTTAG tlv).
+ * @htod_seq: this 16-bit is original seq number for every suppress packet.
+ * @state: transmit state of the packet.
+ * @mac: descriptor related to destination for this packet.
+ *
+ * This information is stored in control buffer struct sk_buff::cb, which
+ * provides 48 bytes of storage so this structure should not exceed that.
+ */
+struct inff_skbuff_cb {
+	u16 bus_flags;
+	u16 if_flags;
+	u32 htod;
+	u16 htod_seq;
+	enum inff_fws_skb_state state;
+	struct inff_fws_mac_descriptor *mac;
+};
+
+/*
+ * macro casting skbuff control buffer to struct inff_skbuff_cb.
+ */
+#define inff_skbcb(skb)	((struct inff_skbuff_cb *)((skb)->cb))
+
+/*
+ * sk_buff control if flags
+ *
+ *	b[11]  - packet sent upon firmware request.
+ *	b[10]  - packet only contains signalling data.
+ *	b[9]   - packet is a tx packet.
+ *	b[8]   - packet used requested credit
+ *	b[7]   - interface in AP mode.
+ *	b[3:0] - interface index.
+ */
+#define INFF_SKB_IF_FLAGS_REQUESTED_MASK	0x0800
+#define INFF_SKB_IF_FLAGS_REQUESTED_SHIFT	11
+#define INFF_SKB_IF_FLAGS_SIGNAL_ONLY_MASK	0x0400
+#define INFF_SKB_IF_FLAGS_SIGNAL_ONLY_SHIFT	10
+#define INFF_SKB_IF_FLAGS_TRANSMIT_MASK        0x0200
+#define INFF_SKB_IF_FLAGS_TRANSMIT_SHIFT	9
+#define INFF_SKB_IF_FLAGS_REQ_CREDIT_MASK	0x0100
+#define INFF_SKB_IF_FLAGS_REQ_CREDIT_SHIFT	8
+#define INFF_SKB_IF_FLAGS_IF_AP_MASK		0x0080
+#define INFF_SKB_IF_FLAGS_IF_AP_SHIFT		7
+#define INFF_SKB_IF_FLAGS_INDEX_MASK		0x000f
+#define INFF_SKB_IF_FLAGS_INDEX_SHIFT		0
+
+#define inff_skb_if_flags_set_field(skb, field, value) \
+	inff_maskset16(&(inff_skbcb(skb)->if_flags), \
+			INFF_SKB_IF_FLAGS_ ## field ## _MASK, \
+			INFF_SKB_IF_FLAGS_ ## field ## _SHIFT, (value))
+#define inff_skb_if_flags_get_field(skb, field) \
+	inff_maskget16(inff_skbcb(skb)->if_flags, \
+			INFF_SKB_IF_FLAGS_ ## field ## _MASK, \
+			INFF_SKB_IF_FLAGS_ ## field ## _SHIFT)
+
+/*
+ * sk_buff control packet identifier
+ *
+ * 32-bit packet identifier used in PKTTAG tlv from host to dongle.
+ *
+ * - Generated at the host driver
+ * - Seen as a generic sequence number by firmware except for the flags field.
+ *
+ * Generation	: b[31]	=> generation number for this packet [host->fw]
+ *			   OR, current generation number [fw->host]
+ * Flags	: b[30:27] => command, status flags
+ * FIFO-AC	: b[26:24] => AC-FIFO id
+ * h-slot	: b[23:8] => hanger-slot
+ * freerun	: b[7:0] => A free running counter
+ */
+#define INFF_SKB_HTOD_TAG_GENERATION_MASK		0x80000000
+#define INFF_SKB_HTOD_TAG_GENERATION_SHIFT		31
+#define INFF_SKB_HTOD_TAG_FLAGS_MASK			0x78000000
+#define INFF_SKB_HTOD_TAG_FLAGS_SHIFT			27
+#define INFF_SKB_HTOD_TAG_FIFO_MASK			0x07000000
+#define INFF_SKB_HTOD_TAG_FIFO_SHIFT			24
+#define INFF_SKB_HTOD_TAG_HSLOT_MASK			0x00ffff00
+#define INFF_SKB_HTOD_TAG_HSLOT_SHIFT			8
+#define INFF_SKB_HTOD_TAG_FREERUN_MASK			0x000000ff
+#define INFF_SKB_HTOD_TAG_FREERUN_SHIFT		0
+
+#define inff_skb_htod_tag_set_field(skb, field, value) \
+	inff_maskset32(&(inff_skbcb(skb)->htod), \
+			INFF_SKB_HTOD_TAG_ ## field ## _MASK, \
+			INFF_SKB_HTOD_TAG_ ## field ## _SHIFT, (value))
+#define inff_skb_htod_tag_get_field(skb, field) \
+	inff_maskget32(inff_skbcb(skb)->htod, \
+			INFF_SKB_HTOD_TAG_ ## field ## _MASK, \
+			INFF_SKB_HTOD_TAG_ ## field ## _SHIFT)
+
+#define INFF_SKB_HTOD_SEQ_FROMFW_MASK			0x2000
+#define INFF_SKB_HTOD_SEQ_FROMFW_SHIFT			13
+#define INFF_SKB_HTOD_SEQ_FROMDRV_MASK			0x1000
+#define INFF_SKB_HTOD_SEQ_FROMDRV_SHIFT		12
+#define INFF_SKB_HTOD_SEQ_NR_MASK			0x0fff
+#define INFF_SKB_HTOD_SEQ_NR_SHIFT			0
+
+#define inff_skb_htod_seq_set_field(skb, field, value) \
+	inff_maskset16(&(inff_skbcb(skb)->htod_seq), \
+			INFF_SKB_HTOD_SEQ_ ## field ## _MASK, \
+			INFF_SKB_HTOD_SEQ_ ## field ## _SHIFT, (value))
+#define inff_skb_htod_seq_get_field(skb, field) \
+	inff_maskget16(inff_skbcb(skb)->htod_seq, \
+			INFF_SKB_HTOD_SEQ_ ## field ## _MASK, \
+			INFF_SKB_HTOD_SEQ_ ## field ## _SHIFT)
+
+#define INFF_FWS_TXSTAT_GENERATION_MASK	0x80000000
+#define INFF_FWS_TXSTAT_GENERATION_SHIFT	31
+#define INFF_FWS_TXSTAT_FLAGS_MASK		0x78000000
+#define INFF_FWS_TXSTAT_FLAGS_SHIFT		27
+#define INFF_FWS_TXSTAT_FIFO_MASK		0x07000000
+#define INFF_FWS_TXSTAT_FIFO_SHIFT		24
+#define INFF_FWS_TXSTAT_HSLOT_MASK		0x00FFFF00
+#define INFF_FWS_TXSTAT_HSLOT_SHIFT		8
+#define INFF_FWS_TXSTAT_FREERUN_MASK		0x000000FF
+#define INFF_FWS_TXSTAT_FREERUN_SHIFT		0
+
+#define inff_txstatus_get_field(txs, field) \
+	inff_maskget32(txs, INFF_FWS_TXSTAT_ ## field ## _MASK, \
+			INFF_FWS_TXSTAT_ ## field ## _SHIFT)
+
+/* How long to defer borrowing in jiffies */
+#define INFF_FWS_BORROW_DEFER_PERIOD		(HZ / 10)
+
+/**
+ * enum inff_fws_txstatus - txstatus flag values.
+ *
+ * @INFF_FWS_TXSTATUS_DISCARD:
+ *	host is free to discard the packet.
+ * @INFF_FWS_TXSTATUS_CORE_SUPPRESS:
+ *	802.11 core suppressed the packet.
+ * @INFF_FWS_TXSTATUS_FW_PS_SUPPRESS:
+ *	firmware suppress the packet as device is already in PS mode.
+ * @INFF_FWS_TXSTATUS_FW_TOSSED:
+ *	firmware tossed the packet.
+ * @INFF_FWS_TXSTATUS_FW_DISCARD_NOACK:
+ *	firmware tossed the packet after retries.
+ * @INFF_FWS_TXSTATUS_FW_SUPPRESS_ACKED:
+ *	firmware wrongly reported suppressed previously, now fixing to acked.
+ * @INFF_FWS_TXSTATUS_FW_EXPIRED:
+ *	firmware expired the packet.
+ * @INFF_FWS_TXSTATUS_FW_DROPPED:
+ *	firmware dropped the packet.
+ * @INFF_FWS_TXSTATUS_FW_MKTFREE:
+ *	firmware marked the packet free.
+ */
+enum inff_fws_txstatus {
+	INFF_FWS_TXSTATUS_DISCARD = 0,
+	INFF_FWS_TXSTATUS_CORE_SUPPRESS = 1,
+	INFF_FWS_TXSTATUS_FW_PS_SUPPRESS = 2,
+	INFF_FWS_TXSTATUS_FW_TOSSED = 3,
+	INFF_FWS_TXSTATUS_FW_DISCARD_NOACK = 4,
+	INFF_FWS_TXSTATUS_FW_SUPPRESS_ACKED = 5,
+	INFF_FWS_TXSTATUS_FW_EXPIRED = 6,
+	INFF_FWS_TXSTATUS_FW_DROPPED = 7,
+	INFF_FWS_TXSTATUS_FW_MKTFREE = 8
+};
+
+enum inff_fws_fcmode {
+	INFF_FWS_FCMODE_NONE,
+	INFF_FWS_FCMODE_IMPLIED_CREDIT,
+	INFF_FWS_FCMODE_EXPLICIT_CREDIT
+};
+
+enum inff_fws_mac_desc_state {
+	INFF_FWS_STATE_OPEN = 1,
+	INFF_FWS_STATE_CLOSE
+};
+
+/**
+ * struct inff_fws_mac_descriptor - firmware signalling data per node/interface
+ *
+ * @name: name of the descriptor.
+ * @occupied: slot is in use.
+ * @mac_handle: handle for mac entry determined by firmware.
+ * @interface_id: interface index.
+ * @state: current state.
+ * @suppressed: mac entry is suppressed.
+ * @generation: generation bit.
+ * @ac_bitmap: ac queue bitmap.
+ * @requested_credit: credits requested by firmware.
+ * @requested_packet: packet requested by firmware.
+ * @ea: ethernet address.
+ * @seq: per-node free-running sequence.
+ * @psq: power-save queue.
+ * @transit_count: packet in transit to firmware.
+ * @suppr_transit_count: suppressed packet in transit to firmware.
+ * @send_tim_signal: if set tim signal will be sent.
+ * @traffic_pending_bmp: traffic pending bitmap.
+ * @traffic_lastreported_bmp: traffic last reported bitmap.
+ */
+struct inff_fws_mac_descriptor {
+	char name[16];
+	u8 occupied;
+	u8 mac_handle;
+	u8 interface_id;
+	u8 state;
+	bool suppressed;
+	u8 generation;
+	u8 ac_bitmap;
+	u8 requested_credit;
+	u8 requested_packet;
+	u8 ea[ETH_ALEN];
+	u8 seq[INFF_FWS_FIFO_COUNT];
+	struct pktq psq;
+	int transit_count;
+	int suppr_transit_count;
+	bool send_tim_signal;
+	u8 traffic_pending_bmp;
+	u8 traffic_lastreported_bmp;
+	struct pktq afq;
+};
+
+#define INFF_FWS_HANGER_MAXITEMS	3072
+#define INFF_BORROW_RATIO			3
+
+/**
+ * enum inff_fws_hanger_item_state - state of hanger item.
+ *
+ * @INFF_FWS_HANGER_ITEM_STATE_FREE: item is free for use.
+ * @INFF_FWS_HANGER_ITEM_STATE_INUSE: item is in use.
+ * @INFF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED: item was suppressed.
+ */
+enum inff_fws_hanger_item_state {
+	INFF_FWS_HANGER_ITEM_STATE_FREE = 1,
+	INFF_FWS_HANGER_ITEM_STATE_INUSE,
+	INFF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED
+};
+
+/**
+ * struct inff_fws_hanger_item - single entry for tx pending packet.
+ *
+ * @state: entry is either free or occupied.
+ * @pkt: packet itself.
+ */
+struct inff_fws_hanger_item {
+	enum inff_fws_hanger_item_state state;
+	struct sk_buff *pkt;
+};
+
+/**
+ * struct inff_fws_hanger - holds packets awaiting firmware txstatus.
+ *
+ * @pushed: packets pushed to await txstatus.
+ * @popped: packets popped upon handling txstatus.
+ * @failed_to_push: packets that could not be pushed.
+ * @failed_to_pop: packets that could not be popped.
+ * @failed_slotfind: packets for which failed to find an entry.
+ * @slot_pos: last returned item index for a free entry.
+ * @items: array of hanger items.
+ */
+struct inff_fws_hanger {
+	u32 pushed;
+	u32 popped;
+	u32 failed_to_push;
+	u32 failed_to_pop;
+	u32 failed_slotfind;
+	u32 slot_pos;
+	struct inff_fws_hanger_item items[INFF_FWS_HANGER_MAXITEMS];
+};
+
+struct inff_fws_macdesc_table {
+	struct inff_fws_mac_descriptor nodes[INFF_FWS_MAC_DESC_TABLE_SIZE];
+	struct inff_fws_mac_descriptor iface[INFF_MAX_IFS];
+	struct inff_fws_mac_descriptor other;
+};
+
+struct inff_ohd_creditmap {
+	u8 num_acs;
+	u8 fifo_credit[INFF_FWS_FIFO_COUNT];
+};
+
+struct inff_fws_stats {
+	u32 tlv_parse_failed;
+	u32 tlv_invalid_type;
+	u32 header_only_pkt;
+	u32 header_pulls;
+	u32 pkt2bus;
+	u32 send_pkts[5];
+	u32 requested_sent[5];
+	u32 generic_error;
+	u32 mac_update_failed;
+	u32 mac_ps_update_failed;
+	u32 if_update_failed;
+	u32 packet_request_failed;
+	u32 credit_request_failed;
+	u32 rollback_success;
+	u32 rollback_failed;
+	u32 delayq_full_error;
+	u32 supprq_full_error;
+	u32 txs_indicate;
+	u32 txs_discard;
+	u32 txs_supp_core;
+	u32 txs_supp_ps;
+	u32 txs_tossed;
+	u32 txs_expired;
+	u32 txs_dropped;
+	u32 txs_mktfree;
+	u32 txs_unknown;
+	u32 txs_host_tossed;
+	u32 bus_flow_block;
+	u32 fws_flow_block;
+	u32 cnt_recv_err;
+	u32 cnt_cleanup_if;
+};
+
+struct inff_fws_info {
+	struct inff_pub *drvr;
+	spinlock_t spinlock;	/* spinlock for fw signal resource protection */
+	ulong flags;
+	struct inff_fws_stats stats;
+	struct inff_fws_hanger hanger;
+	enum inff_fws_fcmode fcmode;
+	bool fw_signals;
+	bool bcmc_credit_check;
+	struct inff_fws_macdesc_table desc;
+	struct workqueue_struct *fws_wq;
+	struct work_struct fws_dequeue_work;
+	u32 fifo_enqpkt[INFF_FWS_FIFO_COUNT];
+	int fifo_credit[INFF_FWS_FIFO_COUNT];
+	int init_fifo_credit[INFF_FWS_FIFO_COUNT];
+	int credits_borrowed[INFF_FWS_FIFO_AC_VO + 1]
+		[INFF_FWS_FIFO_AC_VO + 1];
+	int deq_node_pos[INFF_FWS_FIFO_COUNT];
+	u32 fifo_credit_map;
+	u32 fifo_delay_map;
+	unsigned long borrow_defer_timestamp;
+	bool bus_flow_blocked;
+	bool creditmap_received;
+	bool credit_recover;
+	bool sdio_recv_error;
+	u8 mode;
+	bool avoid_queueing;
+	int fws_psq_len;
+	int fws_psq_hi_water;
+	int fws_psq_low_water;
+	struct work_struct creditmap_query_work;
+	int wlfc_mode;
+};
+
+static int inff_fws_deque_afq(struct inff_fws_info *fws, u16 hslot, u8 hcnt,
+			      u8 prec, struct sk_buff **pktout);
+static int inff_fws_enque_afq(struct inff_fws_info *fws,
+			      struct sk_buff *skb);
+
+/**
+ * inff_fws_get_tlv_len() - returns defined length for given tlv id.
+ *
+ * @fws: firmware-signalling information.
+ * @id: identifier of the TLV.
+ *
+ * Return: the specified length for the given TLV; Otherwise -EINVAL.
+ */
+static int inff_fws_get_tlv_len(struct inff_fws_info *fws,
+				enum inff_fws_tlv_type id)
+{
+	switch (id) {
+	case INFF_FWS_TYPE_MAC_OPEN:
+		return INFF_FWS_TYPE_MAC_OPEN_LEN;
+	case INFF_FWS_TYPE_MAC_CLOSE:
+		return INFF_FWS_TYPE_MAC_CLOSE_LEN;
+	case INFF_FWS_TYPE_MAC_REQUEST_CREDIT:
+		return INFF_FWS_TYPE_MAC_REQUEST_CREDIT_LEN;
+	case INFF_FWS_TYPE_TXSTATUS:
+		return INFF_FWS_TYPE_TXSTATUS_LEN;
+	case INFF_FWS_TYPE_PKTTAG:
+		return INFF_FWS_TYPE_PKTTAG_LEN;
+	case INFF_FWS_TYPE_MACDESC_ADD:
+		return INFF_FWS_TYPE_MACDESC_ADD_LEN;
+	case INFF_FWS_TYPE_MACDESC_DEL:
+		return INFF_FWS_TYPE_MACDESC_DEL_LEN;
+	case INFF_FWS_TYPE_RSSI:
+		return INFF_FWS_TYPE_RSSI_LEN;
+	case INFF_FWS_TYPE_INTERFACE_OPEN:
+		return INFF_FWS_TYPE_INTERFACE_OPEN_LEN;
+	case INFF_FWS_TYPE_INTERFACE_CLOSE:
+		return INFF_FWS_TYPE_INTERFACE_CLOSE_LEN;
+	case INFF_FWS_TYPE_FIFO_CREDITBACK:
+		return INFF_FWS_TYPE_FIFO_CREDITBACK_LEN;
+	case INFF_FWS_TYPE_PENDING_TRAFFIC_BMP:
+		return INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+	case INFF_FWS_TYPE_MAC_REQUEST_PACKET:
+		return INFF_FWS_TYPE_MAC_REQUEST_PACKET_LEN;
+	case INFF_FWS_TYPE_HOST_REORDER_RXPKTS:
+		return INFF_FWS_TYPE_HOST_REORDER_RXPKTS_LEN;
+	case INFF_FWS_TYPE_TRANS_ID:
+		return INFF_FWS_TYPE_TRANS_ID_LEN;
+	case INFF_FWS_TYPE_COMP_TXSTATUS:
+		return INFF_FWS_TYPE_COMP_TXSTATUS_LEN;
+	case INFF_FWS_TYPE_FILLER:
+		return INFF_FWS_TYPE_FILLER_LEN;
+	default:
+		fws->stats.tlv_invalid_type++;
+		break;
+	}
+	return -EINVAL;
+}
+
+static void inff_fws_lock(struct inff_fws_info *fws)
+		__acquires(&fws->spinlock)
+{
+	spin_lock_irqsave(&fws->spinlock, fws->flags);
+}
+
+static void inff_fws_unlock(struct inff_fws_info *fws)
+		__releases(&fws->spinlock)
+{
+	spin_unlock_irqrestore(&fws->spinlock, fws->flags);
+}
+
+static bool inff_fws_ifidx_match(struct sk_buff *skb, void *arg)
+{
+	u32 ifidx = inff_skb_if_flags_get_field(skb, INDEX);
+	return ifidx == *(int *)arg;
+}
+
+static void inff_fws_hanger_init(struct inff_fws_hanger *hanger)
+{
+	int i;
+
+	memset(hanger, 0, sizeof(*hanger));
+	for (i = 0; i < ARRAY_SIZE(hanger->items); i++)
+		hanger->items[i].state = INFF_FWS_HANGER_ITEM_STATE_FREE;
+}
+
+static u32 inff_fws_hanger_get_free_slot(struct inff_fws_hanger *h)
+{
+	u32 i;
+
+	i = (h->slot_pos + 1) % INFF_FWS_HANGER_MAXITEMS;
+
+	while (i != h->slot_pos) {
+		if (h->items[i].state == INFF_FWS_HANGER_ITEM_STATE_FREE) {
+			h->slot_pos = i;
+			goto done;
+		}
+		i++;
+		if (i == INFF_FWS_HANGER_MAXITEMS)
+			i = 0;
+	}
+	inff_err("all slots occupied\n");
+	h->failed_slotfind++;
+	i = INFF_FWS_HANGER_MAXITEMS;
+done:
+	return i;
+}
+
+static int inff_fws_hanger_pushpkt(struct inff_fws_hanger *h,
+				   struct sk_buff *pkt, u32 slot_id)
+{
+	if (slot_id >= INFF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (h->items[slot_id].state != INFF_FWS_HANGER_ITEM_STATE_FREE) {
+		inff_err("slot is not free\n");
+		h->failed_to_push++;
+		return -EINVAL;
+	}
+
+	h->items[slot_id].state = INFF_FWS_HANGER_ITEM_STATE_INUSE;
+	h->items[slot_id].pkt = pkt;
+	h->pushed++;
+	return 0;
+}
+
+static inline int inff_fws_hanger_poppkt(struct inff_fws_hanger *h,
+					 u32 slot_id, struct sk_buff **pktout,
+					 bool remove_item)
+{
+	if (slot_id >= INFF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (h->items[slot_id].state == INFF_FWS_HANGER_ITEM_STATE_FREE) {
+		inff_err("entry not in use\n");
+		h->failed_to_pop++;
+		return -EINVAL;
+	}
+
+	*pktout = h->items[slot_id].pkt;
+	if (remove_item) {
+		h->items[slot_id].state = INFF_FWS_HANGER_ITEM_STATE_FREE;
+		h->items[slot_id].pkt = NULL;
+		h->popped++;
+	}
+	return 0;
+}
+
+static void
+inff_fws_flow_control_check(struct inff_fws_info *fws, struct pktq *pq,
+			    u8 if_id)
+{
+	struct inff_if *ifp = inff_get_ifp(fws->drvr, if_id);
+
+	if (WARN_ON(!ifp))
+		return;
+
+	if ((ifp->netif_stop & INFF_NETIF_STOP_REASON_FWS_FC) &&
+	    pq->len <= fws->fws_psq_low_water)
+		inff_net_txflowblock(ifp, INFF_NETIF_STOP_REASON_FWS_FC,
+				     false);
+	if (!(ifp->netif_stop & INFF_NETIF_STOP_REASON_FWS_FC) &&
+	    pq->len >= fws->fws_psq_hi_water) {
+		fws->stats.fws_flow_block++;
+		inff_net_txflowblock(ifp, INFF_NETIF_STOP_REASON_FWS_FC,
+				     true);
+	}
+}
+
+static void inff_fws_psq_flush(struct inff_fws_info *fws, struct pktq *q,
+			       int ifidx)
+{
+	struct inff_fws_hanger_item *hi;
+	bool (*matchfn)(struct sk_buff *, void *) = NULL;
+	struct sk_buff *skb;
+	int prec;
+	u32 hslot;
+	int skbidx;
+
+	if (ifidx != -1)
+		matchfn = inff_fws_ifidx_match;
+	for (prec = 0; prec < q->num_prec; prec++) {
+		skb = inff_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		while (skb) {
+			hslot = inff_skb_htod_tag_get_field(skb, HSLOT);
+			if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode)) {
+				hi = &fws->hanger.items[hslot];
+				WARN_ON(skb != hi->pkt);
+				hi->state = INFF_FWS_HANGER_ITEM_STATE_FREE;
+				inff_fws_hanger_poppkt(&fws->hanger, hslot,
+						       &skb, true);
+			}
+			skbidx = inff_skb_if_flags_get_field(skb, INDEX);
+			inff_fws_flow_control_check(fws, q, skbidx);
+			inff_pkt_buf_free_skb(skb);
+			skb = inff_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		}
+	}
+}
+
+static int inff_fws_hanger_mark_suppressed(struct inff_fws_hanger *h,
+					   u32 slot_id)
+{
+	if (slot_id >= INFF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (h->items[slot_id].state == INFF_FWS_HANGER_ITEM_STATE_FREE) {
+		inff_err("entry not in use\n");
+		return -EINVAL;
+	}
+
+	h->items[slot_id].state = INFF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED;
+	return 0;
+}
+
+static void inff_fws_hanger_cleanup(struct inff_fws_info *fws,
+				    bool (*fn)(struct sk_buff *, void *),
+				     int ifidx)
+{
+	struct inff_fws_hanger *h = &fws->hanger;
+	struct sk_buff *skb;
+	int i;
+	enum inff_fws_hanger_item_state s;
+
+	for (i = 0; i < ARRAY_SIZE(h->items); i++) {
+		s = h->items[i].state;
+		if (s == INFF_FWS_HANGER_ITEM_STATE_INUSE ||
+		    s == INFF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
+			skb = h->items[i].pkt;
+			if (!fn || fn(skb, &ifidx)) {
+				/* suppress packets freed from psq */
+				if (s == INFF_FWS_HANGER_ITEM_STATE_INUSE)
+					inff_pkt_buf_free_skb(skb);
+				h->items[i].state =
+					INFF_FWS_HANGER_ITEM_STATE_FREE;
+			}
+		}
+	}
+}
+
+static void inff_fws_macdesc_set_name(struct inff_fws_info *fws,
+				      struct inff_fws_mac_descriptor *desc)
+{
+	if (desc == &fws->desc.other)
+		strscpy(desc->name, "MAC-OTHER", sizeof(desc->name));
+	else if (desc->mac_handle)
+		scnprintf(desc->name, sizeof(desc->name), "MAC-%d:%d",
+			  desc->mac_handle, desc->interface_id);
+	else
+		scnprintf(desc->name, sizeof(desc->name), "MACIF:%d",
+			  desc->interface_id);
+}
+
+static void inff_fws_macdesc_init(struct inff_fws_mac_descriptor *desc,
+				  u8 *addr, u8 ifidx)
+{
+	inff_dbg(TRACE,
+		 "desc %p ea=%pM, ifidx=%u\n", desc, addr, ifidx);
+	desc->occupied = 1;
+	desc->state = INFF_FWS_STATE_OPEN;
+	desc->requested_credit = 0;
+	desc->requested_packet = 0;
+	/* depending on use may need ifp->bsscfgidx instead */
+	desc->interface_id = ifidx;
+	desc->ac_bitmap = 0xff; /* update this when handling APSD */
+	if (addr)
+		memcpy(&desc->ea[0], addr, ETH_ALEN);
+}
+
+static void inff_fws_macdesc_reset(struct inff_fws_mac_descriptor *entry)
+{
+	int i;
+
+	inff_fws_macdesc_init(entry, entry->ea, entry->interface_id);
+	entry->mac_handle = 0;
+	entry->suppressed = 0;
+	entry->transit_count = 0;
+	entry->suppr_transit_count = 0;
+	entry->generation = 0;
+
+	for (i = 0; i < INFF_FWS_FIFO_COUNT; i++)
+		entry->seq[i] = 0;
+
+	entry->send_tim_signal = 0;
+	entry->traffic_pending_bmp = 0;
+	entry->traffic_lastreported_bmp = 0;
+}
+
+static
+void inff_fws_macdesc_deinit(struct inff_fws_mac_descriptor *desc)
+{
+	inff_dbg(TRACE,
+		 "ea=%pM, ifidx=%u\n", desc->ea, desc->interface_id);
+	desc->occupied = 0;
+	desc->state = INFF_FWS_STATE_CLOSE;
+	desc->requested_credit = 0;
+	desc->requested_packet = 0;
+}
+
+static struct inff_fws_mac_descriptor *
+inff_fws_macdesc_lookup(struct inff_fws_info *fws, u8 *ea)
+{
+	struct inff_fws_mac_descriptor *entry;
+	int i;
+
+	if (!ea)
+		return ERR_PTR(-EINVAL);
+
+	entry = &fws->desc.nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++) {
+		if (entry->occupied && !memcmp(entry->ea, ea, ETH_ALEN))
+			return entry;
+		entry++;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
+static struct inff_fws_mac_descriptor*
+inff_fws_macdesc_find(struct inff_fws_info *fws, struct inff_if *ifp, u8 *da)
+{
+	struct inff_fws_mac_descriptor *entry;
+	bool multicast;
+
+	multicast = is_multicast_ether_addr(da);
+
+	/* Multicast destination, STA clients get the interface entry */
+	if (multicast && ifp->fws_desc) {
+		entry = ifp->fws_desc;
+		goto done;
+	}
+
+	entry = inff_fws_macdesc_lookup(fws, da);
+	if (IS_ERR(entry))
+		entry = ifp->fws_desc;
+
+done:
+	return entry;
+}
+
+static bool inff_fws_macdesc_closed(struct inff_fws_info *fws,
+				    struct inff_fws_mac_descriptor *entry,
+				     int fifo)
+{
+	struct inff_fws_mac_descriptor *if_entry;
+	bool closed;
+
+	/* for unique destination entries the related interface
+	 * may be closed.
+	 */
+	if (entry->mac_handle) {
+		if_entry = &fws->desc.iface[entry->interface_id];
+		if (if_entry->state == INFF_FWS_STATE_CLOSE)
+			return true;
+	}
+	/* an entry is closed when the state is closed and
+	 * the firmware did not request anything.
+	 */
+	closed = entry->state == INFF_FWS_STATE_CLOSE &&
+		 !entry->requested_credit && !entry->requested_packet;
+
+	/* Or firmware does not allow traffic for given fifo */
+	return closed || !(entry->ac_bitmap & BIT(fifo));
+}
+
+static void inff_fws_macdesc_cleanup(struct inff_fws_info *fws,
+				     struct inff_fws_mac_descriptor *entry,
+				      int ifidx)
+{
+	if (entry->occupied && (ifidx == -1 || ifidx == entry->interface_id)) {
+		inff_fws_psq_flush(fws, &entry->psq, ifidx);
+		if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+			inff_pktq_flush(&entry->afq, true, NULL, NULL);
+		entry->occupied = !!(entry->psq.len);
+	}
+}
+
+static void inff_fws_bus_txq_cleanup(struct inff_fws_info *fws,
+				     bool (*fn)(struct sk_buff *, void *),
+				     int ifidx)
+{
+	struct inff_fws_hanger_item *hi;
+	struct pktq *txq;
+	struct sk_buff *skb;
+	int prec;
+	u32 hslot;
+
+	txq = inff_bus_gettxq(fws->drvr->bus_if);
+	if (IS_ERR(txq)) {
+		inff_dbg(TRACE, "no txq to clean up\n");
+		return;
+	}
+
+	for (prec = 0; prec < txq->num_prec; prec++) {
+		skb = inff_pktq_pdeq_match(txq, prec, fn, &ifidx);
+		while (skb) {
+			if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode)) {
+				hslot = inff_skb_htod_tag_get_field(skb, HSLOT);
+				hi = &fws->hanger.items[hslot];
+				WARN_ON(skb != hi->pkt);
+				hi->state = INFF_FWS_HANGER_ITEM_STATE_FREE;
+			}
+			inff_pkt_buf_free_skb(skb);
+			skb = inff_pktq_pdeq_match(txq, prec, fn, &ifidx);
+		}
+	}
+}
+
+static void inff_fws_cleanup(struct inff_fws_info *fws, int ifidx)
+{
+	int i;
+	struct inff_fws_mac_descriptor *table;
+	bool (*matchfn)(struct sk_buff *, void *) = NULL;
+
+	if (!fws)
+		return;
+
+	if (ifidx != -1)
+		matchfn = inff_fws_ifidx_match;
+
+	/* cleanup individual nodes */
+	table = &fws->desc.nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++)
+		inff_fws_macdesc_cleanup(fws, &table[i], ifidx);
+
+	inff_fws_macdesc_cleanup(fws, &fws->desc.other, ifidx);
+	inff_fws_bus_txq_cleanup(fws, matchfn, ifidx);
+	if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_fws_hanger_cleanup(fws, matchfn, ifidx);
+}
+
+static u8 inff_fws_hdrpush(struct inff_fws_info *fws, struct sk_buff *skb)
+{
+	struct inff_fws_mac_descriptor *entry = inff_skbcb(skb)->mac;
+	u8 *wlh;
+	u16 data_offset = 0;
+	u8 fillers;
+	__le32 pkttag = cpu_to_le32(inff_skbcb(skb)->htod);
+	__le16 pktseq = cpu_to_le16(inff_skbcb(skb)->htod_seq);
+
+	inff_dbg(TRACE, "%s, idx=%d hslot=%d htod %X seq %X\n",
+		 entry->name, inff_skb_if_flags_get_field(skb, INDEX),
+		 (le32_to_cpu(pkttag) >> 8) & 0xffff,
+		 inff_skbcb(skb)->htod, inff_skbcb(skb)->htod_seq);
+	if (entry->send_tim_signal)
+		data_offset += 2 + INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+	if (INFF_FWS_MODE_GET_REUSESEQ(fws->mode))
+		data_offset += INFF_FWS_TYPE_SEQ_LEN;
+	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
+	data_offset += 2 + INFF_FWS_TYPE_PKTTAG_LEN;
+	fillers = round_up(data_offset, 4) - data_offset;
+	data_offset += fillers;
+
+	skb_push(skb, data_offset);
+	wlh = skb->data;
+
+	wlh[0] = INFF_FWS_TYPE_PKTTAG;
+	wlh[1] = INFF_FWS_TYPE_PKTTAG_LEN;
+	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
+	if (INFF_FWS_MODE_GET_REUSESEQ(fws->mode)) {
+		wlh[1] += INFF_FWS_TYPE_SEQ_LEN;
+		memcpy(&wlh[2 + INFF_FWS_TYPE_PKTTAG_LEN], &pktseq,
+		       sizeof(pktseq));
+	}
+	wlh += wlh[1] + 2;
+
+	if (entry->send_tim_signal) {
+		entry->send_tim_signal = false;
+		wlh[0] = INFF_FWS_TYPE_PENDING_TRAFFIC_BMP;
+		wlh[1] = INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
+		wlh[2] = entry->mac_handle;
+		wlh[3] = entry->traffic_pending_bmp;
+		inff_dbg(TRACE, "adding TIM info: handle %d bmp 0x%X\n",
+			 entry->mac_handle, entry->traffic_pending_bmp);
+		wlh += INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2;
+		entry->traffic_lastreported_bmp = entry->traffic_pending_bmp;
+	}
+	if (fillers)
+		memset(wlh, INFF_FWS_TYPE_FILLER, fillers);
+
+	return (u8)(data_offset >> 2);
+}
+
+static bool inff_fws_tim_update(struct inff_fws_info *fws,
+				struct inff_fws_mac_descriptor *entry,
+				 int fifo, bool send_immediately)
+{
+	struct sk_buff *skb;
+	struct inff_skbuff_cb *skcb;
+	s32 err;
+	u32 len;
+	u8 data_offset;
+	int ifidx;
+
+	/* check delayedQ and suppressQ in one call using bitmap */
+	if (inff_pktq_mlen(&entry->psq, 3 << (fifo * 2)) == 0)
+		entry->traffic_pending_bmp &= ~NBITVAL(fifo);
+	else
+		entry->traffic_pending_bmp |= NBITVAL(fifo);
+
+	entry->send_tim_signal = false;
+	if (entry->traffic_lastreported_bmp != entry->traffic_pending_bmp)
+		entry->send_tim_signal = true;
+	if (send_immediately && entry->send_tim_signal &&
+	    entry->state == INFF_FWS_STATE_CLOSE) {
+		/* create a dummy packet and sent that. The traffic          */
+		/* bitmap info will automatically be attached to that packet */
+		len = INFF_FWS_TYPE_PKTTAG_LEN + 2 +
+		      INFF_FWS_TYPE_SEQ_LEN +
+		      INFF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2 +
+		      4 + fws->drvr->hdrlen;
+		skb = inff_pkt_buf_get_skb(len);
+		if (!skb)
+			return false;
+		skb_pull(skb, len);
+		skcb = inff_skbcb(skb);
+		skcb->mac = entry;
+		skcb->state = INFF_FWS_SKBSTATE_TIM;
+		skcb->htod = 0;
+		skcb->htod_seq = 0;
+		data_offset = inff_fws_hdrpush(fws, skb);
+		ifidx = inff_skb_if_flags_get_field(skb, INDEX);
+		inff_fws_unlock(fws);
+		err = inff_proto_txdata(fws->drvr, ifidx, data_offset, skb);
+		inff_fws_lock(fws);
+		if (err)
+			inff_pkt_buf_free_skb(skb);
+		return true;
+	}
+	return false;
+}
+
+static int inff_fws_rssi_indicate(struct inff_fws_info *fws, s8 rssi)
+{
+	inff_dbg(CTL, "rssi %d\n", rssi);
+	return 0;
+}
+
+static
+int inff_fws_macdesc_indicate(struct inff_fws_info *fws, u8 type, u8 *data)
+{
+	struct inff_fws_mac_descriptor *entry, *existing;
+	u8 mac_handle;
+	u8 ifidx;
+	u8 *addr;
+
+	mac_handle = *data++;
+	ifidx = *data++;
+	addr = data;
+
+	entry = &fws->desc.nodes[mac_handle & 0x1F];
+	if (type == INFF_FWS_TYPE_MACDESC_DEL) {
+		if (entry->occupied) {
+			inff_dbg(TRACE, "deleting %s mac %pM\n",
+				 entry->name, addr);
+			inff_fws_lock(fws);
+			inff_fws_macdesc_cleanup(fws, entry, -1);
+			inff_fws_macdesc_deinit(entry);
+			inff_fws_unlock(fws);
+		} else {
+			fws->stats.mac_update_failed++;
+		}
+		return 0;
+	}
+
+	existing = inff_fws_macdesc_lookup(fws, addr);
+	if (IS_ERR(existing)) {
+		if (!entry->occupied) {
+			inff_fws_lock(fws);
+			entry->mac_handle = mac_handle;
+			inff_fws_macdesc_init(entry, addr, ifidx);
+			inff_fws_macdesc_set_name(fws, entry);
+			inff_pktq_init(&entry->psq,
+				       INFF_FWS_PSQ_PREC_COUNT,
+				       fws->fws_psq_len);
+			if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+				inff_pktq_init(&entry->afq,
+					       INFF_FWS_AFQ_PREC_COUNT,
+					       INFF_FWS_AFQ_LEN);
+			inff_fws_unlock(fws);
+			inff_dbg(TRACE, "add %s mac %pM\n", entry->name, addr);
+		} else {
+			fws->stats.mac_update_failed++;
+		}
+	} else {
+		if (entry != existing) {
+			inff_dbg(TRACE, "copy mac %s\n", existing->name);
+			inff_fws_lock(fws);
+			memcpy(entry, existing,
+			       offsetof(struct inff_fws_mac_descriptor, psq));
+			entry->mac_handle = mac_handle;
+			inff_fws_macdesc_deinit(existing);
+			inff_fws_macdesc_set_name(fws, entry);
+			inff_fws_unlock(fws);
+			inff_dbg(TRACE, "relocate %s mac %pM\n", entry->name,
+				 addr);
+		} else {
+			inff_dbg(TRACE, "use existing\n");
+			WARN_ON(entry->mac_handle != mac_handle);
+		}
+	}
+	return 0;
+}
+
+static int inff_fws_macdesc_state_indicate(struct inff_fws_info *fws,
+					   u8 type, u8 *data)
+{
+	struct inff_fws_mac_descriptor *entry;
+	u8 mac_handle;
+	int ret;
+
+	mac_handle = data[0];
+	entry = &fws->desc.nodes[mac_handle & 0x1F];
+	if (!entry->occupied) {
+		fws->stats.mac_ps_update_failed++;
+		return -ESRCH;
+	}
+	inff_fws_lock(fws);
+	/* a state update should wipe old credits */
+	entry->requested_credit = 0;
+	entry->requested_packet = 0;
+	if (type == INFF_FWS_TYPE_MAC_OPEN) {
+		entry->state = INFF_FWS_STATE_OPEN;
+		ret = INFF_FWS_RET_OK_SCHEDULE;
+	} else {
+		entry->state = INFF_FWS_STATE_CLOSE;
+		inff_fws_tim_update(fws, entry, INFF_FWS_FIFO_AC_BK, false);
+		inff_fws_tim_update(fws, entry, INFF_FWS_FIFO_AC_BE, false);
+		inff_fws_tim_update(fws, entry, INFF_FWS_FIFO_AC_VI, false);
+		inff_fws_tim_update(fws, entry, INFF_FWS_FIFO_AC_VO, true);
+		ret = INFF_FWS_RET_OK_NOSCHEDULE;
+	}
+	inff_fws_unlock(fws);
+	return ret;
+}
+
+static int inff_fws_interface_state_indicate(struct inff_fws_info *fws,
+					     u8 type, u8 *data)
+{
+	struct inff_fws_mac_descriptor *entry;
+	u8 ifidx;
+	int ret;
+
+	ifidx = data[0];
+
+	if (ifidx >= INFF_MAX_IFS) {
+		ret = -ERANGE;
+		goto fail;
+	}
+
+	entry = &fws->desc.iface[ifidx];
+	if (!entry->occupied) {
+		ret = -ESRCH;
+		goto fail;
+	}
+
+	inff_dbg(TRACE, "%s (%d): %s\n", inff_fws_get_tlv_name(type), type,
+		 entry->name);
+	inff_fws_lock(fws);
+	switch (type) {
+	case INFF_FWS_TYPE_INTERFACE_OPEN:
+		entry->state = INFF_FWS_STATE_OPEN;
+		ret = INFF_FWS_RET_OK_SCHEDULE;
+		break;
+	case INFF_FWS_TYPE_INTERFACE_CLOSE:
+		entry->state = INFF_FWS_STATE_CLOSE;
+		ret = INFF_FWS_RET_OK_NOSCHEDULE;
+		break;
+	default:
+		ret = -EINVAL;
+		inff_fws_unlock(fws);
+		goto fail;
+	}
+	inff_fws_unlock(fws);
+	return ret;
+
+fail:
+	fws->stats.if_update_failed++;
+	return ret;
+}
+
+static int inff_fws_request_indicate(struct inff_fws_info *fws, u8 type,
+				     u8 *data)
+{
+	struct inff_fws_mac_descriptor *entry;
+
+	entry = &fws->desc.nodes[data[1] & 0x1F];
+	if (!entry->occupied) {
+		if (type == INFF_FWS_TYPE_MAC_REQUEST_CREDIT)
+			fws->stats.credit_request_failed++;
+		else
+			fws->stats.packet_request_failed++;
+		return -ESRCH;
+	}
+
+	inff_dbg(TRACE, "%s (%d): %s cnt %d bmp %d\n",
+		 inff_fws_get_tlv_name(type), type, entry->name,
+		  data[0], data[2]);
+	inff_fws_lock(fws);
+	if (type == INFF_FWS_TYPE_MAC_REQUEST_CREDIT)
+		entry->requested_credit = data[0];
+	else
+		entry->requested_packet = data[0];
+
+	entry->ac_bitmap = data[2];
+	inff_fws_unlock(fws);
+	return INFF_FWS_RET_OK_SCHEDULE;
+}
+
+static void
+inff_fws_macdesc_use_req_credit(struct inff_fws_mac_descriptor *entry,
+				struct sk_buff *skb)
+{
+	if (entry->requested_credit > 0) {
+		entry->requested_credit--;
+		inff_skb_if_flags_set_field(skb, REQUESTED, 1);
+		inff_skb_if_flags_set_field(skb, REQ_CREDIT, 1);
+		if (entry->state != INFF_FWS_STATE_CLOSE)
+			inff_err("requested credit set while mac not closed!\n");
+	} else if (entry->requested_packet > 0) {
+		entry->requested_packet--;
+		inff_skb_if_flags_set_field(skb, REQUESTED, 1);
+		inff_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
+		if (entry->state != INFF_FWS_STATE_CLOSE)
+			inff_err("requested packet set while mac not closed!\n");
+	} else {
+		inff_skb_if_flags_set_field(skb, REQUESTED, 0);
+		inff_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
+	}
+}
+
+static void inff_fws_macdesc_return_req_credit(struct sk_buff *skb)
+{
+	struct inff_fws_mac_descriptor *entry = inff_skbcb(skb)->mac;
+
+	if ((inff_skb_if_flags_get_field(skb, REQ_CREDIT)) &&
+	    entry->state == INFF_FWS_STATE_CLOSE)
+		entry->requested_credit++;
+}
+
+static void inff_fws_return_credits(struct inff_fws_info *fws,
+				    u8 fifo, u8 credits)
+{
+	int lender_ac;
+	int *borrowed;
+	int *fifo_credit;
+
+	if (!credits)
+		return;
+
+	fws->fifo_credit_map |= 1 << fifo;
+
+	if (fifo >= INFF_FWS_FIFO_AC_BK &&
+	    fifo <= INFF_FWS_FIFO_AC_VO)
+		for (lender_ac = INFF_FWS_FIFO_AC_VO; lender_ac >= 0;
+		     lender_ac--) {
+			borrowed = &fws->credits_borrowed[fifo][lender_ac];
+			if (*borrowed) {
+				fws->fifo_credit_map |= (1 << lender_ac);
+				fifo_credit = &fws->fifo_credit[lender_ac];
+				if (*borrowed >= credits) {
+					*borrowed -= credits;
+					*fifo_credit += credits;
+					return;
+				}
+
+				credits -= *borrowed;
+				*fifo_credit += *borrowed;
+				*borrowed = 0;
+			}
+		}
+
+	if (credits)
+		fws->fifo_credit[fifo] += credits;
+
+	if (fws->fifo_credit[fifo] > fws->init_fifo_credit[fifo])
+		fws->fifo_credit[fifo] = fws->init_fifo_credit[fifo];
+}
+
+static void inff_fws_schedule_deq(struct inff_fws_info *fws)
+{
+	/* only schedule dequeue when there are credits for delayed traffic */
+	if ((fws->fifo_credit_map & fws->fifo_delay_map) ||
+	    (!inff_fws_fc_active(fws) && fws->fifo_delay_map))
+		queue_work(fws->fws_wq, &fws->fws_dequeue_work);
+}
+
+static int inff_fws_enq(struct inff_fws_info *fws,
+			enum inff_fws_skb_state state, int fifo,
+			 struct sk_buff *p)
+{
+	struct inff_pub *drvr = fws->drvr;
+	int prec = 2 * fifo;
+	u32 *qfull_stat = &fws->stats.delayq_full_error;
+	struct inff_fws_mac_descriptor *entry;
+	struct pktq *pq;
+	struct sk_buff_head *queue;
+	struct sk_buff *p_head;
+	struct sk_buff *p_tail;
+	u32 fr_new;
+	u32 fr_compare;
+
+	entry = inff_skbcb(p)->mac;
+	if (!entry) {
+		iphy_err(drvr, "no mac descriptor found for skb %p\n", p);
+		return -ENOENT;
+	}
+
+	inff_dbg(DATA, "fifo %d skb %p\n", fifo, p);
+	if (state == INFF_FWS_SKBSTATE_SUPPRESSED) {
+		prec += 1;
+		qfull_stat = &fws->stats.supprq_full_error;
+
+		/* Fix out of order delivery of frames. Dont assume frame    */
+		/* can be inserted at the end, but look for correct position */
+		pq = &entry->psq;
+		if (pktq_full(pq) || pktq_pfull(pq, prec)) {
+			*qfull_stat += 1;
+			return -ENFILE;
+		}
+		queue = &pq->q[prec].skblist;
+
+		p_head = skb_peek(queue);
+		p_tail = skb_peek_tail(queue);
+		fr_new = inff_skb_htod_tag_get_field(p, FREERUN);
+
+		while (p_head != p_tail) {
+			fr_compare = inff_skb_htod_tag_get_field(p_tail,
+								 FREERUN);
+			/* be sure to handle wrap of 256 */
+			if ((fr_new > fr_compare &&
+			     ((fr_new - fr_compare) < 128)) ||
+			    (fr_new < fr_compare &&
+			     ((fr_compare - fr_new) > 128)))
+				break;
+			p_tail = skb_queue_prev(queue, p_tail);
+		}
+		/* Position found. Determine what to do */
+		if (!p_tail) {
+			/* empty list */
+			__skb_queue_tail(queue, p);
+		} else {
+			fr_compare = inff_skb_htod_tag_get_field(p_tail,
+								 FREERUN);
+			if ((fr_new > fr_compare &&
+			     ((fr_new - fr_compare) < 128)) ||
+			    (fr_new < fr_compare &&
+			     ((fr_compare - fr_new) > 128))) {
+				/* After tail */
+				__skb_queue_after(queue, p_tail, p);
+			} else {
+				/* Before tail */
+				__skb_insert(p, p_tail->prev, p_tail, queue);
+			}
+		}
+
+		/* Complete the counters and statistics */
+		pq->len++;
+		if (pq->hi_prec < prec)
+			pq->hi_prec = (u8)prec;
+	} else if (!inff_pktq_penq(&entry->psq, prec, p)) {
+		*qfull_stat += 1;
+		return -ENFILE;
+	}
+
+	/* increment total enqueued packet count */
+	fws->fifo_delay_map |= 1 << fifo;
+	fws->fifo_enqpkt[fifo]++;
+
+	/* update the sk_buff state */
+	inff_skbcb(p)->state = state;
+
+	/*
+	 * A packet has been pushed so update traffic
+	 * availability bitmap, if applicable
+	 */
+	inff_fws_tim_update(fws, entry, fifo, true);
+	inff_fws_flow_control_check(fws, &entry->psq,
+				    inff_skb_if_flags_get_field(p, INDEX));
+	return 0;
+}
+
+static struct sk_buff *inff_fws_deq(struct inff_fws_info *fws, int fifo)
+{
+	struct inff_fws_mac_descriptor *table;
+	struct inff_fws_mac_descriptor *entry;
+	struct sk_buff *p;
+	int num_nodes;
+	int node_pos;
+	int prec_out;
+	int pmsk;
+	int i;
+
+	table = (struct inff_fws_mac_descriptor *)&fws->desc;
+	num_nodes = sizeof(fws->desc) / sizeof(struct inff_fws_mac_descriptor);
+	node_pos = fws->deq_node_pos[fifo];
+
+	for (i = 0; i < num_nodes; i++) {
+		entry = &table[(node_pos + i) % num_nodes];
+		if (!entry->occupied ||
+		    inff_fws_macdesc_closed(fws, entry, fifo))
+			continue;
+
+		if (entry->suppressed)
+			pmsk = 2;
+		else
+			pmsk = 3;
+		p = inff_pktq_mdeq(&entry->psq, pmsk << (fifo * 2), &prec_out);
+		if (!p) {
+			if (entry->suppressed) {
+				if (entry->suppr_transit_count)
+					continue;
+				entry->suppressed = false;
+				p = inff_pktq_mdeq(&entry->psq,
+						   1 << (fifo * 2), &prec_out);
+			}
+		}
+		if  (!p)
+			continue;
+
+		inff_fws_macdesc_use_req_credit(entry, p);
+
+		/* move dequeue position to ensure fair round-robin */
+		fws->deq_node_pos[fifo] = (node_pos + i + 1) % num_nodes;
+		inff_fws_flow_control_check(fws, &entry->psq,
+					    inff_skb_if_flags_get_field(p,
+									INDEX));
+		/*
+		 * A packet has been picked up, update traffic
+		 * availability bitmap, if applicable
+		 */
+		inff_fws_tim_update(fws, entry, fifo, false);
+
+		/*
+		 * decrement total enqueued fifo packets and
+		 * clear delay bitmap if done.
+		 */
+		fws->fifo_enqpkt[fifo]--;
+		if (fws->fifo_enqpkt[fifo] == 0)
+			fws->fifo_delay_map &= ~(1 << fifo);
+		goto done;
+	}
+	p = NULL;
+done:
+	inff_dbg(DATA, "fifo %d skb %p\n", fifo, p);
+	return p;
+}
+
+static int inff_fws_txstatus_suppressed(struct inff_fws_info *fws, int fifo,
+					struct sk_buff *skb,
+					u32 genbit, u16 seq)
+{
+	struct inff_fws_mac_descriptor *entry = inff_skbcb(skb)->mac;
+	u32 hslot;
+	int ret;
+
+	hslot = inff_skb_htod_tag_get_field(skb, HSLOT);
+
+	/* this packet was suppressed */
+	if (!entry->suppressed) {
+		entry->suppressed = true;
+		entry->suppr_transit_count = entry->transit_count;
+		inff_dbg(DATA, "suppress %s: transit %d\n",
+			 entry->name, entry->transit_count);
+	}
+
+	entry->generation = genbit;
+
+	inff_skb_htod_tag_set_field(skb, GENERATION, genbit);
+	inff_skbcb(skb)->htod_seq = seq;
+	if (inff_skb_htod_seq_get_field(skb, FROMFW)) {
+		inff_skb_htod_seq_set_field(skb, FROMDRV, 1);
+		inff_skb_htod_seq_set_field(skb, FROMFW, 0);
+	} else {
+		inff_skb_htod_seq_set_field(skb, FROMDRV, 0);
+	}
+	ret = inff_fws_enq(fws, INFF_FWS_SKBSTATE_SUPPRESSED, fifo, skb);
+
+	if (ret != 0) {
+		/* suppress q is full drop this packet */
+		if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+			inff_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+					       true);
+	} else {
+		/* Mark suppressed to avoid a double free during wlfc cleanup */
+		if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+			inff_fws_hanger_mark_suppressed(&fws->hanger, hslot);
+	}
+
+	return ret;
+}
+
+static int
+inff_fws_txs_process(struct inff_fws_info *fws, u8 flags, u32 hslot,
+		     u32 genbit, u16 seq, u8 compcnt, u8 hcnt, u8 fifo_id)
+{
+	struct inff_pub *drvr = fws->drvr;
+	u32 fifo;
+	u8 cnt = 0;
+	int ret = 0;
+	bool remove_from_hanger = true;
+	struct sk_buff *skb = NULL;
+	struct inff_skbuff_cb *skcb;
+	struct inff_fws_mac_descriptor *entry = NULL;
+	struct inff_if *ifp;
+
+	inff_dbg(DATA, "flags %d\n", flags);
+
+	if (flags == INFF_FWS_TXSTATUS_DISCARD) {
+		fws->stats.txs_discard += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_CORE_SUPPRESS) {
+		fws->stats.txs_supp_core += compcnt;
+		remove_from_hanger = false;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_PS_SUPPRESS) {
+		fws->stats.txs_supp_ps += compcnt;
+		remove_from_hanger = false;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_TOSSED) {
+		fws->stats.txs_tossed += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_DISCARD_NOACK) {
+		fws->stats.txs_discard += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_SUPPRESS_ACKED) {
+		fws->stats.txs_discard += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_EXPIRED) {
+		fws->stats.txs_expired += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_DROPPED) {
+		fws->stats.txs_dropped += compcnt;
+	} else if (flags == INFF_FWS_TXSTATUS_FW_MKTFREE) {
+		fws->stats.txs_mktfree += compcnt;
+	} else {
+		fws->stats.txs_unknown += compcnt;
+		iphy_err(drvr, "unexpected txstatus %u\n", flags);
+	}
+
+	while (cnt < compcnt) {
+		if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode)) {
+			ret = inff_fws_deque_afq(fws, hslot, hcnt,
+						 fifo_id, &skb);
+		} else {
+			ret = inff_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+						     remove_from_hanger);
+		}
+		if (ret != 0 || !skb) {
+			iphy_err(drvr, "no packet in hanger slot: hslot=%d\n",
+				 hslot);
+			goto cont;
+		}
+
+		skcb = inff_skbcb(skb);
+		entry = skcb->mac;
+		if (WARN_ON(!entry)) {
+			inff_pkt_buf_free_skb(skb);
+			goto cont;
+		}
+		entry->transit_count--;
+		if (entry->suppressed && entry->suppr_transit_count)
+			entry->suppr_transit_count--;
+
+		inff_dbg(DATA, "%s flags %d htod %X seq %X\n", entry->name,
+			 flags, skcb->htod, seq);
+
+		/* pick up the implicit credit from this packet */
+		fifo = inff_skb_htod_tag_get_field(skb, FIFO);
+		if (fws->fcmode == INFF_FWS_FCMODE_IMPLIED_CREDIT ||
+		    inff_skb_if_flags_get_field(skb, REQ_CREDIT)) {
+			inff_fws_return_credits(fws, fifo, 1);
+			inff_fws_schedule_deq(fws);
+		}
+		inff_fws_macdesc_return_req_credit(skb);
+
+		ret = inff_proto_hdrpull(fws->drvr, false, skb, &ifp);
+		if (ret) {
+			inff_pkt_buf_free_skb(skb);
+			goto cont;
+		}
+		if (!remove_from_hanger)
+			ret = inff_fws_txstatus_suppressed(fws, fifo, skb,
+							   genbit, seq);
+		if (remove_from_hanger || ret)
+			inff_txfinalize(ifp, skb, true);
+
+cont:
+		hcnt = (hcnt + 1) & INFF_FWS_TXSTAT_FREERUN_MASK;
+		if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+			hslot = (hslot + 1) & (INFF_FWS_TXSTAT_HSLOT_MASK >>
+					       INFF_FWS_TXSTAT_HSLOT_SHIFT);
+		if (INFF_FWS_MODE_GET_REUSESEQ(fws->mode))
+			seq = (seq + 1) & INFF_SKB_HTOD_SEQ_NR_MASK;
+
+		cnt++;
+	}
+
+	return 0;
+}
+
+static void inff_fws_txs_process_host_tossed(struct inff_fws_info *fws,
+					     struct sk_buff *skb,
+					     bool header_pulled,
+					     bool in_transit)
+{
+	struct inff_pub *drvr = fws->drvr;
+	struct inff_fws_mac_descriptor *entry;
+	struct inff_if *ifp = NULL;
+	struct sk_buff *pktout;
+	u32 hslot;
+	u32 fifo;
+	int ret;
+
+	fws->stats.txs_host_tossed++;
+
+	if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode)) {
+		hslot = inff_skb_htod_tag_get_field(skb, HSLOT);
+		ret = inff_fws_hanger_poppkt(&fws->hanger, hslot, &pktout,
+					     true);
+		if (ret || !pktout)
+			iphy_err(drvr, "no packet in hanger slot: hslot=%d\n",
+				 hslot);
+		else
+			skb = pktout;
+	}
+
+	entry = inff_skbcb(skb)->mac;
+	if (WARN_ON(!entry || IS_ERR(entry))) {
+		inff_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	if (in_transit) {
+		entry->transit_count--;
+		if (entry->suppressed && entry->suppr_transit_count)
+			entry->suppr_transit_count--;
+	}
+
+	fifo = inff_skb_htod_tag_get_field(skb, FIFO);
+	inff_fws_return_credits(fws, fifo, 1);
+	inff_fws_schedule_deq(fws);
+	inff_fws_macdesc_return_req_credit(skb);
+
+	if (header_pulled) {
+		ifp = inff_get_ifp(drvr,
+				   inff_skb_if_flags_get_field(skb, INDEX));
+	} else {
+		ret = inff_proto_hdrpull(drvr, false, skb, &ifp);
+		if (ret) {
+			inff_pkt_buf_free_skb(skb);
+			return;
+		}
+	}
+
+	inff_txfinalize(ifp, skb, false);
+}
+
+static void inff_fws_credit_auto_recover(struct inff_fws_info *fws, u8 *data)
+{
+	int fifo, i;
+	u8 *fw_tx = data + INFF_FIFO_CREDITBACK_TX_OFFSET;
+	u8 *fw_back = data;
+	int borrowed = 0;
+	int loan = 0;
+	int missing = 0;
+	int host_record_credit;
+	int in_fw_credit;
+
+	inff_dbg(SDIO, "tx %pM back %pM\n", fw_tx, fw_back);
+	inff_dbg(SDIO, "credit [BK]:%d [BE]:%d [VI]:%d [VO]:%d [BCMC]:%d\n",
+		 fws->fifo_credit[0], fws->fifo_credit[1], fws->fifo_credit[2],
+		 fws->fifo_credit[3], fws->fifo_credit[4]);
+
+	/* must check from highest priority FIFO */
+	for (fifo = INFF_FWS_FIFO_COUNT - 1; fifo >= INFF_FWS_FIFO_AC_BK; fifo--) {
+		/* if no credit lost, continue to check next FIFO */
+		if (fws->init_fifo_credit[fifo] == fws->fifo_credit[fifo])
+			continue;
+
+		inff_dbg(SDIO, "FIFO %d init: %d current: %d\n",
+			 fifo, fws->init_fifo_credit[fifo], fws->fifo_credit[fifo]);
+
+		if (fifo <= INFF_FWS_FIFO_AC_VO) {
+			/* how many credit are borrowed from other FIFO */
+			for (i = 0; i <= INFF_FWS_FIFO_AC_VO; i++)
+				borrowed += fws->credits_borrowed[fifo][i];
+
+			/* how many credit are lend to other FIFO */
+			for (i = 0; i <= INFF_FWS_FIFO_AC_VO; i++)
+				loan += fws->credits_borrowed[i][fifo];
+
+			inff_dbg(SDIO, "borrowed: %d loan: %d\n", borrowed, loan);
+		}
+
+		/* calculate missed credit */
+		host_record_credit = fws->init_fifo_credit[fifo] -
+			fws->fifo_credit[fifo] + borrowed - loan;
+		in_fw_credit = fw_tx[fifo] - fw_back[fifo];
+		missing = host_record_credit - in_fw_credit;
+		inff_dbg(SDIO, "host %d fw %d missing: %d\n",
+			 host_record_credit, in_fw_credit, missing);
+
+		if (missing > 0)
+			inff_fws_return_credits(fws, fifo, missing);
+	}
+
+	inff_dbg(SDIO, "Leave: credit [BK]:%d [BE]:%d [VI]:%d [VO]:%d [BCMC]:%d\n",
+		 fws->fifo_credit[0], fws->fifo_credit[1], fws->fifo_credit[2],
+		 fws->fifo_credit[3], fws->fifo_credit[4]);
+}
+
+static int inff_fws_fifocreditback_indicate(struct inff_fws_info *fws,
+					    s16 len, u8 *data)
+{
+	int i;
+
+	if (fws->fcmode != INFF_FWS_FCMODE_EXPLICIT_CREDIT) {
+		inff_dbg(INFO, "ignored\n");
+		return INFF_FWS_RET_OK_NOSCHEDULE;
+	}
+
+	inff_fws_lock(fws);
+	for (i = 0; i < INFF_FWS_FIFO_COUNT; i++)
+		inff_fws_return_credits(fws, i, data[i]);
+
+	inff_dbg(DATA, "map: credit %x delay %x\n", fws->fifo_credit_map,
+		 fws->fifo_delay_map);
+
+	/* when bus error happened, try to recover lost credit */
+	if (len == INFF_FWS_TYPE_FIFO_CREDITBACK_V2_LEN && fws->credit_recover) {
+		inff_err("Trigger credit recover\n");
+		inff_fws_credit_auto_recover(fws, data);
+		fws->credit_recover = false;
+	}
+	inff_fws_unlock(fws);
+	return INFF_FWS_RET_OK_SCHEDULE;
+}
+
+static int inff_fws_txstatus_indicate(struct inff_fws_info *fws, u8 type,
+				      u8 *data)
+{
+	__le32 status_le;
+	__le16 seq_le;
+	u32 status;
+	u32 hslot;
+	u32 genbit;
+	u8 flags, hcnt, fifo_id;
+	u16 seq;
+	u8 compcnt;
+	u8 compcnt_offset = INFF_FWS_TYPE_TXSTATUS_LEN;
+
+	memcpy(&status_le, data, sizeof(status_le));
+	status = le32_to_cpu(status_le);
+	flags = inff_txstatus_get_field(status, FLAGS);
+	hslot = inff_txstatus_get_field(status, HSLOT);
+	genbit = inff_txstatus_get_field(status, GENERATION);
+	hcnt = inff_txstatus_get_field(status, FREERUN);
+	fifo_id = inff_txstatus_get_field(status, FIFO);
+	if (INFF_FWS_MODE_GET_REUSESEQ(fws->mode)) {
+		memcpy(&seq_le, &data[INFF_FWS_TYPE_TXSTATUS_LEN],
+		       sizeof(seq_le));
+		seq = le16_to_cpu(seq_le);
+		compcnt_offset += INFF_FWS_TYPE_SEQ_LEN;
+	} else {
+		seq = 0;
+	}
+
+	if (type == INFF_FWS_TYPE_COMP_TXSTATUS)
+		compcnt = data[compcnt_offset];
+	else
+		compcnt = 1;
+	fws->stats.txs_indicate += compcnt;
+
+	inff_fws_lock(fws);
+	inff_fws_txs_process(fws, flags, hslot, genbit, seq, compcnt, hcnt,
+			     fifo_id);
+	inff_fws_unlock(fws);
+	return INFF_FWS_RET_OK_NOSCHEDULE;
+}
+
+static int inff_fws_dbg_seqnum_check(struct inff_fws_info *fws, u8 *data)
+{
+	__le32 timestamp;
+
+	memcpy(&timestamp, &data[2], sizeof(timestamp));
+	inff_dbg(CTL, "received: seq %d, timestamp %d\n", data[1],
+		 le32_to_cpu(timestamp));
+	return 0;
+}
+
+static int inff_fws_notify_credit_map(struct inff_if *ifp,
+				      const struct inff_event_msg *e,
+				      void *data)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_fws_info *fws = drvr_to_fws(drvr);
+	int i;
+	u8 *credits = data;
+
+	if (e->datalen < INFF_FWS_FIFO_COUNT) {
+		iphy_err(drvr, "event payload too small (%d)\n", e->datalen);
+		return -EINVAL;
+	}
+
+	fws->creditmap_received = true;
+
+	inff_dbg(TRACE, "Event FIFO_CREDIT_MAP (%d) credit map for %pM\n",
+		 e->event_code, credits);
+	inff_fws_lock(fws);
+	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++) {
+		fws->fifo_credit[i] += credits[i] - fws->init_fifo_credit[i];
+		fws->init_fifo_credit[i] = credits[i];
+		if (fws->fifo_credit[i] > 0)
+			fws->fifo_credit_map |= 1 << i;
+		else
+			fws->fifo_credit_map &= ~(1 << i);
+		WARN_ONCE(fws->fifo_credit[i] < 0,
+			  "fifo_credit[%d] is negative(%d)\n", i,
+			  fws->fifo_credit[i]);
+	}
+	inff_fws_schedule_deq(fws);
+	inff_fws_unlock(fws);
+	return 0;
+}
+
+static void inff_creditmap_query_worker(struct work_struct *work)
+{
+	struct inff_fws_info *fws = container_of(work, struct inff_fws_info, creditmap_query_work);
+	struct inff_if *ifp = inff_get_ifp(fws->drvr, 0);
+	struct inff_ohd_creditmap credit_buff;
+	int ret, i = 0;
+	u8 credits[INFF_FWS_FIFO_COUNT];
+	struct inff_event_msg msg;
+
+	if (fws->creditmap_received)
+		return;
+
+	memset(&credit_buff, 0, sizeof(credit_buff));
+	ret = inff_fwcmd_data_get(ifp, ACW74XX_OHD_IOCTL_GET_CREDIT_INFO,
+				  &credit_buff, sizeof(credit_buff));
+
+	if (ret < 0) {
+		inff_err("ACW74XX_OHD_IOCTL_GET_CREDIT_INFO failed\n");
+	} else {
+		for (i = 0; i < credit_buff.num_acs; i++) {
+			inff_dbg(TRACE, " FIFO %d Credits %d\n", i, credit_buff.fifo_credit[i]);
+			credits[i] = credit_buff.fifo_credit[i];
+		}
+		msg.datalen = INFF_FWS_FIFO_COUNT;
+		inff_fws_notify_credit_map(ifp, &msg, credits);
+	}
+}
+
+void inff_creditmap_query(struct inff_fws_info *fws)
+{
+	if (fws && fws->creditmap_query_work.func) {
+		if (!work_busy(&fws->creditmap_query_work))
+			schedule_work(&fws->creditmap_query_work);
+	}
+}
+
+static int inff_fws_notify_bcmc_credit_support(struct inff_if *ifp,
+					       const struct inff_event_msg *e,
+						void *data)
+{
+	struct inff_fws_info *fws = drvr_to_fws(ifp->drvr);
+
+	if (fws) {
+		inff_fws_lock(fws);
+		fws->bcmc_credit_check = true;
+		inff_fws_unlock(fws);
+	}
+	return 0;
+}
+
+static void inff_rxreorder_get_skb_list(struct inff_ampdu_rx_reorder *rfi,
+					u8 start, u8 end,
+					struct sk_buff_head *skb_list)
+{
+	/* initialize return list */
+	__skb_queue_head_init(skb_list);
+
+	if (rfi->pend_pkts == 0) {
+		inff_dbg(INFO, "no packets in reorder queue\n");
+		return;
+	}
+
+	do {
+		if (rfi->pktslots[start]) {
+			__skb_queue_tail(skb_list, rfi->pktslots[start]);
+			rfi->pktslots[start] = NULL;
+		}
+		start++;
+		if (start > rfi->max_idx)
+			start = 0;
+	} while (start != end);
+	rfi->pend_pkts -= skb_queue_len(skb_list);
+}
+
+void inff_fws_rxreorder(struct inff_if *ifp, struct sk_buff *pkt, bool inirq)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	u8 *reorder_data;
+	u8 flow_id, max_idx, cur_idx, exp_idx, end_idx;
+	struct inff_ampdu_rx_reorder *rfi;
+	struct sk_buff_head reorder_list;
+	struct sk_buff *pnext;
+	u8 flags;
+
+	reorder_data = ((struct inff_skb_reorder_data *)pkt->cb)->reorder;
+	flow_id = reorder_data[INFF_RXREORDER_FLOWID_OFFSET];
+	flags = reorder_data[INFF_RXREORDER_FLAGS_OFFSET];
+
+	/* validate flags and flow id */
+	if (flags == 0xFF) {
+		iphy_err(drvr, "invalid flags...so ignore this packet\n");
+		inff_net_rx(ifp, pkt, inirq);
+		return;
+	}
+
+	rfi = ifp->drvr->reorder_flows[flow_id];
+	if (flags & INFF_RXREORDER_DEL_FLOW) {
+		inff_dbg(INFO, "flow-%d: delete\n",
+			 flow_id);
+
+		if (!rfi) {
+			inff_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
+				 flow_id);
+			inff_net_rx(ifp, pkt, inirq);
+			return;
+		}
+
+		inff_rxreorder_get_skb_list(rfi, rfi->exp_idx, rfi->exp_idx,
+					    &reorder_list);
+		/* add the last packet */
+		__skb_queue_tail(&reorder_list, pkt);
+		kfree(rfi);
+		ifp->drvr->reorder_flows[flow_id] = NULL;
+		goto netif_rx;
+	}
+	/* from here on we need a flow reorder instance */
+	if (!rfi) {
+		max_idx = reorder_data[INFF_RXREORDER_MAXIDX_OFFSET];
+
+		/* allocate space for flow reorder info */
+		inff_dbg(INFO, "flow-%d: start, maxidx %d\n",
+			 flow_id, max_idx);
+		rfi = kzalloc_flex(*rfi, pktslots, max_idx + 1,
+				   GFP_ATOMIC);
+		if (!rfi) {
+			inff_net_rx(ifp, pkt, inirq);
+			return;
+		}
+
+		ifp->drvr->reorder_flows[flow_id] = rfi;
+		rfi->max_idx = max_idx;
+	}
+	if (flags & INFF_RXREORDER_NEW_HOLE)  {
+		if (rfi->pend_pkts) {
+			inff_rxreorder_get_skb_list(rfi, rfi->exp_idx,
+						    rfi->exp_idx,
+						    &reorder_list);
+			WARN_ON(rfi->pend_pkts);
+		} else {
+			__skb_queue_head_init(&reorder_list);
+		}
+		rfi->cur_idx = reorder_data[INFF_RXREORDER_CURIDX_OFFSET];
+		rfi->exp_idx = reorder_data[INFF_RXREORDER_EXPIDX_OFFSET];
+		rfi->max_idx = reorder_data[INFF_RXREORDER_MAXIDX_OFFSET];
+		rfi->pktslots[rfi->cur_idx] = pkt;
+		rfi->pend_pkts++;
+		inff_dbg(DATA, "flow-%d: new hole %d (%d), pending %d\n",
+			 flow_id, rfi->cur_idx, rfi->exp_idx, rfi->pend_pkts);
+	} else if (flags & INFF_RXREORDER_CURIDX_VALID) {
+		cur_idx = reorder_data[INFF_RXREORDER_CURIDX_OFFSET];
+		exp_idx = reorder_data[INFF_RXREORDER_EXPIDX_OFFSET];
+
+		if (exp_idx == rfi->exp_idx && cur_idx != rfi->exp_idx) {
+			/* still in the current hole */
+			/* enqueue the current on the buffer chain */
+			if (rfi->pktslots[cur_idx]) {
+				inff_dbg(INFO, "HOLE: ERROR buffer pending..free it\n");
+				inff_pkt_buf_free_skb(rfi->pktslots[cur_idx]);
+				rfi->pktslots[cur_idx] = NULL;
+				rfi->pend_pkts--;
+			}
+			rfi->pktslots[cur_idx] = pkt;
+			rfi->pend_pkts++;
+			rfi->cur_idx = cur_idx;
+			inff_dbg(DATA, "flow-%d: store pkt %d (%d), pending %d\n",
+				 flow_id, cur_idx, exp_idx, rfi->pend_pkts);
+
+			/* can return now as there is no reorder
+			 * list to process.
+			 */
+			return;
+		}
+		if (rfi->exp_idx == cur_idx) {
+			if (rfi->pktslots[cur_idx]) {
+				inff_dbg(INFO, "error buffer pending..free it\n");
+				inff_pkt_buf_free_skb(rfi->pktslots[cur_idx]);
+				rfi->pktslots[cur_idx] = NULL;
+				rfi->pend_pkts--;
+			}
+			rfi->pktslots[cur_idx] = pkt;
+			rfi->pend_pkts++;
+
+			/* got the expected one. flush from current to expected
+			 * and update expected
+			 */
+			inff_dbg(DATA, "flow-%d: expected %d (%d), pending %d\n",
+				 flow_id, cur_idx, exp_idx, rfi->pend_pkts);
+
+			rfi->cur_idx = cur_idx;
+			rfi->exp_idx = exp_idx;
+
+			inff_rxreorder_get_skb_list(rfi, cur_idx, exp_idx,
+						    &reorder_list);
+			inff_dbg(DATA, "flow-%d: freeing buffers %d, pending %d\n",
+				 flow_id, skb_queue_len(&reorder_list),
+				 rfi->pend_pkts);
+		} else {
+			u8 end_idx;
+
+			inff_dbg(DATA, "flow-%d (0x%x): both moved, old %d/%d, new %d/%d\n",
+				 flow_id, flags, rfi->cur_idx, rfi->exp_idx,
+				 cur_idx, exp_idx);
+			if (flags & INFF_RXREORDER_FLUSH_ALL)
+				end_idx = rfi->exp_idx;
+			else
+				end_idx = exp_idx;
+
+			/* flush pkts first */
+			inff_rxreorder_get_skb_list(rfi, rfi->exp_idx, end_idx,
+						    &reorder_list);
+
+			if (exp_idx == ((cur_idx + 1) % (rfi->max_idx + 1))) {
+				__skb_queue_tail(&reorder_list, pkt);
+			} else {
+				rfi->pktslots[cur_idx] = pkt;
+				rfi->pend_pkts++;
+			}
+			rfi->exp_idx = exp_idx;
+			rfi->cur_idx = cur_idx;
+		}
+	} else {
+		/* explicitly window move updating the expected index */
+		exp_idx = reorder_data[INFF_RXREORDER_EXPIDX_OFFSET];
+
+		inff_dbg(DATA, "flow-%d (0x%x): change expected: %d -> %d\n",
+			 flow_id, flags, rfi->exp_idx, exp_idx);
+		if (flags & INFF_RXREORDER_FLUSH_ALL)
+			end_idx =  rfi->exp_idx;
+		else
+			end_idx =  exp_idx;
+
+		inff_rxreorder_get_skb_list(rfi, rfi->exp_idx, end_idx,
+					    &reorder_list);
+		__skb_queue_tail(&reorder_list, pkt);
+		/* set the new expected idx */
+		rfi->exp_idx = exp_idx;
+	}
+netif_rx:
+	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
+		__skb_unlink(pkt, &reorder_list);
+		inff_net_rx(ifp, pkt, inirq);
+	}
+}
+
+void inff_fws_hdrpull(struct inff_if *ifp, s16 siglen, struct sk_buff *skb)
+{
+	struct inff_skb_reorder_data *rd;
+	struct inff_fws_info *fws = drvr_to_fws(ifp->drvr);
+	u8 *signal_data;
+	s16 data_len;
+	u8 type;
+	s16 len;
+	u8 *data;
+	s32 status;
+	s32 err;
+
+	inff_dbg(HDRS, "ifidx %d, skblen %u, sig %d\n",
+		 ifp->ifidx, skb->len, siglen);
+
+	WARN_ON(siglen > skb->len);
+
+	if (siglen > skb->len)
+		siglen = skb->len;
+
+	if (!siglen)
+		return;
+	/* if flow control disabled, skip to packet data and leave */
+	if (!fws || !fws->fw_signals) {
+		skb_pull(skb, siglen);
+		return;
+	}
+
+	fws->stats.header_pulls++;
+	data_len = siglen;
+	signal_data = skb->data;
+
+	status = INFF_FWS_RET_OK_NOSCHEDULE;
+	while (data_len > 0) {
+		/* extract tlv info */
+		type = signal_data[0];
+
+		/* FILLER type is actually not a TLV, but
+		 * a single byte that can be skipped.
+		 */
+		if (type == INFF_FWS_TYPE_FILLER) {
+			signal_data += 1;
+			data_len -= 1;
+			continue;
+		}
+		len = signal_data[1];
+		data = signal_data + 2;
+
+		inff_dbg(HDRS, "tlv type=%s (%d), len=%d (%d)\n",
+			 inff_fws_get_tlv_name(type), type, len,
+			  inff_fws_get_tlv_len(fws, type));
+
+		/* abort parsing when length invalid */
+		if (data_len < len + 2)
+			break;
+
+		if (len < inff_fws_get_tlv_len(fws, type))
+			break;
+
+		err = INFF_FWS_RET_OK_NOSCHEDULE;
+		switch (type) {
+		case INFF_FWS_TYPE_HOST_REORDER_RXPKTS:
+			rd = (struct inff_skb_reorder_data *)skb->cb;
+			rd->reorder = data;
+			break;
+		case INFF_FWS_TYPE_MACDESC_ADD:
+		case INFF_FWS_TYPE_MACDESC_DEL:
+			inff_fws_macdesc_indicate(fws, type, data);
+			break;
+		case INFF_FWS_TYPE_MAC_OPEN:
+		case INFF_FWS_TYPE_MAC_CLOSE:
+			err = inff_fws_macdesc_state_indicate(fws, type, data);
+			break;
+		case INFF_FWS_TYPE_INTERFACE_OPEN:
+		case INFF_FWS_TYPE_INTERFACE_CLOSE:
+			err = inff_fws_interface_state_indicate(fws, type,
+								data);
+			break;
+		case INFF_FWS_TYPE_MAC_REQUEST_CREDIT:
+		case INFF_FWS_TYPE_MAC_REQUEST_PACKET:
+			err = inff_fws_request_indicate(fws, type, data);
+			break;
+		case INFF_FWS_TYPE_TXSTATUS:
+		case INFF_FWS_TYPE_COMP_TXSTATUS:
+			inff_fws_txstatus_indicate(fws, type, data);
+			break;
+		case INFF_FWS_TYPE_FIFO_CREDITBACK:
+			err = inff_fws_fifocreditback_indicate(fws, len, data);
+			break;
+		case INFF_FWS_TYPE_RSSI:
+			inff_fws_rssi_indicate(fws, *data);
+			break;
+		case INFF_FWS_TYPE_TRANS_ID:
+			inff_fws_dbg_seqnum_check(fws, data);
+			break;
+		case INFF_FWS_TYPE_PKTTAG:
+		case INFF_FWS_TYPE_PENDING_TRAFFIC_BMP:
+		default:
+			fws->stats.tlv_invalid_type++;
+			break;
+		}
+		if (err == INFF_FWS_RET_OK_SCHEDULE)
+			status = INFF_FWS_RET_OK_SCHEDULE;
+		signal_data += len + 2;
+		data_len -= len + 2;
+	}
+
+	if (data_len != 0)
+		fws->stats.tlv_parse_failed++;
+
+	if (status == INFF_FWS_RET_OK_SCHEDULE)
+		inff_fws_schedule_deq(fws);
+
+	/* signalling processing result does
+	 * not affect the actual ethernet packet.
+	 */
+	skb_pull(skb, siglen);
+
+	/* this may be a signal-only packet
+	 */
+	if (skb->len == 0)
+		fws->stats.header_only_pkt++;
+}
+
+static u8 inff_fws_precommit_skb(struct inff_fws_info *fws, int fifo,
+				 struct sk_buff *p)
+{
+	struct inff_skbuff_cb *skcb = inff_skbcb(p);
+	struct inff_fws_mac_descriptor *entry = skcb->mac;
+	u8 flags;
+
+	if (skcb->state != INFF_FWS_SKBSTATE_SUPPRESSED)
+		inff_skb_htod_tag_set_field(p, GENERATION, entry->generation);
+	flags = INFF_FWS_HTOD_FLAG_PKTFROMHOST;
+	if (inff_skb_if_flags_get_field(p, REQUESTED)) {
+		/*
+		 * Indicate that this packet is being sent in response to an
+		 * explicit request from the firmware side.
+		 */
+		flags |= INFF_FWS_HTOD_FLAG_PKT_REQUESTED;
+	}
+	inff_skb_htod_tag_set_field(p, FLAGS, flags);
+	return inff_fws_hdrpush(fws, p);
+}
+
+static void inff_fws_rollback_toq(struct inff_fws_info *fws,
+				  struct sk_buff *skb, int fifo)
+{
+	struct inff_pub *drvr = fws->drvr;
+	struct inff_fws_mac_descriptor *entry;
+	struct sk_buff *pktout;
+	int qidx;
+	int rc = 0;
+
+	entry = inff_skbcb(skb)->mac;
+	if (entry->occupied) {
+		qidx = 2 * fifo;
+		if (inff_skbcb(skb)->state == INFF_FWS_SKBSTATE_SUPPRESSED)
+			qidx++;
+
+		pktout = inff_pktq_penq_head(&entry->psq, qidx, skb);
+		if (!pktout) {
+			iphy_err(drvr, "%s queue %d full\n", entry->name, qidx);
+			rc = -ENOSPC;
+		}
+	} else {
+		iphy_err(drvr, "%s entry removed\n", entry->name);
+		rc = -ENOENT;
+	}
+
+	if (rc) {
+		fws->stats.rollback_failed++;
+		inff_fws_txs_process_host_tossed(fws, skb, true, false);
+	} else {
+		fws->stats.rollback_success++;
+		inff_fws_return_credits(fws, fifo, 1);
+		inff_fws_macdesc_return_req_credit(skb);
+	}
+}
+
+static int inff_fws_borrow_credit(struct inff_fws_info *fws,
+				  int highest_lender_ac, int borrower_ac,
+				  bool borrow_all)
+{
+	int lender_ac, borrow_limit = 0;
+
+	for (lender_ac = 0; lender_ac <= highest_lender_ac; lender_ac++) {
+		if (!borrow_all)
+			borrow_limit =
+			  fws->init_fifo_credit[lender_ac] / INFF_BORROW_RATIO;
+		else
+			borrow_limit = 0;
+
+		if (fws->fifo_credit[lender_ac] > borrow_limit) {
+			fws->credits_borrowed[borrower_ac][lender_ac]++;
+			fws->fifo_credit[lender_ac]--;
+			if (fws->fifo_credit[lender_ac] == 0)
+				fws->fifo_credit_map &= ~(1 << lender_ac);
+			fws->fifo_credit_map |= (1 << borrower_ac);
+			inff_dbg(DATA, "borrow credit from: %d\n", lender_ac);
+			return 0;
+		}
+	}
+	fws->fifo_credit_map &= ~(1 << borrower_ac);
+	return -ENAVAIL;
+}
+
+static int inff_fws_commit_skb(struct inff_fws_info *fws, int fifo,
+			       struct sk_buff *skb)
+{
+	struct inff_skbuff_cb *skcb = inff_skbcb(skb);
+	struct inff_fws_mac_descriptor *entry;
+	int rc;
+	u8 ifidx;
+	u8 data_offset;
+
+	entry = skcb->mac;
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
+
+	data_offset = inff_fws_precommit_skb(fws, fifo, skb);
+	entry->transit_count++;
+	if (entry->suppressed)
+		entry->suppr_transit_count++;
+	ifidx = inff_skb_if_flags_get_field(skb, INDEX);
+	inff_fws_unlock(fws);
+	rc = inff_proto_txdata(fws->drvr, ifidx, data_offset, skb);
+	inff_fws_lock(fws);
+	inff_dbg(DATA, "%s flags %X htod %X bus_tx %d\n", entry->name,
+		 skcb->if_flags, skcb->htod, rc);
+	if (rc < 0) {
+		entry->transit_count--;
+		if (entry->suppressed)
+			entry->suppr_transit_count--;
+		(void)inff_proto_hdrpull(fws->drvr, false, skb, NULL);
+		goto rollback;
+	}
+
+	fws->stats.pkt2bus++;
+	fws->stats.send_pkts[fifo]++;
+	if (inff_skb_if_flags_get_field(skb, REQUESTED))
+		fws->stats.requested_sent[fifo]++;
+
+	return rc;
+
+rollback:
+	inff_fws_rollback_toq(fws, skb, fifo);
+	return rc;
+}
+
+static int inff_fws_assign_htod(struct inff_fws_info *fws, struct sk_buff *p,
+				int fifo)
+{
+	struct inff_skbuff_cb *skcb = inff_skbcb(p);
+	int rc = 0, hslot;
+
+	skcb->htod = 0;
+	skcb->htod_seq = 0;
+	if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		hslot = (uint)(skcb->mac - &fws->desc.nodes[0]);
+	else
+		hslot = inff_fws_hanger_get_free_slot(&fws->hanger);
+	inff_skb_htod_tag_set_field(p, HSLOT, hslot);
+	inff_skb_htod_tag_set_field(p, FREERUN, skcb->mac->seq[fifo]);
+	inff_skb_htod_tag_set_field(p, FIFO, fifo);
+	if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		rc = inff_fws_hanger_pushpkt(&fws->hanger, p, hslot);
+	if (!rc)
+		skcb->mac->seq[fifo]++;
+	else
+		fws->stats.generic_error++;
+	return rc;
+}
+
+int inff_fws_process_skb(struct inff_if *ifp, struct sk_buff *skb)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_fws_info *fws = drvr_to_fws(drvr);
+	struct inff_skbuff_cb *skcb = inff_skbcb(skb);
+	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	int fifo = INFF_FWS_FIFO_BCMC;
+	bool multicast = is_multicast_ether_addr(eh->h_dest);
+	int rc = 0;
+
+	inff_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
+
+	/* set control buffer information */
+	skcb->if_flags = 0;
+	skcb->state = INFF_FWS_SKBSTATE_NEW;
+	inff_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
+
+	/* mapping from 802.1d priority to firmware fifo index */
+	if (!multicast)
+		fifo = inff_map_prio_to_aci(drvr->config, skb->priority);
+
+	inff_fws_lock(fws);
+	if (fifo != INFF_FWS_FIFO_AC_BE && fifo < INFF_FWS_FIFO_BCMC)
+		fws->borrow_defer_timestamp = jiffies +
+					      INFF_FWS_BORROW_DEFER_PERIOD;
+
+	skcb->mac = inff_fws_macdesc_find(fws, ifp, eh->h_dest);
+	inff_dbg(DATA, "%s mac %pM multi %d fifo %d\n", skcb->mac->name,
+		 eh->h_dest, multicast, fifo);
+	if (!inff_fws_assign_htod(fws, skb, fifo)) {
+		inff_fws_enq(fws, INFF_FWS_SKBSTATE_DELAYED, fifo, skb);
+		inff_fws_schedule_deq(fws);
+	} else {
+		iphy_err(drvr, "no hanger slot available\n");
+		rc = -ENOMEM;
+	}
+	inff_fws_unlock(fws);
+
+	return rc;
+}
+
+void inff_fws_reset_interface(struct inff_if *ifp)
+{
+	struct inff_fws_mac_descriptor *entry = ifp->fws_desc;
+
+	if (entry)
+		inff_fws_macdesc_init(entry, ifp->mac_addr, ifp->ifidx);
+}
+
+void inff_fws_add_interface(struct inff_if *ifp)
+{
+	struct inff_fws_info *fws = drvr_to_fws(ifp->drvr);
+	struct inff_fws_mac_descriptor *entry;
+
+	if (!ifp->ndev || !inff_fws_queue_skbs(fws))
+		return;
+
+	entry = &fws->desc.iface[ifp->ifidx];
+	ifp->fws_desc = entry;
+	inff_fws_macdesc_init(entry, ifp->mac_addr, ifp->ifidx);
+	inff_fws_macdesc_set_name(fws, entry);
+	inff_pktq_init(&entry->psq,
+		       INFF_FWS_PSQ_PREC_COUNT,
+		       fws->fws_psq_len);
+	if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_pktq_init(&entry->afq, INFF_FWS_AFQ_PREC_COUNT,
+			       INFF_FWS_AFQ_LEN);
+	inff_dbg(TRACE, "added %s\n", entry->name);
+}
+
+void inff_fws_del_interface(struct inff_if *ifp)
+{
+	struct inff_fws_mac_descriptor *entry = ifp->fws_desc;
+	struct inff_fws_info *fws = drvr_to_fws(ifp->drvr);
+
+	if (!entry)
+		return;
+
+	inff_fws_lock(fws);
+	ifp->fws_desc = NULL;
+	inff_dbg(TRACE, "deleting %s\n", entry->name);
+	inff_fws_macdesc_cleanup(fws, &fws->desc.iface[ifp->ifidx],
+				 ifp->ifidx);
+	inff_fws_macdesc_deinit(entry);
+	inff_fws_cleanup(fws, ifp->ifidx);
+	inff_fws_unlock(fws);
+}
+
+static void inff_fws_dequeue_worker(struct work_struct *worker)
+{
+	struct inff_fws_info *fws;
+	struct inff_pub *drvr;
+	struct sk_buff *skb;
+	int fifo;
+	u32 hslot;
+	u32 ifidx;
+	int ret;
+	u32 highest_lender = 0;
+
+	fws = container_of(worker, struct inff_fws_info, fws_dequeue_work);
+	drvr = fws->drvr;
+
+	inff_fws_lock(fws);
+	for (fifo = INFF_FWS_FIFO_BCMC; fifo >= 0 && !fws->bus_flow_blocked;
+	     fifo--) {
+		if (!inff_fws_fc_active(fws)) {
+			while ((skb = inff_fws_deq(fws, fifo)) != NULL) {
+				hslot = inff_skb_htod_tag_get_field(skb,
+								    HSLOT);
+				if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+					inff_fws_hanger_poppkt(&fws->hanger,
+							       hslot, &skb,
+							       true);
+				ifidx = inff_skb_if_flags_get_field(skb,
+								    INDEX);
+				/* Use proto layer to send data frame */
+				inff_fws_unlock(fws);
+				ret = inff_proto_txdata(drvr, ifidx, 0, skb);
+				inff_fws_lock(fws);
+				if (ret < 0)
+					inff_txfinalize(inff_get_ifp(drvr,
+								     ifidx),
+							 skb, false);
+				if (fws->bus_flow_blocked)
+					break;
+			}
+			continue;
+		}
+
+		while ((fws->fifo_credit[fifo]) ||
+		       ((!fws->bcmc_credit_check) &&
+				(fifo == INFF_FWS_FIFO_BCMC))) {
+			skb = inff_fws_deq(fws, fifo);
+			if (!skb)
+				break;
+			fws->fifo_credit[fifo]--;
+			if (inff_fws_commit_skb(fws, fifo, skb))
+				break;
+			if (fws->bus_flow_blocked)
+				break;
+		}
+
+		if (fifo >= INFF_FWS_FIFO_AC_BK &&
+		    fifo <= INFF_FWS_FIFO_AC_VO &&
+		    fws->fifo_credit[fifo] == 0 &&
+		    !fws->bus_flow_blocked) {
+			highest_lender = fifo - 1;
+
+			/* Borrow Credit for BK access category from Higer AC queues */
+			if (fifo == INFF_FWS_FIFO_AC_BK)
+				highest_lender = INFF_FWS_FIFO_AC_BE;
+
+			while (inff_fws_borrow_credit(fws, highest_lender,
+						      fifo, true) == 0) {
+				skb = inff_fws_deq(fws, fifo);
+				if (!skb) {
+					inff_fws_return_credits(fws, fifo, 1);
+					break;
+				}
+				if (inff_fws_commit_skb(fws, fifo, skb))
+					break;
+				if (fws->bus_flow_blocked)
+					break;
+			}
+		}
+	}
+	inff_fws_unlock(fws);
+}
+
+#ifdef DEBUG
+static int inff_debugfs_fws_stats_read(struct seq_file *seq, void *data)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(seq->private);
+	struct inff_fws_info *fws = drvr_to_fws(bus_if->drvr);
+	struct inff_fws_stats *fwstats = &fws->stats;
+
+	seq_printf(seq,
+		   "header_pulls:    %8u\t"
+		   "header_only_pkt: %8u\n"
+		   "tlv_parse_failed:%8u\t"
+		   "tlv_invalid_type:%8u\n"
+		   "mac_update_fails:%8u\t"
+		   "ps_update_fails: %8u\t"
+		   "if_update_fails: %8u\n"
+		   "pkt2bus:         %8u\t"
+		   "generic_error:   %8u\n"
+		   "rollback_success:%8u\t"
+		   "rollback_failed: %8u\n"
+		   "delayq_full:     %8u\t"
+		   "supprq_full:     %8u\n"
+		   "txs_indicate:    %8u\t"
+		   "txs_discard:     %8u\n"
+		   "txs_suppr_core:  %8u\t"
+		   "txs_suppr_ps:    %8u\n"
+		   "txs_tossed:      %8u\t"
+		   "txs_expired:     %8u\n"
+		   "txs_dropped:     %8u\t"
+		   "txs_mktfree:     %8u\n"
+		   "txs_unknown:     %8u\t"
+		   "txs_host_tossed: %8u\n"
+		   "bus_flow_block:  %8u\t"
+		   "fws_flow_block:  %8u\n",
+		   fwstats->header_pulls,
+		   fwstats->header_only_pkt,
+		   fwstats->tlv_parse_failed,
+		   fwstats->tlv_invalid_type,
+		   fwstats->mac_update_failed,
+		   fwstats->mac_ps_update_failed,
+		   fwstats->if_update_failed,
+		   fwstats->pkt2bus,
+		   fwstats->generic_error,
+		   fwstats->rollback_success,
+		   fwstats->rollback_failed,
+		   fwstats->delayq_full_error,
+		   fwstats->supprq_full_error,
+		   fwstats->txs_indicate,
+		   fwstats->txs_discard,
+		   fwstats->txs_supp_core,
+		   fwstats->txs_supp_ps,
+		   fwstats->txs_tossed,
+		   fwstats->txs_expired,
+		   fwstats->txs_dropped,
+		   fwstats->txs_mktfree,
+		   fwstats->txs_unknown,
+		   fwstats->txs_host_tossed,
+		   fwstats->bus_flow_block,
+		   fwstats->fws_flow_block);
+
+	seq_printf(seq,
+		   "receive error:	%8u\t"
+		   "cleanup if:		%8u\n\n",
+		   fwstats->cnt_recv_err,
+		   fwstats->cnt_cleanup_if);
+
+	seq_printf(seq,
+		   "send_pkts:		  BK:%u BE:%u VO:%u VI:%u BCMC:%u\n"
+		   "requested_sent:	  BK:%u BE:%u VO:%u VI:%u BCMC:%u\n\n",
+		   fwstats->send_pkts[0], fwstats->send_pkts[1],
+		   fwstats->send_pkts[2], fwstats->send_pkts[3],
+		   fwstats->send_pkts[4],
+		   fwstats->requested_sent[0],
+		   fwstats->requested_sent[1],
+		   fwstats->requested_sent[2],
+		   fwstats->requested_sent[3],
+		   fwstats->requested_sent[4]);
+
+	return 0;
+}
+#else
+static int inff_debugfs_fws_stats_read(struct seq_file *seq, void *data)
+{
+	return 0;
+}
+#endif
+
+struct inff_fws_info *inff_fws_attach(struct inff_pub *drvr)
+{
+	struct inff_chip *ci = drvr->bus_if->chip_pub;
+	struct inff_fws_info *fws;
+	struct inff_if *ifp;
+	u32 tlv = INFF_FWS_FLAGS_RSSI_SIGNALS;
+	int rc;
+	u32 mode = 0, fw_caps;
+
+	fws = kzalloc_obj(*fws);
+	if (!fws) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	spin_lock_init(&fws->spinlock);
+
+	/* store drvr reference */
+	fws->drvr = drvr;
+	fws->fcmode = drvr->settings->fcmode;
+	fws->fws_psq_len = INFF_FWS_PSQ_LEN;
+	fws->fws_psq_hi_water = INFF_FWS_FLOWCONTROL_HIWATER;
+	fws->fws_psq_low_water = INFF_FWS_FLOWCONTROL_LOWATER;
+
+	if (!drvr->bus_if->always_use_fws_queue &&
+	    fws->fcmode == INFF_FWS_FCMODE_NONE) {
+		fws->avoid_queueing = true;
+		inff_dbg(INFO, "FWS queueing will be avoided\n");
+		return fws;
+	}
+
+	fws->fws_wq = create_singlethread_workqueue("inff_fws_wq");
+	if (!fws->fws_wq) {
+		iphy_err(drvr, "workqueue creation failed\n");
+		rc = -EBADF;
+		goto fail;
+	}
+	INIT_WORK(&fws->fws_dequeue_work, inff_fws_dequeue_worker);
+
+	/* enable firmware signalling if fcmode active */
+	if (fws->fcmode != INFF_FWS_FCMODE_NONE)
+		tlv |= INFF_FWS_FLAGS_XONXOFF_SIGNALS |
+		       INFF_FWS_FLAGS_CREDIT_STATUS_SIGNALS |
+		       INFF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE |
+		       INFF_FWS_FLAGS_HOST_RXREORDER_ACTIVE;
+
+	if (ci->chip == INF_CC_ACW74XX_CHIP_ID) {
+		INIT_WORK(&fws->creditmap_query_work, inff_creditmap_query_worker);
+	} else {
+		rc = inff_fwevt_register(drvr, INFF_E_FIFO_CREDIT_MAP,
+					 inff_fws_notify_credit_map);
+		if (rc < 0) {
+			iphy_err(drvr, "register credit map handler failed\n");
+			goto fail;
+		}
+		rc = inff_fwevt_register(drvr, INFF_E_BCMC_CREDIT_SUPPORT,
+					 inff_fws_notify_bcmc_credit_support);
+		if (rc < 0) {
+			iphy_err(drvr, "register bcmc credit handler failed\n");
+			inff_fwevt_unregister(drvr, INFF_E_FIFO_CREDIT_MAP);
+			goto fail;
+		}
+	}
+
+	/* Setting the iovar may fail if feature is unsupported
+	 * so leave the rc as is so driver initialization can
+	 * continue. Set mode back to none indicating not enabled.
+	 */
+	fws->fw_signals = true;
+	ifp = inff_get_ifp(drvr, 0);
+	if (inff_fwcmd_iovar_int_set(ifp, "tlv", tlv)) {
+		iphy_err(drvr, "failed to set bdcv2 tlv signaling\n");
+		fws->fcmode = INFF_FWS_FCMODE_NONE;
+		fws->fw_signals = false;
+	}
+
+	if (inff_fwcmd_iovar_int_set(ifp, "ampdu_hostreorder", 1))
+		inff_dbg(INFO, "enabling AMPDU host-reorder failed\n");
+
+	/* Enable seq number reuse, if supported */
+	rc = 0;
+	if (inff_fwcmd_iovar_int_get(ifp, "wlfc_mode", &fw_caps) == 0) {
+		inff_dbg(INFO, "wlfc_mode fw_caps=0x%x\n", fw_caps);
+
+		if (INFF_FWS_MODE_IS_OLD_DEF(fw_caps)) {
+			mode = INFF_FWS_MODE_AFQ;
+		} else {
+			u8 afq = INFF_FWS_MODE_GET_AFQ(fw_caps);
+			u8 reordersupp = INFF_FWS_MODE_GET_REORDERSUPP(fw_caps);
+
+			mode = inff_fws_mode_set_afq(mode, afq);
+			mode = inff_fws_mode_set_reordersupp(mode, reordersupp);
+		}
+
+		if (!drvr->settings->afq_enable) {
+			if (INFF_FWS_MODE_IS_OLD_DEF(fw_caps))
+				mode = INFF_FWS_MODE_HANGER;
+			else
+				mode = inff_fws_mode_set_afq(mode, 0);
+		}
+
+		rc = inff_fwcmd_iovar_int_set(ifp, "wlfc_mode", mode);
+		if (INFF_FWS_MODE_GET_REUSESEQ(fw_caps)) {
+			INFF_FWS_MODE_SET_REUSESEQ(fws->mode, 1);
+			if (rc >= 0)
+				INFF_FWS_MODE_SET_REUSESEQ(mode, 1);
+		}
+	}
+
+	fws->wlfc_mode = 0;
+	if (rc >= 0) {
+		if (INFF_FWS_MODE_IS_OLD_DEF(mode))
+			fws->wlfc_mode = inff_fws_mode_set_afq(fws->wlfc_mode,
+							       mode == INFF_FWS_MODE_AFQ);
+		else
+			fws->wlfc_mode = mode;
+	} else {
+		iphy_err(drvr, "set wlfc_mode failed, rc=%d\n", rc);
+		goto fail;
+	}
+
+	if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_fws_hanger_init(&fws->hanger);
+	inff_fws_macdesc_init(&fws->desc.other, NULL, 0);
+	inff_fws_macdesc_set_name(fws, &fws->desc.other);
+	inff_dbg(INFO, "added %s\n", fws->desc.other.name);
+	inff_pktq_init(&fws->desc.other.psq,
+		       INFF_FWS_PSQ_PREC_COUNT,
+		       fws->fws_psq_len);
+	if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_pktq_init(&fws->desc.other.afq, INFF_FWS_AFQ_PREC_COUNT,
+			       INFF_FWS_AFQ_LEN);
+
+	inff_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
+		 fws->fw_signals ? "enabled" : "disabled", tlv);
+
+	if (ci->chip == INF_CC_ACW74XX_CHIP_ID) {
+		if (inff_sdio_credit_map_update(drvr->bus_if)) {
+			/* process the pending query */
+			inff_creditmap_query(fws);
+		}
+	}
+
+	return fws;
+
+fail:
+	inff_fws_detach(fws);
+	return ERR_PTR(rc);
+}
+
+void inff_fws_detach(struct inff_fws_info *fws)
+{
+	if (!fws)
+		return;
+
+	/* Cancel creditmap_query_work which uses system_wq (not fws_wq).
+	 * Must cancel before kfree(fws) to prevent use-after-free.
+	 */
+	/* Only cancel if work was initialized (ACW74XX chip only) */
+	if (fws->creditmap_query_work.func)
+		cancel_work_sync(&fws->creditmap_query_work);
+
+	if (fws->fws_wq)
+		destroy_workqueue(fws->fws_wq);
+
+	/* cleanup */
+	inff_fws_lock(fws);
+	inff_fws_cleanup(fws, -1);
+	inff_fws_unlock(fws);
+
+	/* free top structure */
+	kfree(fws);
+}
+
+void inff_fws_debugfs_create(struct inff_pub *drvr)
+{
+	/* create debugfs file for statistics */
+	inff_debugfs_add_entry(drvr, "fws_stats",
+			       inff_debugfs_fws_stats_read);
+}
+
+bool inff_fws_queue_skbs(struct inff_fws_info *fws)
+{
+	return !fws->avoid_queueing;
+}
+
+bool inff_fws_fc_active(struct inff_fws_info *fws)
+{
+	if (!fws->creditmap_received)
+		return false;
+
+	return fws->fcmode != INFF_FWS_FCMODE_NONE;
+}
+
+void inff_fws_bustxcomplete(struct inff_fws_info *fws, struct sk_buff *skb,
+			    bool success)
+{
+	if (inff_skbcb(skb)->state == INFF_FWS_SKBSTATE_TIM) {
+		inff_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	if (!success) {
+		inff_fws_lock(fws);
+		inff_fws_txs_process_host_tossed(fws, skb, false, true);
+		inff_fws_unlock(fws);
+	} else {
+		inff_fws_lock(fws);
+		if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+			inff_fws_enque_afq(fws, skb);
+		inff_fws_unlock(fws);
+	}
+}
+
+/** afq = At Firmware Queue, queue containing packets pending in the dongle */
+static int inff_fws_deque_afq(struct inff_fws_info *fws, u16 hslot, u8 hcnt,
+			      u8 prec, struct sk_buff **pktout)
+{
+	struct inff_fws_mac_descriptor *entry;
+	struct pktq *pq;
+	struct sk_buff_head *q;
+	struct sk_buff *p = NULL, *b = NULL;
+
+	if (!fws)
+		return -ENAVAIL;
+
+	if (pktout)
+		*pktout = NULL;
+
+	WARN_ON(hslot >= INFF_FWS_MAC_DESC_TABLE_SIZE + INFF_MAX_IFS + 1);
+
+	if (hslot < INFF_FWS_MAC_DESC_TABLE_SIZE)
+		entry = &fws->desc.nodes[hslot];
+	else if (hslot < INFF_FWS_MAC_DESC_TABLE_SIZE + INFF_MAX_IFS)
+		entry = &fws->desc.iface[hslot - INFF_FWS_MAC_DESC_TABLE_SIZE];
+	else
+		entry = &fws->desc.other;
+
+	pq = &entry->afq;
+	if (WARN_ON(prec >= pq->num_prec))
+		return -EINVAL;
+
+	q = &pq->q[prec].skblist;
+	skb_queue_walk(q, p) {
+		if (p && hcnt != inff_skb_htod_tag_get_field(p, FREERUN))
+			b = p;
+		else
+			break;
+	}
+
+	if (p == (struct sk_buff *)q) {
+		if (b)
+			inff_dbg(SDIO, "can't find matching seq(%d)\n", hcnt);
+		else
+			inff_dbg(SDIO, "queue is empty\n");
+		return 0;
+	}
+
+	if (!b) {
+		p = inff_pktq_pdeq(pq, prec);
+	} else {
+		inff_dbg(SDIO, "out of order, seq(%d), head_seq(%d)\n", hcnt,
+			 inff_skb_htod_tag_get_field(skb_peek(q), FREERUN));
+		skb_unlink(p, q);
+		pq->len--;
+	}
+
+	if (pktout)
+		*pktout = p;
+
+	return 0;
+}
+
+static int inff_fws_enque_afq(struct inff_fws_info *fws, struct sk_buff *skb)
+{
+	struct inff_fws_mac_descriptor *entry;
+	u32 hslot = inff_skb_htod_tag_get_field(skb, HSLOT);
+	u32 fifo = inff_skb_htod_tag_get_field(skb, FIFO);
+
+	if (hslot < INFF_FWS_MAC_DESC_TABLE_SIZE)
+		entry = &fws->desc.nodes[hslot];
+	else if (hslot < INFF_FWS_MAC_DESC_TABLE_SIZE + INFF_MAX_IFS)
+		entry = &fws->desc.iface[hslot - INFF_FWS_MAC_DESC_TABLE_SIZE];
+	else
+		entry = &fws->desc.other;
+
+	inff_pktq_penq(&entry->afq, fifo, skb);
+
+	return 0;
+}
+
+void inff_fws_bus_blocked(struct inff_pub *drvr, bool flow_blocked)
+{
+	struct inff_fws_info *fws = drvr_to_fws(drvr);
+	struct inff_if *ifp;
+	int i;
+
+	if (fws->avoid_queueing) {
+		for (i = 0; i < INFF_MAX_IFS; i++) {
+			ifp = drvr->iflist[i];
+			if (!ifp || !ifp->ndev)
+				continue;
+			inff_net_txflowblock(ifp, INFF_NETIF_STOP_REASON_FLOW,
+					     flow_blocked);
+		}
+	} else {
+		fws->bus_flow_blocked = flow_blocked;
+		if (!flow_blocked)
+			inff_fws_schedule_deq(fws);
+		else
+			fws->stats.bus_flow_block++;
+	}
+}
+
+void inff_fws_cleanup_interface(struct inff_if *ifp)
+{
+	struct inff_fws_info *fws = drvr_to_fws(ifp->drvr);
+	struct inff_fws_mac_descriptor *entry;
+	struct inff_fws_mac_descriptor *table;
+	bool (*matchfn)(struct sk_buff *, void *) = inff_fws_ifidx_match;
+	int ifidx = ifp->ifidx;
+	int i;
+
+	if (!fws->sdio_recv_error)
+		return;
+
+	inff_fws_lock(fws);
+
+	fws->stats.cnt_cleanup_if++;
+	fws->sdio_recv_error = false;
+
+	entry = &fws->desc.iface[ifidx];
+	inff_dbg(SDIO, "iface[%d] mac %pM if %d psq len %d\n",
+		 ifidx, entry->ea, entry->interface_id, entry->psq.len);
+
+	/* cleanup interface */
+	inff_fws_psq_flush(fws, &entry->psq, ifidx);
+	if (INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_pktq_flush(&entry->afq, true, NULL, NULL);
+	inff_fws_macdesc_reset(entry);
+
+	/* cleanup individual nodes */
+	table = &fws->desc.nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++)
+		inff_fws_macdesc_cleanup(fws, &table[i], ifidx);
+
+	/* cleanup txq and hanger */
+	inff_fws_bus_txq_cleanup(fws, matchfn, ifidx);
+	if (!INFF_FWS_MODE_GET_AFQ(fws->wlfc_mode))
+		inff_fws_hanger_cleanup(fws, matchfn, ifidx);
+
+	inff_fws_unlock(fws);
+}
diff --git a/drivers/net/wireless/infineon/inffmac/fwsignal.h b/drivers/net/wireless/infineon/inffmac/fwsignal.h
new file mode 100644
index 000000000000..24ef391f531f
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/fwsignal.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_FWSIGNAL_H
+#define INFF_FWSIGNAL_H
+
+/**
+ * enum inff_fws_fifo - fifo indices used by dongle firmware.
+ *
+ * @INFF_FWS_FIFO_FIRST: first fifo, ie. background.
+ * @INFF_FWS_FIFO_AC_BK: fifo for background traffic.
+ * @INFF_FWS_FIFO_AC_BE: fifo for best-effort traffic.
+ * @INFF_FWS_FIFO_AC_VI: fifo for video traffic.
+ * @INFF_FWS_FIFO_AC_VO: fifo for voice traffic.
+ * @INFF_FWS_FIFO_BCMC: fifo for broadcast/multicast (AP only).
+ * @INFF_FWS_FIFO_ATIM: fifo for ATIM (AP only).
+ * @INFF_FWS_FIFO_COUNT: number of fifos.
+ */
+enum inff_fws_fifo {
+	INFF_FWS_FIFO_FIRST,
+	INFF_FWS_FIFO_AC_BK = INFF_FWS_FIFO_FIRST,
+	INFF_FWS_FIFO_AC_BE,
+	INFF_FWS_FIFO_AC_VI,
+	INFF_FWS_FIFO_AC_VO,
+	INFF_FWS_FIFO_BCMC,
+	INFF_FWS_FIFO_ATIM,
+	INFF_FWS_FIFO_COUNT
+};
+
+struct inff_fws_info *inff_fws_attach(struct inff_pub *drvr);
+void inff_fws_detach(struct inff_fws_info *fws);
+void inff_fws_debugfs_create(struct inff_pub *drvr);
+bool inff_fws_queue_skbs(struct inff_fws_info *fws);
+bool inff_fws_fc_active(struct inff_fws_info *fws);
+void inff_fws_hdrpull(struct inff_if *ifp, s16 siglen, struct sk_buff *skb);
+int inff_fws_process_skb(struct inff_if *ifp, struct sk_buff *skb);
+
+void inff_fws_reset_interface(struct inff_if *ifp);
+void inff_fws_add_interface(struct inff_if *ifp);
+void inff_fws_del_interface(struct inff_if *ifp);
+void inff_fws_bustxcomplete(struct inff_fws_info *fws, struct sk_buff *skb,
+			    bool success);
+void inff_fws_bus_blocked(struct inff_pub *drvr, bool flow_blocked);
+void inff_fws_rxreorder(struct inff_if *ifp, struct sk_buff *skb, bool inirq);
+void inff_fws_cleanup_interface(struct inff_if *ifp);
+void inff_creditmap_query(struct inff_fws_info *fws);
+
+#endif /* INFF_FWSIGNAL_H */
-- 
2.43.0

