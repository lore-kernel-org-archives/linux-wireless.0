Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993058;
	b=YLPvRpcTO/8jv8c/bXo/5DanWmLATs7wPI4/s8GGUid1iKZhz649pmyW1ECTqhtK2GDm
	 ZtfgDECCueqg2a6YJXBDI972+K+rhjNdjYO/WMms0jnSbdO9rpVe3HnVaAhv6Sx0aJOag
	 xAS/QF8KR4AGm7j++1I2ka6MoYlCd7B5MqKEU5lakCVO64mawVyGnWaVUBb50RvP9VEEZ
	 wDSd1qI5eWX+dAjBTrKKpmzYUXwpsmP/hlmlyHgJXRVpyXSzTVvWJ0fhAQDxZfjP3L75V
	 tSiNvLqzufvOO+wLCPf4zjzCEP0iadRY4viXXvZeal7oTBWt1QW1YWyLwpAWzJBdoLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993058;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zsodfXTZ8d+Y9AkFsVNLE1dVFYbWR+28e5TCIgiv4EQ=;
	b=ozLq+Hx3SuQTYqttWgbAQHKJCYvVx82I4qlFxBVPakGwMbkJb9Z5+8Dn4PMR+QU6WrDr
	 OvFQ0jjqXY1YtJnn2UFgJaJexxBDNzcwtIh7vsFQMP4au45jv3Yv45nSBuXxGM/nVShmG
	 sPE09xuiGT4Ckam+qWc5iVOo/Bl6Hi7AqFyVOBSiiqyv+ECOuvUiy6MybXnnXIR/JAe2s
	 RKtdGJzSw9C3jYrl847JIBvvM2Y9jnRylj3shRlMWqyVi0nsDiUgjZJtON+UJvQXUYwS5
	 QdYaZUYlpJrhyu6DAvtbFei4oCpmMDcBJYgTPXbC42vEdckNzEwtmqDL1AXgKN/Qk8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LA72b8Kz;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFE060A5BC8
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AFE060A5BC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LA72b8Kz
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-89f28c3ac7bso764341b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993057; x=1793597857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zsodfXTZ8d+Y9AkFsVNLE1dVFYbWR+28e5TCIgiv4EQ=;
        b=LA72b8KzScxdTekq4gTZIw9VtbXSWy1Cf61p+gxcEdGrh3w8cAcLnR9ckEkdUTL5zD
         uFtUwqQoO3PfH0sT+7xZK8DGOtQ3OMJEhHgW4rjN91uaanknZgHwPBRU4gdnBNDkB5LO
         PjliSnrP0FkuCliOGcU9BGDMOgQ24B4u1nFdBYyUMXipFUdhEMKqnQPtPLpF/aZDudk0
         1cFuVuMdV+IVPO6nK/2GMKOOikdnh6r0SExNzqDwQNbNeuJNIrNgW3dwrtdc+G5H7ES9
         yAEGWrN9/cruQYk40zFV7PkRM9cqGWZua2AHVNExxScOMblVSbWTqljG0tmW+r9GYMft
         CA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993057; x=1793597857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zsodfXTZ8d+Y9AkFsVNLE1dVFYbWR+28e5TCIgiv4EQ=;
        b=GKWZSFA1klJ13F4AJvoEOTNxwnMtAgUgfAW14eeHlOokRWVs062E7AY7GS7ReUNvQU
         wkC9hXELUA3s2w1TzHY6seRTJXnUvISVtCKfHFVQRAQG2pzUrq4XPlqWWPcTHFRNN9hk
         mUThK98LtCWxuYgWnDVg3qGZ6fCz9gLUZFkjl2GYlAKaZEFNJzw3D4uZ0Zft5Uc6H31S
         RHnipmP8oUDZUO4IjRFNE0JOWBrfPtF9zBoWj+octZLx4dxPZ9atAUN5qBRoihnCC6o3
         UHkjh0xWAp/IMIpnJ5IC5RmXFaVw46V6YyGBfekCYaJpsenlwWov7XUpsUcdwb0zm7En
         UMQw==
X-Gm-Message-State: AFq9FYJfzMoszqHwQeiKiWb2AzF7zRMb3OqwX3I1Rsp01TdnSaz4CZxd
	iUxY8Yc05n6jACyjSaAB36J0KyaLd017GF+2QkUkWYOS9fUvZzvuFNf1sC7+D+h/JSB1cg==
