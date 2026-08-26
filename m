Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECBF382381
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726555; cv=none; b=XHAY6kN6h3zKQ117amEUXBBTcbns1nNQzYsVv2p+ZjdQEz8+i6V0v+ACDOoOLHG2KwJe+Ebha5DuBUxCQewEeWXgvOCHJbvCDDQAi0PK6G2dySnEmUHlyVdIaYH6PjnI3KsPM2gcsbDoCDRQacpZ2oP4BkoyyhdgxhNV5/yoyR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726555; c=relaxed/simple;
	bh=rRli8S4e+uwdWKi09QA4FWSwTGxzPN7yyxiBAjpq6Y0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrxX+RpjN+qYT4n9Qm5ecBON9DIdz1Ip20PsQAGcnSfeN+INgoIc3ZO/AedBKr9ozx+XYT+yrEqLPrP9NKC6LN9svytZ0a4OoklEKM9OBNMWEY5O42Et155D293GI2URm80pwmlwTyrW6WHIyARL+AhWn9khoprV8elSMgb4Xuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ijM50BEP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ijM50BEP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6gU0l9353573, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726550; bh=C4j2i4cWLTU1TSXai4FY30IGCdwEMQPTXkNn+bGgpCA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ijM50BEPDIaSu/s60VgX6Zfx40TLtL0I+Z8H+L8tDZjXcbKKv3vnh6jhjGXykCL3B
	 0N2hhgv3EQr4iw6x7vioULmOzMvfa6R8c4UuNORKv8zVoFGzFbsG0Fei1CvNvU14xW
	 BKbNU+zidt9fvPD0Zkg5wdBSKt/5fawYnM43f/cqFVZOV3QeXn6t8OfxaHADFKB9Gc
	 eEWMmbQ5xBH3mDvxJiBwV7tocDWR2Em6ovNE5hchDoQ+wPl0cSdb8C1JXog8I2PaNB
	 PSPBISgcJvDWDZ6uSCOBikjT9J/3c6VPtt2fjlpu2JBvF2/T4IW4NFAcC51Ih+4cyB
	 Sh8ol6EahzkMA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6gU0l9353573
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:42:30 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:42:30 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:42:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:42:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 14/14] wifi: rtw89: add p2p device declaration
Date: Wed, 26 Aug 2026 14:41:01 +0800
Message-ID: <20260826064101.58892-15-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Po-Hao Huang <phhuang@realtek.com>

Use separate interface for P2P operations. This is required for
concurrent operations under MLO, so that address conversion can be
applied to correct frames. The wpa_cli commands for P2P operations
should be changed to under p2p-dev-<interface> after this commit.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 16 +++++++++++++++-
 drivers/net/wireless/realtek/rtw89/core.h |  2 +-
 drivers/net/wireless/realtek/rtw89/ps.c   |  2 ++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 80c4877e2dab..572d9c65a2dd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -176,6 +176,10 @@ static const struct ieee80211_iface_limit rtw89_iface_limits[] = {
 			 BIT(NL80211_IFTYPE_P2P_GO) |
 			 BIT(NL80211_IFTYPE_AP),
 	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
 };
 
 static const struct ieee80211_iface_limit rtw89_iface_limits_mcc[] = {
@@ -188,6 +192,10 @@ static const struct ieee80211_iface_limit rtw89_iface_limits_mcc[] = {
 		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO),
 	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
 };
 
 static const struct ieee80211_iface_combination rtw89_iface_combs[] = {
@@ -5697,6 +5705,7 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwvif_link, bool assoc)
 		else
 			rtwvif_link->wifi_role = RTW89_WIFI_ROLE_AP;
 		break;
+	RTW89_TYPE_MAPPING(P2P_DEVICE);
 	RTW89_TYPE_MAPPING(ADHOC);
 	RTW89_TYPE_MAPPING(MONITOR);
 	RTW89_TYPE_MAPPING(MESH_POINT);
@@ -5730,6 +5739,10 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwvif_link, bool assoc)
 		rtwvif_link->self_role = RTW89_SELF_ROLE_CLIENT;
 		rtwvif_link->addr_cam.sec_ent_mode = RTW89_ADDR_CAM_SEC_NORMAL;
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		rtwvif_link->net_type = RTW89_NET_TYPE_NO_LINK;
+		rtwvif_link->self_role = RTW89_SELF_ROLE_CLIENT;
+		break;
 	case NL80211_IFTYPE_MONITOR:
 		break;
 	default:
@@ -7523,7 +7536,8 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				     BIT(NL80211_IFTYPE_AP) |
 				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				     BIT(NL80211_IFTYPE_P2P_GO);
+				     BIT(NL80211_IFTYPE_P2P_GO) |
+				     BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 	if (hal->ant_diversity) {
 		hw->wiphy->available_antennas_tx = 0x3;
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index a2f6e68987a9..83554a2c8732 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6340,7 +6340,7 @@ enum rtw89_entity_mode {
 	RTW89_ENTITY_MODE_UNHANDLED = -ESRCH,
 };
 
-#define RTW89_MAX_INTERFACE_NUM 2
+#define RTW89_MAX_INTERFACE_NUM 3
 
 /* only valid when running with chanctx_ops */
 struct rtw89_entity_mgnt {
diff --git a/drivers/net/wireless/realtek/rtw89/ps.c b/drivers/net/wireless/realtek/rtw89/ps.c
index 34105d030537..23a9c7a0704a 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -367,6 +367,8 @@ void rtw89_recalc_lps(struct rtw89_dev *rtwdev)
 
 	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
 		vif = rtwvif_to_vif(rtwvif);
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			continue;
 
 		if (vif->type != NL80211_IFTYPE_STATION) {
 			count = 0;
-- 
2.25.1

