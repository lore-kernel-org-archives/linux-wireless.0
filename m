Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609556;
	b=uTSQrc87CD/uFsBtdnBLXz2v0G4dQ9LO4B2/PYX9dn81mrYoLGAc/VgmEattkBmAsqYd
	 +rWoJFnC80HVzL+C6HYVESMJTTPWkM2fgvthEnAV4f4j6eHLcgWLSo8vEUTcAypkp28+j
	 5/q+WmJtAGpmH8eiCecxldHLJgyt/UOMi5kG9j9Z9oBHPuq50dDYOi+WRjS+RWi1jGwx7
	 Pw0P0ySoubCvu0WilFThR406HNtQuMksBBTKF1AvDvTw1JxD7tCNHv5uUjWfIb7sHfg0d
	 20k9SUB2nz8p4t6ELi6p4mR+0g+WxIe1lrDHrlaCKL7WTK3ZrGQkkgzG9/LYwQJfuPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609556;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3H3vpuZZ4HqMQCRXxHkkvT/zu72qFQBhAtmWm3YosP0=;
	b=ZWQMa9/wusFWmcjC3eWlVnGaawyQaSFKxVT85+elkftfVY31ZgqJR0waCT5f3MFdMDSQ
	 gVE45tLfrS4VOUwuDvigL8e/Y5UHuWgqKiBDvKC+Gy9uT8U8KAmK8TuUiQGrv9RXg66Jq
	 61itRq0qCMFB/HPt6FGBTym8bDkt1gU+q4bpXuTYMT+tXz6Pdv8qXwc9ZMPfJQoVdEW+s
	 Ri7trIHXJHKJV9IzrhCyAsfzuwOYP8Rsj0A3o6z68eRSEjvbYbtZh0eedFUU0gKbGLrIE
	 DXetkcLuaexFSs4mjwwnr/4K5jwFB/TBLb9hU5id7nODVJkWJKjL04hwrnb+z9StIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b="hQl+F/r+";
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32304606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32304606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=hQl+F/r+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609554;
	bh=MWMSXV0WGBKU79bFpGaNmVqHfpucF9NPTI1wkDGRn6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQl+F/r+WvUkmxxLjNKbXZ6LDp5CWgj0k44RJ9XBLi2DytU0GNTkc2XenH6QLR/hr
	 5Zd9Degw8/QP0rb9fq3tvPwmakcLcCse3RTOuvAHgIwzjSSoyBq/sm4mhxbhyIT66p
	 +X3P1gQ/OZ9OZfPIEAQqQABne08HqB7XlBnpqHMROdRZVZf7UT4CTb4+1hugp7edKb
	 t8zKcNLuLtikIQNdsCTXB+Vmi7VX265m/WtCjTuztca7hxiuKMFXqy+9koOyFDD2oW
	 cmxo+6yzd1+/sAauLVg6QHdL+kp8sUNZTPY225S1JQot+rl8eDIy1iNEjZtpXiFHVx
	 cs3Kd2Xx4xOQQ==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2996217E04AB;
	Wed, 21 Oct 2026 21:05:54 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: [RFC PATCH rtw-next 2/5] wifi: rtw88: report and optionally re-verify suspect hw-decrypted frames
Date: Wed, 21 Oct 2026 20:05:21 +0100
Message-ID: <20261021190529.3893821-3-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021190529.3893821-1-bob.beckett@collabora.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
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

From: Robert Beckett <bob.beckett@collabora.com>

Debug aid for the 8822CE 5 GHz replay-counter poisoning reported in
https://lore.kernel.org/linux-wireless/20261016191100.1781056-1-bob.beckett@collabora.com/

Some 8822CE devices occasionally deliver a frame whose RX descriptor and
802.11 header are valid but whose remaining bytes, including the
cleartext CCMP header, are not that frame's, while the descriptor still
reports a successful hardware decryption. mac80211 then stores the
garbage PN as the key's last PN and drops every later frame as a replay
until the next rekey. "wifi: rtw88: do not trust a claimed decryption"
catches frames whose CCMP header is malformed, but not those where only
the PN bytes are garbage.

Track the highest PN seen per transmitter and unicast/group key for
hardware-decrypted AES data frames, reset on every key change, and treat
a frame whose PN is more than 2^24 beyond it as suspect. The transmitter
uses one PN counter per key for all TIDs, so a genuine frame on any TID
cannot get that far ahead, however long that TID was idle, while a frame
with garbage after the header carries a random 48-bit PN. A suspect PN
never becomes the reference. Suspect frames, and frames
rejected for a malformed CCMP header, are always reported with a dump of
the RX descriptor and the start of the frame (the first 20 in full, then
rate limited), so field logs show whether and how often this happens.