X-Gm-Gg: AYBFou0fJaZxt8xFLwqy2moTtf1AXRpQjUY3sPO8lsjLxy2sk5wyt5W6rAEmLUGW28g
	h5Op3Ch5lYLTBirXtNey2hQoS5DydVq8p9M76VcYoaqfePT31THCNugUZH9wK1NTr5eXawjVAqJ
	hZ9cJA2qfFSKSY51qhWkx9qLFDu07fHU4bG/53nHQjDwo0elLEblc1OU0j/tbFGdVlIdkoNaXaO
	S2jRg3+dpeAumhKTApHIv/5aBSear3RU48JFg5ih0mKhSVIhJLWtVJiVdw5nm18YyCtHK3C17mC
	ft7/Gs/VMtlixTM0G8UUkNT5RUY9DXWfNprmeNeBSvRHia7lku5avi9HfdV62j4xB3cMIEb1xXt
	joOiBpkB4S0gQfm653EMl9KDloeEYJRmMNDq1fgWIlkFZLn3fvylftuukptsuRH4jaGrrw7os/q
	DAEzE3t73J4Cv5X9nCqf5hv4z+/z1H2VWI7ShBfrKxK8XBcQHjOA+RW9w+Qr2k2HkG040fEsEWs
	hgLyid735To9tdnnd5w+mdWTq2J1Nu2ZKeXKOk3x+luj3OaW28gn1rsN3EJBzsc4X2CZa8ixqCR
	22f7
X-Received: by 2002:a05:6a00:2448:b0:898:9b2:605b with SMTP id d2e1a72fcca58-8a367a2f710mr4800290b3a.56.1792993057378;
        Sun, 25 Oct 2026 22:37:37 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:37 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 13/17] wifi: bcm4323x: add the receive path
Date: Mon, 26 Oct 2026 13:36:19 +0800
Message-ID: <20261026053633.361454-14-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

Add the RX path of the device. RX supports RX aggregation.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/bcm4323x/bcm4323x_rx.c | 317 ++++++++++++++++++
 1 file changed, 317 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_rx.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_rx.c b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_rx.c
