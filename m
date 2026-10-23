Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792778765;
	b=OdVjdhVI/yYnElEeyzVm2zHXP1Y6ps64ZvNYtcej8cp+/Z9EctYCHJH5IOm4lStB4cuo
	 A24BrjYvGWdXjvzYzNOahrNAAqXmIWORCGWLjtbglhV0c7GWHBOu65DL1vlgGNo9YeJ6G
	 VkVS9lVTnsXjBl1ZHJvGIyaYys6zdW5Gm/XEP10Haudg7u/JXeBTrAPVXYQ2enCAjF31n
	 iX/eRQDm0wFXZHRdWPLUQADhExMXWXz4RDvHiCXHX2CSE20dzjknCSEk42ZAjZ+MbxIwo
	 rlh7S8jY5HvgLA63DnHB7FqfQZmTbq7W4k5UWsj2mWfEv6kD/FlLv9/R4X2o6/oxnmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792778765;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YIcgysXfPYSKDSVTUAoOuqEBH5LwuWfcVmo3HJUW2uQ=;
	b=kuPh996YMzwsam2vLIk0EkWw7g3oa6N+nU777ZIqDtjGn7hEG3hZN74k43Q4CCiSRZw2
	 i2rnxzsIx8pjLdO3TN+jBPi10AvbOpQZAgWwhI2CO8uyEBf44fBT/U6KzLYq2/27rzkHk
	 dJAnYECMV2z1hHPmAwy0nQa4otf86FRPaj8TncxEOiAfrON8daRkaBqljUXI+E3xLhPjw
	 zHHIu2Q4Bfiv8y059mD37kYJe0xQ2/DjUM8OK3X1lcDAmT7jCzLqgTi22He7q+pB3ATCs
	 Yex3b9e71Nd2YpVSoqZ66yRcuOmKW1CCuscQCpx7GS4Rq+fVK6o5cMkhcMpaWQmzCvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=QWF+Skce;
	arc=none smtp.remote-ip=91.218.175.86
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2598F606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 18:06:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2598F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=QWF+Skce
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wdVvQpPpBRbGyvkvJpDfc4Jb1sOZo/1jzcPqAV19YoA=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792778762; v=1; x=1793383562;
 b=QWF+SkceuNnGW/WaJpouxWLbo3L+wdzJqKy4LmBRnUsB99L2ydG1XnyKaA3EQbRVmKf0Q7Pb
 TwBjTg9yrgso1db9qp0+4IrRU8aPRmUKDjxHC4Hsk+0FDD0K54dyt4EIO1va4Q3dlKEK5OcASpC
 OLa97knFb64Vl+OXmcdb04k80AkD7IWoqFAd3n2npcXX5BhsS1E8BaRvePNqN9YCC95TWU2EuoU
 TzpKXXKFYxZ8nZWiHF5DHJu/DH2emED3zaZEunwCOUMUlyyvOknNkNGho8TgDjoi++ElZzDTks8
 5BC3+mT8QETArDRKRnEe9IiqL7RvCWByHtXCAWxlUJAbQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4410137d7d7234ff;
	Fri, 23 Oct 2026 18:06:02 +0000
X-Mizu-Trace-ID: 4410137d7d7234ff
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Chris Kelly <hoopyfrood42@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [RFC PATCH wireless] wifi: mt76: mt7925: get the survey airtime from the firmware
Date: Fri, 23 Oct 2026 11:05:54 -0700
Message-ID: <20261023180554.7266-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
References: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Busy time in the mt7925 survey is bogus. The register it comes from
doesn't work on this chip, so every update adds the same large number
and busy time soon outgrows the time spent on the channel. Transmit
and receive time come out far too low as well.

Ask the firmware for all three instead, the way mt7996 does.

The MT7927 counts 5 and 6 GHz on a second band that the survey never
read, so read both bands there and only add the one the channel is on.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Fixes: 05fd14885303 ("wifi: mt76: mt7925: sync MT7927 BSS band assignment")
Reported-by: Chris Kelly <hoopyfrood42@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com/
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Chris, here's the RFC you asked about. Busy time now follows the load
and stays under the time on the channel, hopping every half second too.

It's an RFC because the offsets aren't documented. On an A9000:

  19  busy time, including the card's own transmit
  20  receive time
  28  transmit time

