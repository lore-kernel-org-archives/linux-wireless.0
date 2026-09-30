Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF1B40F726
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750796; cv=none; b=F4yFH9IjuvQEVRd/Efe3XWLhbUAm99BlCAyVRqiuoQpiMLrvm3XYr+oh8++WZ2hEWa9GisCfJzVedPEc11w7cuz1zCoAvA76DiBPnPMadO/8jpR7KoF6Cm1i+RCLg/dqD6MgKJEDVqEZMI7Bt9y0xZF6aLlbPPhW4i7qvuMxIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750796; c=relaxed/simple;
	bh=D+KCRW11H54KkjTpUGgRsbOUvBUax8OYrJWwwfoLy+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRpzkpnXIVMVAnTMA5ZyhDaI5VitpzcP4jUZBsDbz8+dQk7feuXKVslB6lpiJ2tNj8eQy4iMCr4Wbvm5JW6JvFKCu0wM1KIoG2PwfWZ3lxctFvHXHISb0tRxVcamtxYJmQB/V4XNWQufB6DoXQKXjo3xoqT9e/Z1ewKSLGl3Ius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vyhSqBt8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vyhSqBt8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kQtgD1883001, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750787; bh=u8j9ZcZM3+4Vq22u8Tj53HosX8m2UjqLI0tx96pSuws=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=vyhSqBt8jjIlOBA4mST203ciMNfFkRBVhbioow0qar2JLpT70Co/L7biFzSQe6wMf
	 9T1TYhk2J7ECcdHt3dbVw1zacAW8pgOLiLr7peLFzY/10sgqx1LSN9ONDLhpqnJrN1
	 BvpwQyTBdbaR3ba5U0azUA+Ixo3o48LtrRBwbe+H21ap06/21JGnxT0LtJOTzuq07M
	 1mRzKB+/nNovZy3Cf7bJ4CZBgQP3eQkQlCXAVVOc0Fu0xFKosc6FQp8soC2FowFn7J
	 c5GXP0DKrQrB/4MHOJMlpVNtvNXBo6gs6LIM78XB+HUpFXrN7Be3hWzULAMAp5u3yw
	 XExy75uH4PnkA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kQtgD1883001
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:27 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:27 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 4/6] wifi: rtw89: rx: no need to cancel 6 GHz probe per vif
Date: Wed, 30 Sep 2026 14:45:22 +0800
Message-ID: <20260930064524.39403-5-pkshih@realtek.com>
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

To cancel some 6 GHz probe cases, it just depends on if a skb matches
some corresponding conditions. Because the decision has nothing to do
with vif, it's redundant to do the cancellation per vif, i.e., single
case will be cancelled multiple times. So, move it out of iteration.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 0ae5aff8a122..8b9f9a4574f7 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3080,11 +3080,6 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	struct rtw89_bb_ctx *bb;
 	const u8 *target_bssid;
 
-	if (rtwdev->scanning &&
-	    (ieee80211_is_beacon(hdr->frame_control) ||
-	     ieee80211_is_probe_resp(hdr->frame_control)))
-		rtw89_core_cancel_6ghz_probe_tx(rtwdev, skb);
-
 	rcu_read_lock();
 
 	rtwvif_link = rtw89_vif_get_link_inst(rtwvif, desc_info->bb_sel);
@@ -3168,8 +3163,14 @@ static void rtw89_core_rx_stats(struct rtw89_dev *rtwdev,
 				struct rtw89_rx_desc_info *desc_info,
 				struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rtw89_vif_rx_stats_iter_data iter_data;
 
+	if (rtwdev->scanning &&
+	    (ieee80211_is_beacon(hdr->frame_control) ||
+	     ieee80211_is_probe_resp(hdr->frame_control)))
+		rtw89_core_cancel_6ghz_probe_tx(rtwdev, skb);
+
 	rtw89_traffic_stats_accu(rtwdev, NULL, skb, true, false);
 
 	iter_data.rtwdev = rtwdev;
-- 
2.25.1