new file mode 100644
index 000000000..8f5b3e01f
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_rx.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "bcm4323x.h"
+
+#define BCM4323X_RPC_PROC_RX 0x51
+#define BCM4323X_RPC_PROC_TX_STATUS 0x52
+#define BCM4323X_RPC_PROC_NOISE_RESULT 0x66
+
+struct bcm4323x_handshake_reply {
+	__le32 version;
+	__le32 state;
+	__le32 chip;
+} __packed;
+
+/* Procedure 0x51 */
+struct bcm4323x_rxhdr {
+	/* The length of the body up to the end of the frame, without its FCS */
+	__le32 length;
+	/* from brcmfmac: struct wlc_d11rxhdr */
+	struct d11rxhdr_le rxhdr;
+	__le32 tsf_l;
+	s8 rssi;
+	u8 reserved0[3];
+	s8 rxpwr0;
+	s8 rxpwr1;
+	u8 reserved1[4];
+} __packed;
+
+/* Procedure 0x66 */
+struct bcm4323x_noise {
+	__le32 channel;
+	__le32 dbm;
+} __packed;
+
+#define BCM4323X_RX_FRAME_OFFSET (sizeof(struct bcm4323x_rxhdr) + D11_PHY_HDR_LEN)
+
+/* Verify the receive frame key slot matches */
+static bool bcm4323x_rx_key_match(struct bcm4323x *dev, struct sk_buff *skb, unsigned int index)
+{
+	const struct ieee80211_hdr *hdr = (void *)skb->data;
+	bool multicast;
+	bool group_slot;
+	const u8 *frame_bssid;
+	struct ieee80211_vif *vif;
+	const u8 *bssid;
+	bool addressed;
+
+	if (ieee80211_get_hdrlen_from_skb(skb) < sizeof(struct ieee80211_hdr_3addr) ||
+	    !ieee80211_has_protected(hdr->frame_control) || index >= BCM4323X_HW_KEYS)
+		return false;
+	/* A group key takes the slot of its key ID, below the pairwise keys. */
+	multicast = is_multicast_ether_addr(hdr->addr1);
+	group_slot = index < BCM4323X_HW_PAIRWISE_BASE;
+	if (multicast != group_slot)
+		return false;
+
+	rcu_read_lock();
+	vif = rcu_dereference(dev->active_vif);
+	if (!vif) {
+		addressed = false;
+	} else if (multicast) {
+		/* An interface type change can repoint it. */
+		bssid = READ_ONCE(vif->bss_conf.bssid);
+		frame_bssid = ieee80211_get_bssid((void *)skb->data, skb->len, vif->type);
+		addressed = frame_bssid && bssid && ether_addr_equal(frame_bssid, bssid);
+	} else {
+		addressed = ether_addr_equal(hdr->addr1, vif->addr);
+	}
+	rcu_read_unlock();
+	if (!addressed)
+		return false;
+
+	/* bcm4323x_set_key() sets the peer before it puts the slot in use. */
+	if (!test_bit_acquire(index, dev->keys))
+		return false;
+	return multicast || ether_addr_equal(hdr->addr2, dev->key_peers[index]);
+}
+
+/* from brcmsmac: prep_mac80211_status */
+static void bcm4323x_set_rx_rate(struct bcm4323x *dev, struct ieee80211_rx_status *status,
+				 const u8 *body, unsigned int frame_offset)
+{
+	const struct bcm4323x_rxhdr *hdr = (const void *)body;
+	const struct ieee80211_supported_band *sband = &dev->bands[status->band];
+	struct d11rxhdr rxh = {
+		.PhyRxStatus_0 = le16_to_cpu(hdr->rxhdr.PhyRxStatus_0),
+		.RxChan = le16_to_cpu(hdr->rxhdr.RxChan),
+	};
+	u8 *plcp = (u8 *)body + frame_offset - D11_PHY_HDR_LEN;
+	unsigned int i;
+	u32 rspec;
+
+	if ((rxh.PhyRxStatus_0 & PRXS0_FT_MASK) == PRXS0_PREN) {
+		if (plcp[0] || plcp[1] || plcp[2])
+			memcpy(dev->rx_ht_plcp, plcp, sizeof(dev->rx_ht_plcp));
+		plcp = dev->rx_ht_plcp;
+	}
+	rspec = brcmu_compute_rspec(&rxh, plcp);
+	if (is_mcs_rate(rspec)) {
+		status->encoding = RX_ENC_HT;
+		status->rate_idx = rspec & RSPEC_RATE_MASK;
+		if (status->rate_idx >= BCM4323X_NUM_MCS)
+			status->rate_idx = 0;
+		if (rspec_is40mhz(rspec))
+			status->bw = RATE_INFO_BW_40;
+		if (rspec_issgi(rspec))
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+		/* The HT-SIG byte has the STBC field where plcp3_issgi() finds SGI. */
+		status->enc_flags |= rspec_stc(plcp[3] << 16) << RX_ENC_FLAG_STBC_SHIFT;
+		return;
+	}
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (sband->bitrates[i].hw_value == rspec2rate(rspec)) {
+			status->rate_idx = i;
+			break;
+		}
+	if (is_cck_rate(rspec) && (rxh.PhyRxStatus_0 & PRXS0_SHORTH))
+		status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
+}
+
+static unsigned int bcm4323x_rx_frame_offset(const struct bcm4323x_rxhdr *hdr)
+{
+	if (le16_to_cpu(hdr->rxhdr.RxStatus1) & RXS_PBPRES)
+		return BCM4323X_RX_FRAME_OFFSET + sizeof(__le16);
+	return BCM4323X_RX_FRAME_OFFSET;
+}
+
+/* Whether a procedure 0x51 body holds a whole frame, on a channel of the device */
+static bool bcm4323x_rx_valid(struct bcm4323x *dev, const u8 *body, size_t body_length)
+{
+	const struct bcm4323x_rxhdr *hdr = (const void *)body;
+	unsigned int frame_size;
+	unsigned int channel;
+
+	if (body_length < BCM4323X_RX_FRAME_OFFSET + sizeof(__le32))
+		return false;
+	frame_size = le32_to_cpu(hdr->length);
+	if (ALIGN(frame_size + sizeof(__le32), sizeof(__le32)) > body_length ||
+	    frame_size <= bcm4323x_rx_frame_offset(hdr))
+		return false;
+	channel = le16_get_bits(hdr->rxhdr.RxChan, RXS_CHAN_ID_MASK);
+	if (le16_to_cpu(hdr->rxhdr.RxChan) & RXS_CHAN_5G)
+		return channel && dev->chip->has_5ghz && channel <= 196;
+	return channel && channel <= BCM4323X_NUM_2GHZ_CHANNELS;
+}
+
+/*
+ * from brcmsmac: wlc_phy_chanspec_set, which gives the microcode the center of
+ * a 40 MHz channel, while mac80211 expects the control channel
+ *
+ * Returns 0 for a frame received before a switch.
+ */
+static unsigned int bcm4323x_rx_channel(struct bcm4323x *dev, const struct d11rxhdr_le *rxh)
+{
+	unsigned int channel = le16_get_bits(rxh->RxChan, RXS_CHAN_ID_MASK);
+	u16 chanspec;
+
+	if (!(le16_to_cpu(rxh->RxChan) & RXS_CHAN_40))
+		return channel;
+	chanspec = READ_ONCE(dev->chanspec);
+	if (!CHSPEC_IS40(chanspec) || CHSPEC_CHANNEL(chanspec) != channel)
+		return 0;
+	return CHSPEC_CTL_CHAN(chanspec);
+}
+
+/* from brcmsmac: brcms_c_recv, prep_mac80211_status */
+static void bcm4323x_rx_80211(struct bcm4323x *dev, const u8 *body, size_t body_length)
+{
+	const struct bcm4323x_rxhdr *hdr = (const void *)body;
+	const struct d11rxhdr_le *rxh = &hdr->rxhdr;
+	unsigned int frame_offset;
+	unsigned int frame_length;
+	unsigned int rx_status1;
+	unsigned int channel;
+	struct sk_buff *skb;
+	struct ieee80211_rx_status *status;
+
+	if (!READ_ONCE(dev->running))
+		return;
+	if (!bcm4323x_rx_valid(dev, body, body_length)) {
+		dev_dbg_ratelimited(&dev->intf->dev, "malformed procedure 0x51 body (%zu bytes)\n",
+				    body_length);
+		return;
+	}
+	channel = bcm4323x_rx_channel(dev, rxh);
+	if (!channel)
+		return;
+
+	frame_offset = bcm4323x_rx_frame_offset(hdr);
+	frame_length = le32_to_cpu(hdr->length) - frame_offset;
+	/* Aligns the IP header of QoS data, which mac80211 would otherwise move. */
+	skb = dev_alloc_skb(frame_length + 2);
+	if (!skb)
+		return;
+	skb_reserve(skb, 2);
+	skb_put_data(skb, body + frame_offset, frame_length);
+
+	status = IEEE80211_SKB_RXCB(skb);
+	status->band = le16_to_cpu(rxh->RxChan) & RXS_CHAN_5G ? NL80211_BAND_5GHZ :
+								NL80211_BAND_2GHZ;
+	status->freq = ieee80211_channel_to_frequency(channel, status->band);
+	bcm4323x_set_rx_rate(dev, status, body, frame_offset);
+	/* PHY status is valid only on the last subframe of an A-MPDU. */
+	if ((le16_to_cpu(rxh->RxStatus2) & RXS_PHYRXST_VALID) && hdr->rssi < 0) {
+		status->signal = hdr->rssi;
+		status->chains = BCM4323X_ANTENNAS;
+		status->chain_signal[0] = hdr->rxpwr0;
+		status->chain_signal[1] = hdr->rxpwr1;
+	} else {
+		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+	}
+	rx_status1 = le16_to_cpu(rxh->RxStatus1);
+	if (rx_status1 & RXS_FCSERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	/* Only accept hw decrypted frame if it isn't corrupted */
+	if ((rx_status1 & RXS_DECATMPT) && !(rx_status1 & RXS_DECERR) &&
+	    bcm4323x_rx_key_match(dev, skb, FIELD_GET(RXS_SECKINDX_MASK, rx_status1)))
+		status->flag |= RX_FLAG_DECRYPTED;
+	ieee80211_rx_irqsafe(dev->hw, skb);
+}
+
+static void bcm4323x_handle_handshake_reply(struct bcm4323x *dev, const u8 *body,
+					    size_t body_length)
+{
+	const struct bcm4323x_handshake_reply *reply = (const void *)body;
+
+	dev->handshake_chip = 0;
+	if (body_length == sizeof(*reply) && le32_to_cpu(reply->version) == BCM4323X_RPC_VERSION)
+		dev->handshake_chip = reply->chip;
+	complete(&dev->handshake_done);
+}
+
+static void bcm4323x_rx_noise(struct bcm4323x *dev, const u8 *body, size_t body_length)
+{
+	const struct bcm4323x_noise *noise = (const void *)body;
+	u32 channel;
+	s32 dbm;
+	unsigned int i;
+
+	if (body_length < sizeof(*noise))
+		return;
+	/* Channels above 0x7F are presented as sign-extended */
+	channel = le32_to_cpu(noise->channel) & 0xff;
+	dbm = le32_to_cpu(noise->dbm);
+	if (dbm >= 0 || dbm < S8_MIN)
+		return;
+	for (i = 0; i < BCM4323X_NUM_CHANNELS; i++)
+		if (dev->channels[i].hw_value == channel) {
+			WRITE_ONCE(dev->noise[i], dbm);
+			break;
+		}
+}
+
+static void bcm4323x_handle_runtime_frame(struct bcm4323x *dev, const u8 *frame, size_t length)
+{
+	const struct bcm4323x_rpc_header *rpc = (const void *)frame;
+	u8 rpc_class = FIELD_GET(BCM4323X_RPC_CLASS_MASK, le32_to_cpu(rpc->xid_class));
+	u32 procedure = le32_to_cpu(rpc->procedure);
+	const u8 *body = frame + sizeof(*rpc);
+	size_t body_length = length - sizeof(*rpc);
+
+	if (rpc_class == BCM4323X_RPC_CLASS_TRANSPORT) {
+		if (procedure == BCM4323X_RPC_PROC_VERSION ||
+		    procedure == BCM4323X_RPC_PROC_CHIP_ACK)
+			bcm4323x_handle_handshake_reply(dev, body, body_length);
+	} else if (rpc_class == BCM4323X_RPC_CLASS_DATA) {
+		switch (procedure) {
+		case BCM4323X_RPC_PROC_RX:
+			bcm4323x_rx_80211(dev, body, body_length);
+			break;
+		case BCM4323X_RPC_PROC_TX_STATUS:
+			bcm4323x_tx_status(dev, body, body_length);
+			break;
+		case BCM4323X_RPC_PROC_NOISE_RESULT:
+			bcm4323x_rx_noise(dev, body, body_length);
+			break;
+		}
+	}
+}
+
+void bcm4323x_rx_complete(struct urb *urb)
+{
+	struct bcm4323x *dev = urb->context;
+	u8 *cursor = urb->transfer_buffer;
+	size_t remaining = urb->actual_length;
+	int ret = 0;
+
+	/* Errors on explicit stops don't need an error print */
+	if (urb->status == -ENOENT || urb->status == -ECONNRESET || urb->status == -ESHUTDOWN)
+		return;
+	if (urb->status) {
+		dev_err_ratelimited(&dev->intf->dev, "RX URB failed: %d\n", urb->status);
+		bcm4323x_fatal_error(dev);
+		return;
+	}
+
+	/* RPC frames don't split across transfers */
+	while (remaining) {
+		const struct bcm4323x_rpc_header *rpc = (const void *)cursor;
+		u32 length = remaining < sizeof(*rpc) ? 0 :
+			     le32_to_cpu(rpc->length) + sizeof(rpc->length);
+
+		if (length < sizeof(*rpc) || length > remaining) {
+			dev_warn_ratelimited(&dev->intf->dev, "invalid RX RPC length %u of %zu\n",
+					     length, remaining);
+			break;
+		}
+		bcm4323x_handle_runtime_frame(dev, cursor, length);
+		cursor += length;
+		remaining -= length;
+	}
+	if (!READ_ONCE(dev->dead))
+		ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret && ret != -EPERM)
+		dev_warn_ratelimited(&dev->intf->dev, "RX URB left idle: %d\n", ret);
+}
-- 
2.53.0

