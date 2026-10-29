Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238560;
	b=qevNdTVCiVFDWMnjCKV3Lm3QAVUqc90uGntWUuEpDhJbMaZFLou11aK/WpzP+Wn//6FI
	 aHmmnduNcECjtY7LVXvr7c6vEQ1W7cA0yBMZd4+pBJm6vLdthC9rGO47mNNdPTuI6nFU6
	 0pXl1svUX6wapADU1v4oDvuR1CWqNGShCs68tC+fTv5socbiaaFOB2ef/O4/n1gF+gSIk
	 3/VqBbT6PEq2761cK4jBBgi8OeUk/q7dF4uXt3jSLDPzKVwuyNqpoZKiNZO2lVneBosOS
	 BUAt+2mjtL79S+QinwqC14+yemjJR4pplIn38mB7Z9TIX6Wy+2vIPtADNfQ1JF1g2VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238560;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=EAJXQf0nbVRB9Eas4ZjjL8yesybYiT3AAaUZtH8Xc+Q=;
	b=BMr/jJkLW0ySyKvXE8tDRlq68eNxlTkOLMNhy0VHJReyUIcA6CIIhimmOTUUf49RyOim
	 jOe7CjtU7E2rAMzLa6zXdS6qxJs0SoJTlq5lD0eXltzPtpd45Mo8Ou4minqML2SR2DtaV
	 Rc6theWOVnJXsPfdV9BDM3nPkHXzOd/dhhNYHyIiqNuFzenKmvBWoKpIVn4Xct/YmqxT2
	 ZOy7/hy8L6ZeG8hc67T722APBYDxEmAGxLIul9K6Ye2u0GHE6rX1nAuPDoya6XnrAXZeL
	 rOomARPm1lBMUWOLAQSfrSFiwUm/XP+LFcbsemZJjOu3vJcglp2OsXqr2jyfTfsnaeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fhP5wnHK;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D29606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95D29606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fhP5wnHK
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T1nHiK52414104, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793238557; bh=EAJXQf0nbVRB9Eas4ZjjL8yesybYiT3AAaUZtH8Xc+Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=fhP5wnHKBGaMTzZ19EdJbSStn2oGUspEGiLbEas2Q6ryKeYKce8Nw8Z+jPri5aWrL
	 aV3hb3ldVjGRvcpG78dsTYwpZwsvIdpzFTjV5uM+JUDNW3wT0FWj3ceKzDV64ai+y4
	 87AY0YkEjGI23D80WNwpz2WvKXlwDI6nzQY2QY/3q88FMsXvlnITZbVhV1JcR1KqMf
	 DA2akHyVuBPN6gRFnOJCfrhsQyEym5zov6/HWYVTo4yZK197xEGyn2/yXTGIIdrntF
	 N5kj51uCQQpQ6ustIXfoLG/4jIxw12SoWuXAgYz36kC4AvTbDUNLps/jnslTmZz6qL
	 VZr4E+XUIydRw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T1nHiK52414104
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:49:17 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 09:49:17 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 09:49:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 29 Oct 2026 09:49:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>
Subject: [RFT rtw-next] wifi: rtw89: support TX of BIP-CMAC-128 management frames
Date: Thu, 29 Oct 2026 09:48:57 +0800
Message-ID: <20261029014857.9753-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
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
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

A RFT patch for test purpose.

It needs software generate MMIC header but excluding 8-byte MIC space.

This only supported by WiFi 7 chips and later, but we have not yet added
this condition.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/cam.c  |  1 +
 drivers/net/wireless/realtek/rtw89/core.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index 22f21a04a96d..10e1ba191a63 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -515,6 +515,7 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		hw_key_type = RTW89_SEC_KEY_TYPE_BIP_CCMP128;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 58ee5efc3b5e..4761a9f1c019 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -730,6 +730,9 @@ rtw89_core_tx_update_sec_key(struct rtw89_dev *rtwdev,
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		sec_type = RTW89_SEC_KEY_TYPE_GCMP256;
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		sec_type = RTW89_SEC_KEY_TYPE_BIP_CCMP128;
+		break;
 	default:
 		rtw89_warn(rtwdev, "key cipher not supported %d\n", key->cipher);
 		return;
@@ -906,6 +909,19 @@ u8 rtw89_core_get_ch_dma_v2(struct rtw89_dev *rtwdev, u8 qsel)
 }
 EXPORT_SYMBOL(rtw89_core_get_ch_dma_v2);
 
+static void rtw89_core_tx_trim_bip_mic(struct rtw89_core_tx_request *tx_req)
+{
+	const size_t mic_len = sizeof_field(struct ieee80211_mmie, mic);
+	struct sk_buff *skb = tx_req->skb;
+	struct ieee80211_key_conf *key = IEEE80211_SKB_CB(skb)->control.hw_key;
+
+	if (key->cipher != WLAN_CIPHER_SUITE_AES_CMAC)
+		return;
+
+	skb_trim(skb, skb->len - mic_len);
+	tx_req->desc_info.pkt_size = skb->len;
+}
+
 static void
 rtw89_core_tx_update_mgmt_info(struct rtw89_dev *rtwdev,
 			       struct rtw89_core_tx_request *tx_req)
@@ -936,6 +952,7 @@ rtw89_core_tx_update_mgmt_info(struct rtw89_dev *rtwdev,
 	desc_info->data_rate = rtw89_core_get_mgmt_rate(rtwdev, tx_req, chan);
 
 	if (chip->hw_mgmt_tx_encrypt && IEEE80211_SKB_CB(skb)->control.hw_key) {
+		rtw89_core_tx_trim_bip_mic(tx_req);
 		rtw89_core_tx_update_sec_key(rtwdev, tx_req);
 		rtw89_core_tx_update_llc_hdr(rtwdev, desc_info, skb);
 	}

base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.25.1

