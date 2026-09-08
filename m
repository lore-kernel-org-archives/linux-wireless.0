Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67904A0EEB
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788888601; cv=none; b=aypEpNO7Q6BUdmVZg3AtFcHE2c80nU9ytUOP8q0nbKJsF2iJ2FthufTJ7/nTWvbJjKoOH9+zR52LnVKNvSp5LfVL9+NaF0ZU7akpOBgbK1zkyp+2jHC89oaYOlUn0NN2AaObwPJstdU8HV8H9WRxX/uUAuOR5hh7QStqUVqGIWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788888601; c=relaxed/simple;
	bh=0NBhsEuIrJs86q6yh6KvUtTHwTk6psOHMhoD3EQ1LVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FwQ0j+/jF/Cv/N9HSuGl/Fzr5Fb44sJDwauWdr4JjvThucsUim1FOrkTa48QwKYbLOXoT7xJmVUfcnrX0jjnkF8ipaSaDtRa8soqGpCDQ/yBRIthhT3W+7MSq6Oh3fmilVOdTrIc7k+f/R672NDx6bJbvcx0ovRLR85tjDFAfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fkvmNOQ1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fkvmNOQ1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=hh0qwABCggTe/6O5hhAPhtKMWRNHuy1M+1hAzJ8h9is=; t=1788888599; x=1790098199; 
	b=fkvmNOQ1ziLwG+WQHeQQypcDFsHDPJV4TzTTHjh3jITlrA9++XXrRYNliCyKBUwFZyQo1DreJfh
	DbG2OyNsQb4ssRvqpKXVWIFyqeGa9ajfMRc9Afb7W4dEKlasrADjOeXYRZVSv3TG3+FzSXDLw+da2
	pjdsuOP3c6QJbRsQQKuf9IC7r3ymYwh3APL4MdgOo+S+4J6Gig4xADb9L8xWN9x8UXLkPw94mdm5B
	974kcA3XF2+dnyHsqZm8dohP7NmA4TVATd5wy97RLMdrhTsmm9fDPb6BdhPVStiUQZWAXp/yBy9Sw
	f8lD4fxzRF3ZqM2AzzlI1TY6Zk7lq33VeBOA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3zdm-00000006RDp-37FP;
	Tue, 08 Sep 2026 19:29:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: rtw89: avoid iter_keys_rcu() where not needed
Date: Tue,  8 Sep 2026 19:29:48 +0200
Message-ID: <20260908192948.8a5318efb4df.I56408c1ff0b5c3bcb19a1054858076443fcae3b3@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

All of this code already holds the wiphy mutex, so none
needs the _rcu() variant. Simplify the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/realtek/rtw89/cam.c |  4 +---
 drivers/net/wireless/realtek/rtw89/wow.c | 12 ++++--------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index 7c62ece137d0..22f21a04a96d 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -605,9 +605,7 @@ void rtw89_cam_deinit(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_li
 
 void rtw89_cam_reset_keys(struct rtw89_dev *rtwdev)
 {
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(rtwdev->hw, NULL, rtw89_cam_reset_key_iter, rtwdev);
-	rcu_read_unlock();
+	ieee80211_iter_keys(rtwdev->hw, NULL, rtw89_cam_reset_key_iter, rtwdev);
 }
 
 static int rtw89_cam_get_avail_addr_cam(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 2dfa24c54e7d..0bf34692c7ce 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -473,10 +473,8 @@ static void rtw89_wow_construct_key_info(struct rtw89_dev *rtwdev)
 	struct ieee80211_vif *wow_vif = rtwvif_link_to_vif(rtwvif_link);
 	bool err = false;
 
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(rtwdev->hw, wow_vif,
-				rtw89_wow_get_key_info_iter, &err);
-	rcu_read_unlock();
+	ieee80211_iter_keys(rtwdev->hw, wow_vif,
+			    rtw89_wow_get_key_info_iter, &err);
 
 	if (err) {
 		rtw89_wow_key_clear(rtwdev);
@@ -695,10 +693,8 @@ static void rtw89_wow_update_key_info(struct rtw89_dev *rtwdev, bool rx_ready)
 	struct ieee80211_bss_conf *bss_conf;
 	struct ieee80211_key_conf *key;
 
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(rtwdev->hw, wow_vif,
-				rtw89_wow_set_key_info_iter, &data);
-	rcu_read_unlock();
+	ieee80211_iter_keys(rtwdev->hw, wow_vif,
+			    rtw89_wow_set_key_info_iter, &data);
 
 	if (data.error) {
 		rtw89_debug(rtwdev, RTW89_DBG_WOW, "%s error\n", __func__);
-- 
2.55.0

