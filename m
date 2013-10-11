Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42262 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab3JKLTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/5] rt2x00: add rt2x00_has_cap_* helpers
Date: Fri, 11 Oct 2013 13:18:40 +0200
Message-Id: <1381490324-14746-1-git-send-email-juhosg@openwrt.org> (sfid-20131011_131918_464219_A721A824)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00 code directly accesses the 'cap_flags'
field of 'struct rt2x00_dev' when checking presence
of a given capability flag. The direct access needs
long expressions which lowers readability of the code.

Add a few helper functions which can be used to test
device capabilities without directly accessing the
cap_flags filed.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h |   87 ++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 30ed92a..e4ba2ce 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1169,6 +1169,93 @@ static inline bool rt2x00_is_soc(struct rt2x00_dev *rt2x00dev)
 	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
 }
 
+/* Helpers for capability flags */
+
+static inline bool
+rt2x00_has_cap_flag(struct rt2x00_dev *rt2x00dev,
+		    enum rt2x00_capability_flags cap_flag)
+{
+	return test_bit(cap_flag, &rt2x00dev->cap_flags);
+}
+
+static inline bool
+rt2x00_has_cap_hw_crypto(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_HW_CRYPTO);
+}
+
+static inline bool
+rt2x00_has_cap_power_limit(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_POWER_LIMIT);
+}
+
+static inline bool
+rt2x00_has_cap_control_filters(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_CONTROL_FILTERS);
+}
+
+static inline bool
+rt2x00_has_cap_control_filter_pspoll(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_CONTROL_FILTER_PSPOLL);
+}
+
+static inline bool
+rt2x00_has_cap_pre_tbtt_interrupt(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_PRE_TBTT_INTERRUPT);
+}
+
+static inline bool
+rt2x00_has_cap_link_tuning(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_LINK_TUNING);
+}
+
+static inline bool
+rt2x00_has_cap_frame_type(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_FRAME_TYPE);
+}
+
+static inline bool
+rt2x00_has_cap_rf_sequence(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_RF_SEQUENCE);
+}
+
+static inline bool
+rt2x00_has_cap_external_lna_a(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_EXTERNAL_LNA_A);
+}
+
+static inline bool
+rt2x00_has_cap_external_lna_bg(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_EXTERNAL_LNA_BG);
+}
+
+static inline bool
+rt2x00_has_cap_double_antenna(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_DOUBLE_ANTENNA);
+}
+
+static inline bool
+rt2x00_has_cap_bt_coexist(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_BT_COEXIST);
+}
+
+static inline bool
+rt2x00_has_cap_vco_recalibration(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_has_cap_flag(rt2x00dev, CAPABILITY_VCO_RECALIBRATION);
+}
+
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @entry: Pointer to &struct queue_entry
-- 
1.7.10
