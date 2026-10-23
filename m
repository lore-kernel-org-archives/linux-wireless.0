Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796351;
	b=yyus6EKEFKshuBeIRNxgM537D48dTay5yo7hy29uSu27U1h9hlLLMJeZ3U+i+iGJsjT1
	 mGWpZQxuFnLTr+W4KKUZ0KK6nSaBCSZDQQcOuSIpgpcJOYlZtrcarMiGdktCIil8ic8fc
	 hESi2MT4CeDyYSJ36Oyb+43DW5dZ7PBdxyXBAZqkG3aXQ8/RPqbVdD+UVkk0zrpjs3OtX
	 B5goxH7s76i8km5lC8MBqCMrunBMJjrVs4VjnAV37aO1ARFiMgMYn5GnBdnlbg3CGLOf0
	 cpN6QCds8TpX40J8hOcIBa0H8VXFgN3lLwpeK3Mo25e3F+d8juPRgH8Sionsmo0zeMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796351;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kkq+i/l3e24OD3dweOmbu5ukpcjP6HUCQIL5eHuTaBM=;
	b=rfGrIZmOFMVFzr4Ugad9EODrq3mLHvfODUXvXfFJFAgsnYk8ucl8awJ7CNIwQgPBbS/H
	 tGNwiqE7915PHzdXXEjZMIoyTNDl/BJEEYh/77elFI0uYoUHeOGX4ZgjjH0RV61wzg7wS
	 dDqEQooeTb1uzaWIGfGMMSXTP9bfHhrKYFnq62W/7PMIYWGcZbEIYQO+gul85Ul/twBti
	 CfUi1LFnX1Pgw8QWu1KOXVu8h3tWjLF4h7QUa1rxrMywylPahjBRS9jXviORS0qllB2Ww
	 qZpqnCQubzCz2b3MRS/eMNUUlsliPVL1Z4XL3WiJzW+Uwc3YlF5OLIigxoMbwY9O+wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=axyoqUIL;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF33606A322
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 22:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDF33606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=axyoqUIL
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c4649b35bso1381008f8f.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 15:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796349; x=1793401149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kkq+i/l3e24OD3dweOmbu5ukpcjP6HUCQIL5eHuTaBM=;
        b=axyoqUILtMm73dn9UsLPskMlfDslXZx9e6i9wMAjZL39pYS7e8xeRVQNb+Dm+jgh3N
         NPNCplNLmhB22DRIFcHQ0iU9wwgFTwVSJrlnu2g0tiQbMZElnwVZZEZQ5z6kyYgf95q5
         ZWgKAoGdBM9I7Yliex7vFwVwlh892KKDaUYTxQ8miZ4rxB5E59Tgh+f9EeI6rpdaP9aX
         RZFWeL5lHrc8dCFGhAHcbFEwXbXvam9pTFTWsdIB3fRWNLshJjdVPyGkgldsuYl9dAWN
         x33LzkdXFhUJCgCCki8RoqyygA3wRJyCcv0N/YceVp1X3Mney4yR5IHttXUDDyrX5cNK
         K/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796349; x=1793401149;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kkq+i/l3e24OD3dweOmbu5ukpcjP6HUCQIL5eHuTaBM=;
        b=i3/UBNdsCFzG8JMObg8/IgzWnFpAsbJ/2vwdCJAgwMGxVqehk0ZoYk5WV+rnbKQeBF
         G5j1b10YZZr0ABqVfk/0ddR/FDH4dGTgj3aAyBsIuCW4jQQfeD0elm5vkkAI84N6OuZN
         U040vOl3Vj9LbBsyhtseTRsl4OUUFoKRy/H+MqI0qfJwxk928P3ZSHqwQcwEkhX4vI4m
         eWNflJkSRsd84UcN88wZmbVKdXgHXXaf8toQBbuZIs0x1JI370bMQjjCiJEzthk/C2Le
         nztL2DJXMwK9w3a+V01gzGbPQguO7Kn58YQkpb3psHjvx6+w4+Mj845QpUIewLj1wfOU
         w4tA==
X-Gm-Message-State: AFq9FYIGGbXUwUm/0z9u2T3I6UyO+UHpfg1JlWH6RnKbTznNkqbWl8E9
	/2eMelkD3oEaFI/pp8pMWEUVYJ5ah88rIEtnY5F/7pXkfSY2CJquexdyghwZqQ==
X-Gm-Gg: AYBFou0pwnqo86kidh+AgJBqofMND8J1WGYOlgf3Qbgxm1m/GvzelwR4bHhYdUwlGPe
	U59amameI9s1LRXQzMFjT4blUmmT8IpopLcApMsvsu5zxdsp6sH7/69OPm8XuXQSu/tvabYoCKW
	XOHaWST4KjRxRaWuFW5gXJS+nJp+cjQcyEFIjvvzQWOBDUVyZfRiYgarxxs3D2rWCeacKtnVMdb
	XhcqkyZKVrQDk9GFIa9XPsokGckZqiaemK788dIom/2RCVoYivI6hXUzteoTUDYwPvfNG78hDyB
	tSeY5QlJB9PRnKdqviYJNdQjm53IzV0188RZGO1LK5QtG0sfXGb3xK0r+kETNC+yG6LP1zGXOAQ
	50Ad49vi1lR1ou5uZ8xV65xfGkQdMN+8oS2KLHZUaUYMRHbJ7Es5+fsrqO2Vwedm2+rx27W7l+w
	Ueidfli8nEz0MeESu25ly8nTSleIqwSVoti9tqCa9++qmEOiqr70UTb6Sbw8h72EgIHskopZX34
	sSXAAFf/hOqWR+B0G1aGUTqW3+LG2kdAfPaPjaCI6Y2tZsqnyOCa6Y2WH7qiLoaPq3k+7yCVm6x
	Ge7g+1p0
