Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D03B4229D0
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750785; cv=none; b=pybYzc+4bEGFnLDQxcekY+0eTPOQYifSy5sn+YMJ2iYcOJYuGkFN3CDf+9WjIiI02Lic8d9mD0M6RDc3Mi1JLs4+9r4s8gvwiSTJWpU4NNa1pHmDk0qF0QiXxs+iIR/KkZdsQBld2iOPRNsGVfhoOl04Hqz6fxQd2lwWeGNIFV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750785; c=relaxed/simple;
	bh=/GtrSrouuBcHUww2ok5JHb9QlEWUutfIDTP7GKWdJuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjZV3aSn20EL2QlqMZ9CwY9QjX0BY75545iDHbR+TH7YU0pHIGekQCCqZGFwSuR4IRX4OXdDgKYamippLyF488dX5S2c9oeA1+/a4Xy1/pmbXm1PJlUPLGcD6EMBmIdnKW3MHZB9yhLkCydbC1JIPsWwdtlCg3G9GK5Y1UdCBas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=UIKu3l5R; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="UIKu3l5R"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kGhtD1882954, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750776; bh=bFvOrue4GMFKFjhb/xS8inQ+NnukjnUQkITp/aTIorw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=UIKu3l5R48HmjD/10kopvwSPB1QJ/fqVxU5zhlM57S0JF3g3/mpunYXoF6ZPpsqtq
	 dlVS8XNDX3OKAOGAzHR5HRU7rtLbeeHTOXsL9SgAiiKBF4Dw1g42dBf8wvB8iuTsqw
	 itAYBFTnTIlzaPq6Gq7zqjXfgWNj7M0BShHqkVHRY5tT7VTm8CfXRnU9qchSvRGfOc
	 +4mEmL0SBiegNmJHU+TzThZx4KN8MM1HEc/Sc/I2sXWGWjuKOe+76fybzlJ83MXCC+
	 YYDr43Rzh+4TGuvAWrTQnhef9mZIs4UpBiK8k5+N9+ZOxMv8V0BAsWHWhBPOefSLME
	 aJOOmCXIB0p0Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kGhtD1882954
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/6] wifi: rtw89: pci: fix typo of "deliver"
Date: Wed, 30 Sep 2026 14:45:20 +0800
Message-ID: <20260930064524.39403-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260930064524.39403-1-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

The "diliver" should be "deliver", so fix them.

(No logic is changed.)

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 18 +++++++++---------
 drivers/net/wireless/realtek/rtw89/pci.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 941fb5ca15b6..ddb27c7782a9 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -321,10 +321,10 @@ static u32 rtw89_pci_get_rx_skb_idx(struct rtw89_dev *rtwdev,
 static u32 rtw89_pci_rxbd_deliver_skbs(struct rtw89_dev *rtwdev,
 				       struct rtw89_pci_rx_ring *rx_ring)
 {
-	struct rtw89_rx_desc_info *desc_info = &rx_ring->diliver_desc;
+	struct rtw89_rx_desc_info *desc_info = &rx_ring->deliver_desc;
 	struct rtw89_pci_dma_ring *bd_ring = &rx_ring->bd_ring;
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
-	struct sk_buff *new = rx_ring->diliver_skb;
+	struct sk_buff *new = rx_ring->deliver_skb;
 	struct rtw89_pci_rx_info *rx_info;
 	struct sk_buff *skb;
 	u32 rxinfo_size = sizeof(struct rtw89_pci_rxbd_info);
@@ -370,7 +370,7 @@ static u32 rtw89_pci_rxbd_deliver_skbs(struct rtw89_dev *rtwdev,
 		if (!new)
 			goto err_sync_device;
 
-		rx_ring->diliver_skb = new;
+		rx_ring->deliver_skb = new;
 
 		/* first segment has RX desc */
 		offset = desc_info->offset + desc_info->rxd_len;
@@ -392,7 +392,7 @@ static u32 rtw89_pci_rxbd_deliver_skbs(struct rtw89_dev *rtwdev,
 	}
 	if (ls) {
 		rtw89_core_rx(rtwdev, desc_info, new);
-		rx_ring->diliver_skb = NULL;
+		rx_ring->deliver_skb = NULL;
 		desc_info->ready = false;
 	}
 
@@ -404,7 +404,7 @@ static u32 rtw89_pci_rxbd_deliver_skbs(struct rtw89_dev *rtwdev,
 err_free_resource:
 	if (new)
 		dev_kfree_skb_any(new);
-	rx_ring->diliver_skb = NULL;
+	rx_ring->deliver_skb = NULL;
 	desc_info->ready = false;
 
 	return cnt;
@@ -1840,8 +1840,8 @@ static void rtw89_pci_reset_trx_rings(struct rtw89_dev *rtwdev)
 		else
 			bd_ring->wp = 0;
 		bd_ring->rp = 0;
-		rx_ring->diliver_skb = NULL;
-		rx_ring->diliver_desc.ready = false;
+		rx_ring->deliver_skb = NULL;
+		rx_ring->deliver_desc.ready = false;
 		rx_ring->target_rx_tag = 0;
 
 		if (info->group_bd_addr) {
@@ -3719,8 +3719,8 @@ static int rtw89_pci_alloc_rx_ring(struct rtw89_dev *rtwdev,
 		rx_ring->bd_ring.wp = 0;
 	rx_ring->bd_ring.rp = 0;
 	rx_ring->buf_sz = buf_sz;
-	rx_ring->diliver_skb = NULL;
-	rx_ring->diliver_desc.ready = false;
+	rx_ring->deliver_skb = NULL;
+	rx_ring->deliver_desc.ready = false;
 	rx_ring->target_rx_tag = 0;
 
 	for (i = 0; i < len; i++) {
diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index cba52584ea68..0f9ea4bf54ea 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1608,8 +1608,8 @@ struct rtw89_pci_rx_ring {
 	struct rtw89_pci_dma_ring bd_ring;
 	struct sk_buff *buf[RTW89_PCI_RXBD_NUM_MAX];
 	u32 buf_sz;
-	struct sk_buff *diliver_skb;
-	struct rtw89_rx_desc_info diliver_desc;
+	struct sk_buff *deliver_skb;
+	struct rtw89_rx_desc_info deliver_desc;
 	u32 target_rx_tag:13;
 };
 
-- 
2.25.1