By default nothing else changes. With rtw88_core.sw_decrypt_suspect=Y
(also writable at runtime in /sys/module/rtw88_core/parameters/) a
suspect frame is handed to mac80211 without RX_FLAG_DECRYPTED, so it is
verified in software and dropped on MIC failure without moving the
replay counter.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c |   3 +
 drivers/net/wireless/realtek/rtw88/main.c     |   4 +
 drivers/net/wireless/realtek/rtw88/main.h     |  17 +++
 drivers/net/wireless/realtek/rtw88/rx.c       | 118 ++++++++++++++++++
 4 files changed, 142 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 766f22d31079..d5228e36fca9 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -558,6 +558,9 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 hw_key_idx;
 	int ret = 0;
 
+	/* new keys restart the PN sequences rtw_rx_pn_guard() tracks */
+	atomic_inc(&rtwdev->rx_pn_guard_gen);
+
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		hw_key_type = RTW_CAM_WEP40;
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cd9254370fcc..d667e7452e4f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -34,14 +34,18 @@ EXPORT_SYMBOL(rtw_debug_mask);
  * there is a tough reason to maintain rtw_edcca_enabled by device.
  */
 bool rtw_edcca_enabled = true;
+bool rtw_sw_decrypt_suspect;
 
 module_param_named(disable_lps_deep, rtw_disable_lps_deep_mode, bool, 0644);
 module_param_named(support_bf, rtw_bf_support, bool, 0644);
 module_param_named(debug_mask, rtw_debug_mask, uint, 0644);
+module_param_named(sw_decrypt_suspect, rtw_sw_decrypt_suspect, bool, 0644);
 
 MODULE_PARM_DESC(disable_lps_deep, "Set Y to disable Deep PS");
 MODULE_PARM_DESC(support_bf, "Set Y to enable beamformee support");
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
+MODULE_PARM_DESC(sw_decrypt_suspect,
+		 "Set Y to have mac80211 verify hardware-decrypted frames whose CCMP PN jumps implausibly (default: only report them)");
 
 static struct ieee80211_channel rtw_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 9c0b746540b0..49f13034db4d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -43,6 +43,7 @@
 extern bool rtw_bf_support;
 extern bool rtw_disable_lps_deep_mode;
 extern unsigned int rtw_debug_mask;
+extern bool rtw_sw_decrypt_suspect;
 extern bool rtw_edcca_enabled;
 extern const struct ieee80211_ops rtw_ops;
 
@@ -637,6 +638,20 @@ struct rtw_tx_pkt_info {
 	bool bt_null;
 };
 