X-Received: by 2002:a5d:67d2:0:b0:48d:f5ba:fb02 with SMTP id ffacd0b85a97d-48e3eb878b0mr449704f8f.49.1792796349024;
        Fri, 23 Oct 2026 15:59:09 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48e0sm854330f8f.38.2026.10.23.15.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 15:59:08 -0700 (PDT)
Message-ID: <5a3a20a7-b4c7-4b69-bc9f-6605111488dc@gmail.com>
Date: Sat, 24 Oct 2026 01:59:07 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH rtw-next 1/5] wifi: rtw88: Pass RX buffer to
 rtw_rx_query_rx_desc()
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Language: en-US
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

rtw_rx_query_rx_desc() assumes that the RX descriptor and the 802.11
frame are in the same buffer, but that's not true for the RTL8821AE.
It uses an older design which keeps the RX descriptor in the RX ring.

In order to support the RTL8821AE (PCIe) pass the RX buffer as a
separate pointer.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c  | 4 +++-
 drivers/net/wireless/realtek/rtw88/rx.c   | 6 +++---
 drivers/net/wireless/realtek/rtw88/rx.h   | 2 +-
 drivers/net/wireless/realtek/rtw88/sdio.c | 4 +++-
 drivers/net/wireless/realtek/rtw88/usb.c  | 4 +++-
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f51444..c2d6d3a939cd 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1056,6 +1056,7 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	dma_addr_t dma;
 	u32 new_len;
 	u8 *rx_desc;
+	u8 *rx_buf;
 	int ret;
 
 	count = rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci);
@@ -1068,7 +1069,8 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
 					DMA_FROM_DEVICE);
 		rx_desc = skb->data;
-		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc,
+		rx_buf = rx_desc + pkt_desc_sz;
+		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc, rx_buf,
 					   &pkt_stat, &rx_status);
 		if (ret)
 			goto next_rp;
diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index fde21c840ac0..0555e2e5c1ac 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -265,10 +265,9 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 }
 
 int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
-			 struct rtw_rx_pkt_stat *pkt_stat,
+			 void *rx_buf, struct rtw_rx_pkt_stat *pkt_stat,
 			 struct ieee80211_rx_status *rx_status)
 {
-	u32 desc_sz = rtwdev->chip->rx_pkt_desc_sz;
 	struct rtw_rx_desc *rx_desc = rx_desc8;
 	struct ieee80211_hdr *hdr;
 	u32 enc_type, swdec;
@@ -321,7 +320,8 @@ int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
 	if (unlikely(pkt_stat->pkt_len <= FCS_LEN))
 		return -EINVAL;
 
-	phy_status = rx_desc8 + desc_sz + pkt_stat->shift;
+	phy_status = rx_buf + pkt_stat->shift;
+
 	hdr = phy_status + pkt_stat->drv_info_sz;
 	pkt_stat->hdr = hdr;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rx.h b/drivers/net/wireless/realtek/rtw88/rx.h
index 74359f641c76..ebef85a3f848 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.h
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -46,7 +46,7 @@ struct rtw_rx_desc {
 void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		  struct sk_buff *skb);
 int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
-			 struct rtw_rx_pkt_stat *pkt_stat,
+			 void *rx_buf, struct rtw_rx_pkt_stat *pkt_stat,
 			 struct ieee80211_rx_status *rx_status);
 void rtw_update_rx_freq_from_ie(struct rtw_dev *rtwdev, struct sk_buff *skb,
 				struct ieee80211_rx_status *rx_status,
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index dc2fd0f8f9ff..2f0a6739df41 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1360,6 +1360,7 @@ static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
 	u32 pkt_offset, curr_pkt_len;
 	size_t bufsz;
 	u8 *rx_desc;
+	u8 *rx_buf;
 	int ret;
 
 	bufsz = sdio_align_size(rtwsdio->sdio_func, rx_len);
@@ -1376,7 +1377,8 @@ static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
 
 	while (true) {
 		rx_desc = skb->data;
-		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc,
+		rx_buf = rx_desc + pkt_desc_sz;
+		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc, rx_buf,
 					   &pkt_stat, &rx_status);
 		if (ret) {
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d9..a1b58061eb46 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -682,6 +682,7 @@ static void rtw_usb_rx_handler(struct work_struct *work)
 	u32 pkt_offset, next_pkt, skb_len;
 	int limit, ret;
 	u8 *rx_desc;
+	u8 *rx_buf;
 
 	for (limit = 0; limit < 200; limit++) {
 		rx_skb = skb_dequeue(&rtwusb->rx_queue);
@@ -697,7 +698,8 @@ static void rtw_usb_rx_handler(struct work_struct *work)
 		rx_desc = rx_skb->data;
 
 		do {
-			ret = rtw_rx_query_rx_desc(rtwdev, rx_desc,
+			rx_buf = rx_desc + pkt_desc_sz;
+			ret = rtw_rx_query_rx_desc(rtwdev, rx_desc, rx_buf,
 						   &pkt_stat, &rx_status);
 			if (ret)
 				break;
-- 
2.55.0

