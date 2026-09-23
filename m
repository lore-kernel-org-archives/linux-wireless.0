Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8BC4446E4
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148505; cv=none; b=F4pl3LzbECOhmsRXNRZxHni0nacTX1Y+psM7nSEdCGFiZVfK4x6w3g0zmgdx1yw8sn0113VBBMLA2PtwoNEaMJkDJ6zGkcdHToYJW5uQnO63sStaDyhHAGLNNiaKRJgskgh1yrcIszrNxk7aMvU79uhRhS6O5vI0jTj277xpQec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148505; c=relaxed/simple;
	bh=iJTrRbflm+V7T9Ca9TTcVuOfs53jUG5XSVXaSPO2SNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXmObLcEr03wvzTzu8S0iEmTj/r7Pqsgv6E/1egLxnHl1MmTfAGMZA7/LqHhpytd4K/DjwNeynUeJ1id+ouy+98V1SODCZOiT5adttD3jlRa95b544Zf5azXFKaqnKabQtg9TjtyxqumaH7SLzNGHnd3i2mhkTUYaatl14XT9Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cPghQeR9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cPghQeR9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7SLmxC136849, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790148501; bh=ku9bAhFePIrDcwEq+gC4V3WK+7Jcb3y68/UrM4qkKdU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=cPghQeR9t/ord9Ri+J3/stosuWszmKJ0MMVKSQuGldKRrH+90Q3kgR5xxHwSjZdk+
	 QbFTsD9CFjxx0+0rT16zwx5mn1OrxUt0/0wiiBd56TovpmMjvUpVAFMr8xDnr9qVXO
	 MRp7LYFAYXyiWQhLCdPsOFHGjc6ycUfKdFJAs70Jc9YtAG3higL8bDtV9eYT+b0VpK
	 Z1TJypeu+sYKpQ8cvTXhM35Q8ct0MMkSMcZsusiZ4nqjuhUYL1nzDZVZL8MwoXggJn
	 3ZoOUT3Bha7V98j2J9S8e81Y7xntZrN4jJTpvB+efwmJ/ZORwhApms1nYDx2oXdR3z
	 XjN4ux3dxKkXg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7SLmxC136849
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:28:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:22 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:28:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/3] wifi: rtw89: ser: reset map of associated links when L2 SER
Date: Wed, 23 Sep 2026 15:27:39 +0800
Message-ID: <20260923072741.54118-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923072741.54118-1-pkshih@realtek.com>
References: <20260923072741.54118-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

There is a map used to record the associated links by MAC ID, but L2 SER
(system error recovery) will invoke ieee80211_restart_hw to reset things.
After ieee80211_restart_hw, the associated links will re-configure, but
each associated link might not use the same MAC ID as the original one.
If an associated link doesn't and the old MAC ID is not re-used, the map
keeps the old pair of old MAC ID and it. And then, if somehow HW fills a
wrong MAC ID, e.g. the old MAC ID above, in RX, SW will still obtain the
associated link. Once the one is really disconnected, the memory will be
freed and this case will cause problems.

So, reset entire map of associated links before ieee80211_restart_hw call.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/ser.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 701440bd7be1..045dac0bd1db 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -354,6 +354,14 @@ static void ser_deinit_cam(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	bitmap_zero(rtwdev->cam_info.ba_cam_map, RTW89_MAX_BA_CAM_NUM);
 }
 
+static void ser_reset_assoc_links(struct rtw89_dev *rtwdev)
+{
+	for (int i = 0; i < RTW89_MAX_MAC_ID_NUM; i++)
+		rcu_assign_pointer(rtwdev->assoc_link_on_macid[i], NULL);
+
+	synchronize_rcu();
+}
+
 static void ser_reset_mac_binding(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_vif *rtwvif;
@@ -362,6 +370,7 @@ static void ser_reset_mac_binding(struct rtw89_dev *rtwdev)
 	rtw89_for_each_rtwvif(rtwdev, rtwvif)
 		ser_deinit_cam(rtwdev, rtwvif);
 
+	ser_reset_assoc_links(rtwdev);
 	rtw89_core_release_all_bits_map(rtwdev->mac_id_map, RTW89_MAX_MAC_ID_NUM);
 	rtw89_for_each_rtwvif(rtwdev, rtwvif)
 		ser_reset_vif(rtwdev, rtwvif);
-- 
2.25.1

