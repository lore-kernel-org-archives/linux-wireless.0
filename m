Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7B14CF481
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226008; cv=none; b=t1QbXReiHcJHg4gL1OeKTpbu0BmaxeHlhGk4dhnL8+GI56ql5LuMOPYqOUya0SL/qFlecGvk5IaRV4+4j8b3uvvDGenIV5VTQ6IOMBUUensQaRqSZan5fex8BEpkuwHm4b6ifj6clYs+uf9skHlqvPNkpPQbMtK4da/W7KUkofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226008; c=relaxed/simple;
	bh=mydZrvXMef1GhUcCha+QABMJ7VHhzx80gkorgv0krlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aiYWLqQZN7qguKCQyWS8v6CaE4nBm4NKNyd0g6Zpg9aXv9eOpMDlc025X0ZeIILlTAIPIhjA52P5m5ZSNtq4vKXk9LZaGJTyB4lcjggG27pcHsN6och+bubVtW2yynPuqxCaA6flJZZOZuAsiUjaEW8pZfncTtTe0daCI7nT7ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mN4iEePO; arc=none smtp.client-ip=95.215.58.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mN4iEePO"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mydZrvXMef1GhUcCha+QABMJ7VHhzx80gkorgv0krlA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792226003; v=1; x=1792830803;
 b=mN4iEePOVe3vWn+Q34ZqIp2auqIuWvCnpULy4qRgds+bN9S/5LunYfjlgX6Mn0kb+TUHo6F3
 5QBvxhbVfV8w77vEuWvLv9BIQ95MBqYB514Yq1KPj0I+9k1gpaLMQFfEsymnFlzkCnvIP3kWEF+
 myRA6B9mACGlwlLPfXkDYa1Q=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 946d6b2f75d5fb3e;
	Sat, 17 Oct 2026 08:33:23 +0000
X-Mizu-Trace-ID: 946d6b2f75d5fb3e
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bob Beckett <bob.beckett@collabora.com>,
	linux-wireless@vger.kernel.org,
	kernel@collabora.com,
	matthew.leach@collabora.com,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next] wifi: rtw88: do not trust a claimed decryption
Date: Sat, 17 Oct 2026 10:33:13 +0200
Message-ID: <20261017083313.56113-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RX descriptor says how the CRC and ICV checks on the device's own copy
of the frame went, not that the bytes in our buffer are that frame.  For a
frame that is marked decrypted mac80211 reads the PN out of the CCMP header
and stores it as the key's last PN, rejecting only a lower PN, so a single
frame with a garbage CCMP header makes every genuine frame after it be
dropped as a replay.

Only claim decryption for a frame that passed the CRC and ICV checks, and
only for an AES frame whose CCMP or GCMP header is well formed.  Such a
frame is left to mac80211, which drops it without moving the replay
counter.  Mark a frame that failed the ICV with RX_FLAG_FAILED_FCS_CRC,
the way rtw89 does.

Reported-by: Bob Beckett <bob.beckett@collabora.com>
Closes: https://lore.kernel.org/all/20261016191100.1781056-1-bob.beckett@collabora.com/
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 30 +++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index fde21c840ac0..45ff18fa8c7b 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -208,7 +208,7 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD) &&
 	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		rtw_set_rx_freq_by_pktstat(pkt_stat, rx_status);
-	if (pkt_stat->crc_err)
+	if (pkt_stat->crc_err || pkt_stat->icv_err)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (pkt_stat->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
@@ -264,6 +264,24 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 	}
 }
 
+static bool rtw_rx_ccmp_hdr_valid(struct rtw_rx_pkt_stat *pkt_stat,
+				  struct ieee80211_hdr *hdr)
+{
+	u32 hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	u8 *iv;
+
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return true;
+
+	if (pkt_stat->pkt_len < hdr_len + IEEE80211_CCMP_HDR_LEN + FCS_LEN)
+		return false;
+
+	iv = (u8 *)hdr + hdr_len;
+
+	/* reserved octet is zero, key ID octet has ExtIV set */
+	return iv[2] == 0 && (iv[3] & BIT(5));
+}
+
 int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 			 struct rtw_rx_pkt_stat *pkt_stat,
 			 struct ieee80211_rx_status *rx_status)
@@ -285,7 +303,8 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 	pkt_stat->shift = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_SHIFT);
 	pkt_stat->phy_status = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_PHYST);
 	swdec = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_SWDEC);
-	pkt_stat->decrypted = !swdec && enc_type != RX_DESC_ENC_NONE;
+	pkt_stat->decrypted = !swdec && enc_type != RX_DESC_ENC_NONE &&
+			      !pkt_stat->crc_err && !pkt_stat->icv_err;
 
 	pkt_stat->cam_id = le32_get_bits(rx_desc->w1, RTW_RX_DESC_W1_MACID);
 
@@ -328,6 +347,13 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 	if (pkt_stat->phy_status)
 		rtwdev->chip->ops->query_phy_status(rtwdev, phy_status, pkt_stat);
 
+	if (pkt_stat->decrypted && enc_type == RX_DESC_ENC_AES &&
+	    !rtw_rx_ccmp_hdr_valid(pkt_stat, hdr)) {
+		rtw_dbg(rtwdev, RTW_DBG_RX,
+			"AES frame without a usable CCMP header, drop the decryption flag\n");
+		pkt_stat->decrypted = false;
+	}
+
 	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status);
 
 	return 0;
-- 
2.53.0

