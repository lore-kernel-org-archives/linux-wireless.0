Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E6634CFD0
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2026 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776147781; cv=none; b=EfutvQReYlS/EDTjSsdChY9V0XvZ/GT292MQXpzqFs9DgsVXHyWBhZ4y8x7dyZJQvKYRFXSF4oUjhvX+HrLZRlk4SX2T678h4/f7rc95eMEwMcmX3PZvLDaD4RNvoJMK6zyCeiAYW5o5gYEqC+NhtxgBvQOFcbfCL7ooo5Mo5qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776147781; c=relaxed/simple;
	bh=b4aGWvosjvyuRcpV9ornYtIQeErEznjuhepNoHHVLj8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKmSD1Fi4WG+r1pzdW4R5cpBaDX+4LxHB42GL8lKmWljvO9sFupLet/eqMf9zNKTyCEdsaTmB82oQmkvAhoyJK95Z8wcDvUYapYz0ucbDDoCo5RZsuWdfiEbQC9Cn2smfhduo2NlaGDGYLDMJxhTVVIXPOnIPYsfpl8vwZnzWzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gPZ7+tpn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gPZ7+tpn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63E6Ms5A21508642, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776147774; bh=UeHIyoH4+DYq/h6ET6sFU5rj2iwus/i+o0VWl9RHg2c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gPZ7+tpn2OnMH3Rb7WiySTq0cEVKBz+3SJv/v5l5sGZEROFaZw18hOR+1jBFBGjr7
	 pYEAk2vtPv75rF36Z5GuYA0TWGTBr5tnYN4eXnbHG+5pkooXneTV6MmUQa4Y6xo59m
	 QcrHkC1sGGOKOksVpoIXOjfRAsDQ2BoXmIils5V9WWOw2hnlc9UiLAHyRWyceIAhhS
	 HmsUtpQHJJtgm5Xgf7V+GW9OzulcBOAm+FgK8ebp3XSBdvNo10uXk/KBsmZw9EJwqO
	 b0QqIMLnkWYfCfKojGCVWYvEo6KW7oM9Ja9cmy8lO8OR34b2mghfST5mYma+iVMKEt
	 Cg+u0rPme6D7Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63E6Ms5A21508642
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 14:22:54 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Apr 2026 14:22:54 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 14 Apr 2026 14:22:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <Jes.Sorensen@gmail.com>
Subject: [PATCH rtw-next 2/3] wifi: rtlwifi: validate action frame size in rtl_action_proc()
Date: Tue, 14 Apr 2026 14:22:28 +0800
Message-ID: <20260414062229.21047-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260414062229.21047-1-pkshih@realtek.com>
References: <20260414062229.21047-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Since action frames might be malformed from RX or injected TX, validate
the size before using.

More, use struct ieee80211_mgmt to access fields of action frames instead
of counting barely.

Tested with ping on RTL8723BE. The add BA request action frames of TX/RX
can be handled properly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index aad377864e73..9e98c01bb90e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1369,18 +1369,19 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_mgmt *mgmt;
 	__le16 fc = rtl_get_fc(skb);
-	u8 *act = (u8 *)(((u8 *)skb->data + MAC80211_3ADDR_LEN));
-	u8 category;
 
 	if (!ieee80211_is_action(fc))
 		return true;
 
-	category = *act;
-	act++;
-	switch (category) {
+	mgmt = (void *)skb->data;
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(action_code))
+		return true;
+
+	switch (mgmt->u.action.category) {
 	case ACT_CAT_BA:
-		switch (*act) {
+		switch (mgmt->u.action.action_code) {
 		case ACT_ADDBAREQ:
 			if (mac->act_scanning)
 				return false;
@@ -1394,9 +1395,11 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 				struct ieee80211_sta *sta = NULL;
 				struct rtl_sta_info *sta_entry = NULL;
 				struct rtl_tid_data *tid_data;
-				struct ieee80211_mgmt *mgmt = (void *)skb->data;
 				u16 capab = 0, tid = 0;
 
+				if (skb->len < IEEE80211_MIN_ACTION_SIZE(addba_req))
+					return true;
+
 				rcu_read_lock();
 				sta = rtl_find_sta(hw, hdr->addr3);
 				if (sta == NULL) {
-- 
2.25.1

