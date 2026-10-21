Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609556;
	b=daeODMHxU8OWILOksfaTRsyfhiUQF6qmWm8LS0r96df7YXs1+UYf65iD+Cgeiw98KLd8
	 vvDKY5ZW9nkjkd7wiqUSl68u+mk/+zrF+/lO+JRuqs5QCs1cIcNg8wyAZc4aECCbWeAO/
	 ZQ48hPSmSIL0HH5KNr3L67vbvCD6IPSL2hsL6lBuGPUsb86Q83AIIuMpgmdypKpq0Rf2k
	 TaXmH/CrRYnBNgBh08hcd3WDodOr4KJIqIzVAW9GjiTKr06GAuWAEIaiRdCVIgs06kizV
	 LxxHQzlF+ScK1t2JQBtjlu4uy0jB+UESS77Nj33JT1IeVpCh9MjyrS9NU9yMsMNeD5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609556;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=12VJl2OOQ4HkfRIRvHWyfL+3kfN1jFLRef1EI6KB4Z0=;
	b=WEUX7di1ck+I0ZTxC649PG7PM4V5dkehDO62bHX1IKM69g9DKd/Bxamc3I2kPPUAzYNG
	 DvwKY+jFvFr1ujM7NoHmKD+L7ZjEKrhggdC20/oqXDzlEKBXl+czMbJC3qqgqlbb+KwOA
	 4WZzm1ASiwy6KslP8JsVda+uCz8TQk/jM50aWD891tGB7zMjStd2NhEdW5XA/exL4b0FJ
	 I1qdAUASDLDKLU9adIpCXOwrSlLdNOKn3rnz5PV83esuIK1XPFfpeolmd1OTrsys2zJaD
	 7LmTdSLuoIfBl7gce+bxizAXNMz3ZOE6zXITKxUC61nBOoBm127XxU48HEIalZVwrtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b="EZ/Ql6dp";
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A18D606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A18D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=EZ/Ql6dp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609554;
	bh=2Ki1u3bPQMjXU1gY0ktndNIu+GCeaUtBAcjseBPIvWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZ/Ql6dpM0CXfmbMbb5oo6QxaBgM7pNwdyMpIgYJ0+B8wkS7iVQAv6ltifOL/2Kli
	 wUKh2WgqjpsC8GXz0+f61YtCsSNbySvkgKpmKFq3pC6nvjDHwLz0ffgLf/ZpTXa65z
	 LEJU58zfXwTw7D5IDQrcPQeYAegriJ86R9b0HqsCEl7Zb/pubRPjlHgxT0zZgLlmT0
	 O7Zm0zEV5zwUtTjwcRPmtNf07EDnPCA9aGI7uUsz6cRWregUj4O+1zXsQbmdBn28Ff
	 1QZl5olyXBCrv8QagU5duHGhVL8vFVjjChJ4cktkqr9xcyxfdEG02xqMazv0qzn8qD
	 74v69bSBEGUHw==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8858517E0240;
	Wed, 21 Oct 2026 21:05:53 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: [RFC PATCH rtw-next 1/5] wifi: rtw88: do not trust a claimed decryption
Date: Wed, 21 Oct 2026 20:05:20 +0100
Message-ID: <20261021190529.3893821-2-bob.beckett@collabora.com>
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

From: Luka Gejak <luka.gejak@linux.dev>

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
Link: https://lore.kernel.org/r/20261017083313.56113-1-luka.gejak@linux.dev
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 30 +++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 01fd299abb7f..e292b060ac31 100644
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
@@ -262,6 +262,24 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
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
@@ -283,7 +301,8 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 	pkt_stat->shift = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_SHIFT);
 	pkt_stat->phy_status = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_PHYST);
 	swdec = le32_get_bits(rx_desc->w0, RTW_RX_DESC_W0_SWDEC);
-	pkt_stat->decrypted = !swdec && enc_type != RX_DESC_ENC_NONE;
+	pkt_stat->decrypted = !swdec && enc_type != RX_DESC_ENC_NONE &&
+			      !pkt_stat->crc_err && !pkt_stat->icv_err;
 
 	pkt_stat->cam_id = le32_get_bits(rx_desc->w1, RTW_RX_DESC_W1_MACID);
 
@@ -326,6 +345,13 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
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
2.55.0

