Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D413644D1
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774423336; cv=none; b=KXmhX9ApSBBJ8+37c2RRaV9jHTBj8l8lx3r+5AudXR6xDZH8C8BKp6jMO7dzuE97QcfYMIYCdu6H/upxrjbfKLbTArx3Q8XRElrmtRYkolvBbS+ZucdXC5InUNpqcvOMgH80c40NkcaVsHbE1PShXH4nUqYZI8mVm8RCwqW4bYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774423336; c=relaxed/simple;
	bh=qwZmW1Lk1+BJPaUsJuXKu3g4cpCbkEEfAWnhoTQ0+DU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEXEUVUGSg7hMMM65h+5bCLD74CzIzhWZUzUg6KKM/hSTinsXLv3/mwrvkXqgR2q6tet3q6QCm+VwYtDnw50Xlq9CEp821VgzSEzPnq/xC/v1rJgGZ6qGdycfwGNW25jrIc8LXnmF5G0dZA0T53KzIbS+7IDmfBODgvwXieX/7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HtRNlU/s; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HtRNlU/s"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62P7MCRK02939436, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774423332; bh=uQA44t+mDvkX2xHOXrG7APATZ/Yt+hgVZYl4J0Bk338=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=HtRNlU/sF5RdxmnYwj3ejWkADFo6ZzXFzMI3OOoaAIXYUQV3rgZT+jnfaR8swSAdS
	 7JriFUX7G4/KIAVVCG0aHXyzvN3FyJolsPJ6787Q1tTKUP54pXQayJNE8GpfX5VqdV
	 9r1ywCiZxjQ9C39nB6glOzRhe2cxlM8Pmd0NrfKxnMFpjXbwmK+bfIJNdbah3m/Ssn
	 MWFScBU8TI5YKPPucciWSx22Mx80nvxMuYFHBAqmydgjfIURXgAksSFdrR1TUi/BOf
	 3PgSyO8eGlgBX2RsLD8Ogs8jVW1BrvFfDxnJRnc84c0sQQJv9f95/emeMl3R11jHG8
	 901hAGVzrd7UA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62P7MCRK02939436
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 15:22:12 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 25 Mar 2026 15:22:08 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 25 Mar 2026 15:22:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <echuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/8] wifi: rtw89: wow: enable MLD address for Magic packet wakeup
Date: Wed, 25 Mar 2026 15:21:24 +0800
Message-ID: <20260325072130.41751-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260325072130.41751-1-pkshih@realtek.com>
References: <20260325072130.41751-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chin-Yen Lee <timlee@realtek.com>

Under MLO connections, the original Magic Packet configuration
only supported Link Addresses for wakeup. Update the setting
to support both MLD Address and Link Addresses for wakeup process.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/fw.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 701cea9a771e..13391ec9627c 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -9709,6 +9709,7 @@ int rtw89_fw_h2c_wow_wakeup_ctrl(struct rtw89_dev *rtwdev,
 				 struct rtw89_vif_link *rtwvif_link,
 				 bool enable)
 {
+	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
 	struct rtw89_h2c_wow_wakeup_ctrl *h2c;
 	struct sk_buff *skb;
@@ -9728,9 +9729,14 @@ int rtw89_fw_h2c_wow_wakeup_ctrl(struct rtw89_dev *rtwdev,
 	if (rtw_wow->pattern_cnt)
 		h2c->w0 |= le32_encode_bits(enable,
 					    RTW89_H2C_WOW_WAKEUP_CTRL_W0_PATTERN_MATCH_ENABLE);
-	if (test_bit(RTW89_WOW_FLAG_EN_MAGIC_PKT, rtw_wow->flags))
+	if (test_bit(RTW89_WOW_FLAG_EN_MAGIC_PKT, rtw_wow->flags)) {
 		h2c->w0 |= le32_encode_bits(enable,
 					    RTW89_H2C_WOW_WAKEUP_CTRL_W0_MAGIC_ENABLE);
+		if (ieee80211_vif_is_mld(vif))
+			h2c->w0 |= le32_encode_bits(enable,
+						    RTW89_H2C_WOW_WAKEUP_CTRL_W0_MAGIC_MLD_ENABLE);
+	}
+
 	if (test_bit(RTW89_WOW_FLAG_EN_DISCONNECT, rtw_wow->flags))
 		h2c->w0 |= le32_encode_bits(enable,
 					    RTW89_H2C_WOW_WAKEUP_CTRL_W0_DEAUTH_ENABLE);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index cf86fade84a2..4574a281d352 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2231,6 +2231,7 @@ struct rtw89_h2c_wow_wakeup_ctrl {
 #define RTW89_H2C_WOW_WAKEUP_CTRL_W0_REKEYP_ENABLE BIT(5)
 #define RTW89_H2C_WOW_WAKEUP_CTRL_W0_EAP_ENABLE BIT(6)
 #define RTW89_H2C_WOW_WAKEUP_CTRL_W0_ALL_DATA_ENABLE BIT(7)
+#define RTW89_H2C_WOW_WAKEUP_CTRL_W0_MAGIC_MLD_ENABLE BIT(8)
 #define RTW89_H2C_WOW_WAKEUP_CTRL_W0_MAC_ID_EXT GENMASK(23, 16)
 #define RTW89_H2C_WOW_WAKEUP_CTRL_W0_MAC_ID GENMASK(31, 24)
 
-- 
2.25.1

