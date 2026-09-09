Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3943B38BE
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937251; cv=none; b=HdsWmpK8kEmokTk8c9Sza8m6Rf2i2ZQokrwWbFzQWD1PmjzBCyxSTzyv8/s4Nm1oCTpu4TrNtsHZ2pm+flpIuuzewrvoVLMim/jOjh/Ex9+/mIjmfULEQBHio02JaSc7b9Qa8QrVnnE6YfIXPQkDdq67H8aNHBsElZDXWGmeZRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937251; c=relaxed/simple;
	bh=ogd7DknrwIicb3Wh9mYGeeYdbfwTR5GG1lLeoZtRTUc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpT2r93kJmSzYB0zmPQ3kBM+JhZ5oBI3Z58XDSbTVlM4zVNp0EwUjtbVZaVd3HYLb8z+d6D8w/tViH/3x2sS5XiCslYmcXBcNLSesGFDDDpA4p8A3CzHx9AOAethv665d6YkDiPvyOrL8grj7BUBDnCtv0bW3oSLN+P6+NvfarU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CBmwm157; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CBmwm157"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68970lo36356044, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937247; bh=5vF3HAM0jQPxjCsksdAE2LPxtCufby6lz1HBtCDcoyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CBmwm157yPv4015HpqJWQXxhb916Fv8dCy6ifT77Kk/avTsv+/YxKtZnFLc5fC9Qz
	 sxfBdDFNmHWu4ZHg1S/e5ZqrZy+2O1OPBrU/2tkJuWUoqv2eA5iUK+lOV8KowplMkr
	 LezwocKad8DtFqavLqXlqeqLMu7WUcz59S1JAQeajTHFC0gi6/XhchyAEKuN2L0xf0
	 BWdCYTSzqnQpIi7sjrs0INCfWOl9JKJr7fOstflmgI95zmuG1818aiWnGu6WlgeIYc
	 UH71+YxXEIE5UBuphR01zNhOEsx9L8lWZdqNdfFiiX3JqfooO4A/0ldGKCmwNkOjk8
	 VvsSEgFruIhag==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68970lo36356044
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:00:47 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:46 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 03/15] Revert "wifi: rtw89: fix unable to receive probe responses under MLO connection"
Date: Wed, 9 Sep 2026 14:59:52 +0800
Message-ID: <20260909070004.35353-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Po-Hao Huang <phhuang@realtek.com>

This reverts commit 6f6d7a325fbde4f025ee1b1277f6f44727e21223.

We no longer require this change after commit 0b0ff976af94
("wifi: mac80211: accept probe response on link address as well")
Previously, the encryption and decryption of MLD connections are not
working properly during scan, this could lead to timeout on some
applications.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 86db025afd7f..a16127b2c317 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -10445,7 +10445,6 @@ int rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	struct cfg80211_scan_request *req = &scan_req->req;
 	const struct rtw89_chan *chan = rtw89_chan_get(rtwdev,
 						       rtwvif_link->chanctx_idx);
-	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	struct rtw89_chanctx_pause_parm pause_parm = {
 		.rsn = RTW89_CHANCTX_PAUSE_REASON_HW_SCAN,
@@ -10478,8 +10477,6 @@ int rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
 		get_random_mask_addr(mac_addr, req->mac_addr,
 				     req->mac_addr_mask);
-	else if (ieee80211_vif_is_mld(vif))
-		ether_addr_copy(mac_addr, vif->addr);
 	else
 		ether_addr_copy(mac_addr, rtwvif_link->mac_addr);
 
-- 
2.25.1

