Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A14A59
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327078; cv=none; b=VD7N/Ak9G9r0TOp/TTzK3O998k4yJkEVoBDpBEDsY48sszZrWuxtJMcjkGciXC0kwZjUIsX3kmgwZwBQlHIZv6f+/85rH+BGKlzVza27XPzBEJpffOXxNIhDucMaySG7iUjCd4D5ZYD6EDchotvKM8Az6VhK5UgVHcQPLbYt7u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327078; c=relaxed/simple;
	bh=fic5VpV40s2qnvMpKP84BUGY0uGL0PySoJ22//qgP4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ow6r17jbEDN5b2uUFBQ17HLeVqdqoORw9RbcO+pXdnEw2/zVsmMYIjx34J3d6r94ztnvtsCvfoWUgMQ5Gb41FAsVT/HpyURsDmTu1KSxZMYc98/flERVO6Svw9Opi0RYWt/NMyAd2UgPql4/y2RsFKc++kc8rC2ikJaz8aq0Uec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Qld2GY4t; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Qld2GY4t"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825VEA002368534, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327074; bh=nEN+PgXtZNrWSgbAzo/wep1fBwoM1P5QfUPKmnYmafQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Qld2GY4tVdtdcDl6dhWPHZug1rZG9tFeL23xrgPKSNEcCamfze2s7R5GA4U1z0fwi
	 xDyIYysgMhRShQCvYGC3ty6UPGIramRSegNOae8MJOcWCI733J4VqVCcGQG0qPyoMV
	 tSWVmo4hUSfv+e8SLME+Kvs/Jyy4tTXAasOaF+3QyizpPgqheepq1nNl707JGPClbF
	 jZbU2uEaY4h0dWpIfyDeJbgzLtlNXytxCw82SpVvYZjGgYQQ9E9Pdn2OB1PyFZENdw
	 /6/5qHPtCqLj2UbeMZm+/p5NpITXVXpVADqopo9nG477q2Fj2/vxBLoQqsgAdpL+3K
	 V8hP249VrbLaw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825VEA002368534
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:31:14 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:31:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:31:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 11/14] wifi: rtw89: chan: introduce helper and refine active list iteration
Date: Wed, 2 Sep 2026 13:29:55 +0800
Message-ID: <20260902052958.50371-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Add a helper macro to iterate active vifs. Some chanctx handling iterated
all vifs and then checked if the link is active. In logical, it means only
the active vifs need to be counted there. So, also refine them to iterate
only active list.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/chan.c  | 14 ++++++--------
 drivers/net/wireless/realtek/rtw89/debug.c |  3 +--
 drivers/net/wireless/realtek/rtw89/fw.c    |  6 ++----
 drivers/net/wireless/realtek/rtw89/util.h  |  4 ++++
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 99b52ca05fe2..7205fca8ac1a 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -185,7 +185,7 @@ static void rtw89_chan_update_punctured(struct rtw89_dev *rtwdev,
 	struct rtw89_vif *rtwvif;
 	unsigned int link_id;
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif) {
 		rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id) {
 			if (!rtwvif_link->chanctx_assigned ||
 			    rtwvif_link->chanctx_idx != idx)
@@ -358,10 +358,8 @@ static void rtw89_entity_calculate_weight(struct rtw89_dev *rtwdev,
 			w->active_chanctxs++;
 	}
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
-		if (rtw89_vif_is_active_role(rtwvif))
-			w->active_roles++;
-	}
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif)
+		w->active_roles++;
 }
 
 static void rtw89_normalize_link_chanctx(struct rtw89_dev *rtwdev,
@@ -553,7 +551,7 @@ static void rtw89_entity_recalc_mgnt_roles(struct rtw89_dev *rtwdev)
 	 * which uses RTW89_CHANCTX_0 to put at position 0 and its designated
 	 * link take RTW89_CHANCTX_0. (normalizing)
 	 */
-	list_for_each_entry(role, &mgnt->active_list, mgnt_entry) {
+	rtw89_for_each_active_rtwvif(rtwdev, role) {
 		for (i = 0; i < role->links_inst_valid_num; i++) {
 			link = rtw89_vif_get_link_inst(role, i);
 			if (!link || !link->chanctx_assigned)
@@ -570,7 +568,7 @@ static void rtw89_entity_recalc_mgnt_roles(struct rtw89_dev *rtwdev)
 	}
 
 fill:
-	list_for_each_entry(role, &mgnt->active_list, mgnt_entry) {
+	rtw89_for_each_active_rtwvif(rtwdev, role) {
 		if (unlikely(pos >= RTW89_MAX_INTERFACE_NUM)) {
 			rtw89_warn(rtwdev,
 				   "%s: active roles are over max iface num\n",
@@ -3335,7 +3333,7 @@ static void rtw89_swap_chanctx(struct rtw89_dev *rtwdev,
 
 	swap(hal->chanctx[idx1], hal->chanctx[idx2]);
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif)
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif)
 		__rtw89_swap_chanctx(rtwvif, idx1, idx2);
 
 	cur = atomic_read(&hal->roc_chanctx_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 7e640c7166e4..2417381bca1c 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -5463,12 +5463,11 @@ rtw89_debug_priv_diag_rf_get(struct rtw89_dev *rtwdev,
 
 static void rtw89_dbg_diag_rf_set_rfk(struct rtw89_dev *rtwdev)
 {
-	struct rtw89_entity_mgnt *mgnt = &rtwdev->hal.entity_mgnt;
 	struct rtw89_vif_link *rtwvif_link;
 	struct rtw89_vif *rtwvif;
 	unsigned int link_id;
 
-	list_for_each_entry(rtwvif, &mgnt->active_list, mgnt_entry)
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif)
 		rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id)
 			rtw89_chip_rfk_channel(rtwdev, rtwvif_link);
 }
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index fb5757b84494..bdd562be4f22 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -10343,7 +10343,6 @@ static void rtw89_hw_scan_update_link_beacon_noa(struct rtw89_dev *rtwdev,
 
 static void rtw89_hw_scan_update_beacon_noa(struct rtw89_dev *rtwdev, bool scan)
 {
-	const struct rtw89_entity_mgnt *mgnt = &rtwdev->hal.entity_mgnt;
 	const struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	struct rtw89_mac_chinfo_ax *chinfo_ax;
@@ -10383,7 +10382,7 @@ static void rtw89_hw_scan_update_beacon_noa(struct rtw89_dev *rtwdev, bool scan)
 	}
 
 update:
-	list_for_each_entry(rtwvif, &mgnt->active_list, mgnt_entry) {
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif) {
 		unsigned int link_id;
 
 		vif = rtwvif_to_vif(rtwvif);
@@ -10400,7 +10399,6 @@ static void rtw89_hw_scan_set_extra_op_info(struct rtw89_dev *rtwdev,
 					    struct rtw89_vif *scan_rtwvif,
 					    const struct rtw89_chan *scan_op)
 {
-	struct rtw89_entity_mgnt *mgnt = &rtwdev->hal.entity_mgnt;
 	struct rtw89_hw_scan_info *scan_info = &rtwdev->scan_info;
 	struct rtw89_hw_scan_extra_op *ext = &scan_info->extra_op;
 	struct rtw89_vif *tmp;
@@ -10409,7 +10407,7 @@ static void rtw89_hw_scan_set_extra_op_info(struct rtw89_dev *rtwdev,
 	if (!RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD_EXTRA_OP, &rtwdev->fw))
 		return;
 
-	list_for_each_entry(tmp, &mgnt->active_list, mgnt_entry) {
+	rtw89_for_each_active_rtwvif(rtwdev, tmp) {
 		const struct rtw89_chan *tmp_chan;
 		struct rtw89_vif_link *tmp_link;
 
diff --git a/drivers/net/wireless/realtek/rtw89/util.h b/drivers/net/wireless/realtek/rtw89/util.h
index c16e7a7f8bc9..aa87a520bdc3 100644
--- a/drivers/net/wireless/realtek/rtw89/util.h
+++ b/drivers/net/wireless/realtek/rtw89/util.h
@@ -21,6 +21,10 @@
 #define rtw89_for_each_rtwvif(rtwdev, rtwvif)				       \
 	list_for_each_entry(rtwvif, &(rtwdev)->rtwvifs_list, list)
 
+/* call this function with wiphy mutex is held */
+#define rtw89_for_each_active_rtwvif(rtwdev, rtwvif) \
+	list_for_each_entry(rtwvif, &(rtwdev)->hal.entity_mgnt.active_list, mgnt_entry)
+
 /* Before adding rtwvif to list, we need to check if it already exist, beacase
  * in some case such as SER L2 happen during WoWLAN flow, calling reconfig
  * twice cause the list to be added twice.
-- 
2.25.1