The MT7927 counts 5 and 6 GHz on a second band, which keeps counting
while unused, so only the band in use is added.

Busy as a share of time on the channel, A9000 on 2.4 GHz next to an
MT7921AU:

               before    after    MT7921AU
  idle         4229%     4.2%     1.4%
  100 Mbit/s   4317%     37.3%    33.7%
  saturated    4346%     79.5%    77.4%

Tested on the A9000 (Arch 6.18 and 7.2, Ubuntu 7.3, wireless-next with
lockdep) and on a PCIe MT7925 and MT7927 (Fedora 7.2). mt7921 keeps its
registers, which work on my MT7921AU.

Could you try it on your A9000 against the Wi-Spy?

 .../net/wireless/mediatek/mt76/mt7925/mac.c   | 42 +++++++++++
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  1 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 70 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   | 17 +++++
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  3 +
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 8 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 7af996abe294..4ec3712fe614 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1470,6 +1470,48 @@ void mt7925_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 }
 EXPORT_SYMBOL_GPL(mt7925_queue_rx_skb);
 
+void mt7925_mac_update_chan_time(struct mt792x_phy *phy, bool reset)
+{
+	struct ieee80211_channel *chan = phy->mt76->chandef.chan;
+	struct mt76_channel_state *state = phy->mt76->chan_state;
+	struct mt792x_dev *dev = phy->dev;
+	int i, n_bands = 1, band = 0;
+
+	/* The MT7927 counts 2.4 GHz on band 0 and 5/6 GHz on band 1, and
+	 * the band not in use keeps counting, so read both every time and
+	 * only add the band the channel is on.
+	 */
+	if (is_mt7927(&dev->mt76)) {
+		n_bands = ARRAY_SIZE(phy->state_ts);
+		if (chan)
+			band = mt7927_band_idx(chan->band);
+	}
+
+	for (i = 0; i < n_bands; i++) {
+		bool add = !reset && i == band;
+		u32 bss_rx;
+
+		bss_rx = mt76_get_field(dev, MT_MIB_SDR37(i),
+					MT_MIB_SDR37_RXTIME_MASK);
+		if (add)
+			state->cc_bss_rx += bss_rx;
+
+		mt7925_mcu_get_chan_mib_info(phy, i, add);
+	}
+}
+
+void mt7925_update_channel(struct mt76_phy *mphy)
+{
+	struct mt792x_dev *dev = container_of(mphy->dev, struct mt792x_dev, mt76);
+
+	if (mt76_connac_pm_wake(mphy, &dev->pm))
+		return;
+
+	mt7925_mac_update_chan_time(mphy->priv, false);
+	mt76_connac_power_save_sched(mphy, &dev->pm);
+}
+EXPORT_SYMBOL_GPL(mt7925_update_channel);
+
 static void
 mt7925_vif_connect_iter(void *priv, u8 *mac,
 			struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 22cc5b49da0a..393c225c19e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -351,6 +351,7 @@ int __mt7925_start(struct mt792x_phy *phy)
 		return err;
 
 	mt792x_mac_reset_counters(phy);
+	mt7925_mac_update_chan_time(phy, true);
 	set_bit(MT76_STATE_RUNNING, &mphy->state);
 
 	ieee80211_queue_delayed_work(mphy->hw, &mphy->mac_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index f299a3379adb..b741a4880cfe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1057,6 +1057,76 @@ int mt7925_mcu_get_temperature(struct mt792x_phy *phy)
 	return temperature;
 }
 
+int mt7925_mcu_get_chan_mib_info(struct mt792x_phy *phy, u8 band, bool add)
+{
+	enum {
+		IDX_BUSY_TIME,
+		IDX_TX_TIME,
+		IDX_RX_TIME,
+		IDX_NUM
+	};
+	struct {
+		struct {
+			u8 band;
+			u8 __rsv[3];
+		} hdr;
+		struct {
+			__le16 tag;
+			__le16 len;
+			__le32 offs;
+		} data[IDX_NUM];
+	} __packed req = {
+		.hdr.band = band,
+	};
+	static const u32 offs[] = {
+		[IDX_BUSY_TIME] = UNI_MIB_BUSY_TIME,
+		[IDX_TX_TIME] = UNI_MIB_TX_TIME,
+		[IDX_RX_TIME] = UNI_MIB_RX_TIME,
+	};
+	struct mt76_channel_state *state = phy->mt76->chan_state;
+	struct mt76_channel_state *state_ts = &phy->state_ts[band];
+	struct mt792x_dev *dev = phy->dev;
+	struct mt7925_mcu_mib *res;
+	struct sk_buff *skb;
+	int i, ret;
+
+	for (i = 0; i < IDX_NUM; i++) {
+		req.data[i].tag = cpu_to_le16(UNI_CMD_MIB_DATA);
+		req.data[i].len = cpu_to_le16(sizeof(req.data[i]));
+		req.data[i].offs = cpu_to_le32(offs[i]);
+	}
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_WM_UNI_CMD_QUERY(GET_MIB_INFO),
+					&req, sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+	if (skb->len < sizeof(req.hdr) + IDX_NUM * sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	skb_pull(skb, sizeof(req.hdr));
+	res = (struct mt7925_mcu_mib *)skb->data;
+
+	if (!add)
+		goto out;
+
+#define __res_u64(s) le64_to_cpu(res[s].data)
+	state->cc_busy += __res_u64(IDX_BUSY_TIME) - state_ts->cc_busy;
+	state->cc_tx += __res_u64(IDX_TX_TIME) - state_ts->cc_tx;
+	state->cc_rx += __res_u64(IDX_RX_TIME) - state_ts->cc_rx;
+out:
+	state_ts->cc_busy = __res_u64(IDX_BUSY_TIME);
+	state_ts->cc_tx = __res_u64(IDX_TX_TIME);
+	state_ts->cc_rx = __res_u64(IDX_RX_TIME);
+#undef __res_u64
+
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
 static void
 mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 11f9eac13ffc..f3e892dbb74c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -57,6 +57,23 @@ struct mt7925_mcu_reg_event {
 	__le32 val;
 } __packed;
 
+enum {
+	UNI_CMD_MIB_DATA,
+};
+
+enum {
+	UNI_MIB_BUSY_TIME = 19,
+	UNI_MIB_RX_TIME = 20,
+	UNI_MIB_TX_TIME = 28,
+};
+
+struct mt7925_mcu_mib {
+	__le16 tag;
+	__le16 len;
+	__le32 offs;
+	__le64 data;
+} __packed;
+
 struct mt7925_mcu_ant_id_config {
 	u8 ant_id[4];
 } __packed;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 636efe038392..706e67e8ec42 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -375,6 +375,9 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 			      struct ieee80211_chanctx_conf *ctx);
 int mt7925_mcu_get_temperature(struct mt792x_phy *phy);
+int mt7925_mcu_get_chan_mib_info(struct mt792x_phy *phy, u8 band, bool add);
+void mt7925_mac_update_chan_time(struct mt792x_phy *phy, bool reset);
+void mt7925_update_channel(struct mt76_phy *mphy);
 
 int mt7925_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				   enum mt76_txq_id qid, struct mt76_wcid *wcid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 0d477dc1086c..939a46c0428b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -604,7 +604,7 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 		.sta_add = mt7925_mac_sta_add,
 		.sta_event = mt7925_mac_sta_event,
 		.sta_remove = mt7925_mac_sta_remove,
-		.update_survey = mt792x_update_channel,
+		.update_survey = mt7925_update_channel,
 	};
 	static const struct mt792x_hif_ops mt7925_pcie_ops = {
 		.init_reset = mt7925e_init_reset,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index f97f787b2198..2d3bf035fdfc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -174,7 +174,7 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 		.sta_add = mt7925_mac_sta_add,
 		.sta_event = mt7925_mac_sta_event,
 		.sta_remove = mt7925_mac_sta_remove,
-		.update_survey = mt792x_update_channel,
+		.update_survey = mt7925_update_channel,
 	};
 	static const struct mt792x_hif_ops hif_ops = {
 		.mcu_init = mt7925u_mcu_init,
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index a7d71e007da0..3ee513258d00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -221,6 +221,7 @@ struct mt792x_phy {
 	u32 ampdu_ref;
 
 	struct mt76_mib_stats mib;
+	struct mt76_channel_state state_ts[2];
 
 	u8 sta_work_count;
 	u8 clc_chan_conf;
-- 
2.56.0