+/* Suspect frames reported in full; later ones get rate-limited one-liners */
+#define RTW_RX_PN_GUARD_DUMPS	20
+
+/* Highest CCMP PN seen per [group-addressed] key for hardware-decrypted
+ * data frames, see rtw_rx_pn_guard().
+ */
+struct rtw_rx_pn_guard {
+	u64 pn[2];
+	u8 ta[2][ETH_ALEN];
+	bool valid[2];
+	u32 gen;
+	u32 events;
+};
+
 struct rtw_rx_pkt_stat {
 	bool phy_status;
 	bool icv_err;
@@ -2069,6 +2084,8 @@ struct rtw_dev {
 	struct rtw_fw_state fw;
 	struct rtw_efuse efuse;
 	struct rtw_sec_desc sec;
+	struct rtw_rx_pn_guard rx_pn_guard;
+	atomic_t rx_pn_guard_gen;
 	struct rtw_traffic_stats stats;
 	struct rtw_regd regd;
 	struct rtw_bf_info bf_info;
diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index e292b060ac31..7e6b0022ad50 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -280,6 +280,119 @@ static bool rtw_rx_ccmp_hdr_valid(struct rtw_rx_pkt_stat *pkt_stat,
 	return iv[2] == 0 && (iv[3] & BIT(5));
 }
 
+/* A forward PN jump this large between two frames of one key/TID is not
+ * plausible; frames with garbage after the 802.11 header produce random
+ * 48-bit PNs.
+ */
+#define RTW_RX_PN_GUARD_JUMP	BIT_ULL(24)
+
+static u64 rtw_rx_ccmp_pn(const u8 *iv)
+{
+	return (u64)iv[0] | (u64)iv[1] << 8 | (u64)iv[4] << 16 |
+	       (u64)iv[5] << 24 | (u64)iv[6] << 32 | (u64)iv[7] << 40;
+}
+
+static void rtw_rx_report_suspect(struct rtw_dev *rtwdev, const char *why,
+				  struct rtw_rx_pkt_stat *pkt_stat,
+				  void *rx_desc8, struct ieee80211_hdr *hdr,
+				  u64 max_pn)
+{
+	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	u32 n = ++rtwdev->rx_pn_guard.events;
+	u8 tid = ieee80211_is_data_qos(hdr->frame_control) ?
+		 ieee80211_get_tid(hdr) : 0;
+	u64 pn = 0;
+
+	if (pkt_stat->pkt_len >= hdr_len + IEEE80211_CCMP_HDR_LEN)
+		pn = rtw_rx_ccmp_pn((u8 *)hdr + hdr_len);
+
+	if (n > RTW_RX_PN_GUARD_DUMPS) {
+		dev_warn_ratelimited(rtwdev->dev,
+				     "suspect hw-decrypted frame #%u (%s): tid %u max pn 0x%012llx pn 0x%012llx%s\n",
+				     n, why, tid, max_pn, pn,
+				     pkt_stat->decrypted ? "" : ", left to mac80211");
+		return;
+	}
+
+	rtw_warn(rtwdev,
+		 "suspect hw-decrypted frame #%u (%s): seq %u tid %u max pn 0x%012llx pn 0x%012llx len %u rate 0x%x%s\n",
+		 n, why, ieee80211_get_sn(hdr), tid, max_pn, pn,
+		 pkt_stat->pkt_len, pkt_stat->rate,
+		 pkt_stat->decrypted ? "" : ", left to mac80211");
+	print_hex_dump(KERN_WARNING, "rtw88 rx desc: ", DUMP_PREFIX_OFFSET,
+		       16, 1, rx_desc8, (u8 *)hdr - (u8 *)rx_desc8, false);
+	print_hex_dump(KERN_WARNING, "rtw88 rx frame: ", DUMP_PREFIX_OFFSET,
+		       16, 1, hdr, min_t(u32, pkt_stat->pkt_len, hdr_len + 128),
+		       false);
+}
+
+/* Some 8822CE devices occasionally deliver a frame whose descriptor and
+ * 802.11 header are valid but whose remaining bytes, including the
+ * cleartext CCMP header, are not that frame's, while the descriptor still
+ * claims a successful hardware decryption. mac80211 then stores the garbage
+ * PN as the key's last PN and drops every later frame as a replay until
+ * the next rekey.
+ *
+ * The transmitter numbers all frames of a key from one PN counter, shared
+ * by every TID (the receiver keeps per-TID replay counters only because of
+ * QoS reordering). So track the highest PN seen per transmitter and
+ * unicast/group key for hardware-decrypted data frames, and report frames
+ * whose PN is implausibly far beyond it. A genuine frame on any TID cannot
+ * be, however long that TID was idle. A suspect PN never becomes the
+ * reference, so later genuine frames are not flagged and later bad frames
+ * are still caught. With sw_decrypt_suspect set, a suspect frame is passed
+ * to mac80211 as not decrypted, so it is verified in software and dropped
+ * on MIC failure without moving the replay counter.
+ */
+static void rtw_rx_pn_guard(struct rtw_dev *rtwdev,
+			    struct rtw_rx_pkt_stat *pkt_stat,
+			    void *rx_desc8, struct ieee80211_hdr *hdr)
+{
+	struct rtw_rx_pn_guard *guard = &rtwdev->rx_pn_guard;
+	u32 gen = atomic_read(&rtwdev->rx_pn_guard_gen);
+	u32 hdr_len;
+	u64 pn, max;
+	u8 grp;
+
+	if (guard->gen != gen) {
+		memset(guard->valid, 0, sizeof(guard->valid));
+		guard->gen = gen;
+	}
+
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !ieee80211_has_protected(hdr->frame_control))
+		return;
+
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	if (pkt_stat->pkt_len < hdr_len + IEEE80211_CCMP_HDR_LEN + FCS_LEN)
+		return;
+
+	grp = is_multicast_ether_addr(hdr->addr1);
+	pn = rtw_rx_ccmp_pn((u8 *)hdr + hdr_len);
+
+	if (!guard->valid[grp] ||
+	    !ether_addr_equal(guard->ta[grp], hdr->addr2)) {
+		guard->pn[grp] = pn;
+		ether_addr_copy(guard->ta[grp], hdr->addr2);
+		guard->valid[grp] = true;
+		return;
+	}
+
+	max = guard->pn[grp];
+	if (pn <= max)
+		return;
+
+	if (pn - max > RTW_RX_PN_GUARD_JUMP) {
+		if (READ_ONCE(rtw_sw_decrypt_suspect))
+			pkt_stat->decrypted = false;
+		rtw_rx_report_suspect(rtwdev, "PN jump", pkt_stat, rx_desc8,
+				      hdr, max);
+		return;
+	}
+
+	guard->pn[grp] = pn;
+}
+
 int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 			 struct rtw_rx_pkt_stat *pkt_stat,
 			 struct ieee80211_rx_status *rx_status)
@@ -350,8 +463,13 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 		rtw_dbg(rtwdev, RTW_DBG_RX,
 			"AES frame without a usable CCMP header, drop the decryption flag\n");
 		pkt_stat->decrypted = false;
+		rtw_rx_report_suspect(rtwdev, "bad CCMP header", pkt_stat,
+				      rx_desc8, hdr, 0);
 	}
 
+	if (pkt_stat->decrypted && enc_type == RX_DESC_ENC_AES)
+		rtw_rx_pn_guard(rtwdev, pkt_stat, rx_desc8, hdr);
+
 	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status);
 
 	return 0;
-- 
2.55.0

