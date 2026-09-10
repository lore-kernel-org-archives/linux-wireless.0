Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA5418344
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027508; cv=none; b=arLwriPDY8sKQuw8RdLzGXOlkkjyx4MJE2AgP7q4WCIXJLgMdUgI8TpPgm+Xuye/qgAOZKMryhpGx+wfXAJWiuO4pe5dpgvtqMyKIQ+6pbOtuH7kwV/TW5iO2CVMreJoNuqDfkxBqsKmoH2BpuZ4/vF804aq6Qdc+e+nAQK+5Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027508; c=relaxed/simple;
	bh=/cD67VZV8ad2RDRKzKyMw3tSFbMp21H3/a6sNuZHWTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XwCL6fL1DTG/56HZxVc5neTqRcpstzc+ydinujuCvhe6c2sfT8gDX8etsSv24qe2xWpKO6wmvstxe1dLC1m9+xVptueClm+tbJtRsSVxTSV+G1jNuMMIaBQrntsTyJvFYbOHlpKXmDkXEumsOSC/lMefd13KGgsIwjGnfrk35Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=obSjUq51; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="obSjUq51"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 10 Sep 2026 10:04:57 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	sst@poczta.fm
Subject: [PATCH] wifi: mac80211: verify if AP_VLAN belongs to the correct AP
Date: Thu, 10 Sep 2026 10:04:54 +0200
Message-ID: <20260910080454.725913-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789027498; bh=XCXrRKtVN91beg33bhT3sQJeVgP/yegQK7JfqOq6CC0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=obSjUq51kmlx1RFAozlfttRTkk8czBAzO6iP5Dhz2VCC/OlV4uqhGB9wqDECQ9iNf
	 6et+T8inXiwhxc3cZBp39U8y1pwuG01gUQKCD/qrhmcDCDVVzh2f/twN4w4H52dW0g
	 1Urb3Xiwcuw29Am2ukxRalt6qq2KeB9SiSc2ndQw=

The get_vlan() only checks if NL80211_ATTR_STA_VLAN target is an
AP/AP_VLAN/P2P_GO interface on the same wiphy. It has no notion of which
specific AP a given AP_VLAN belongs to. Without a check in mac80211
itself, NL80211_CMD_NEW_STATION and NL80211_CMD_SET_STATION could
add/move a station onto an AP_VLAN interface that actually belongs to a
different AP on the same wiphy.

Reject the userspace request unless the VLAN interface's bss pointer
matches the bss of the interface the station is being added to/belongs
to.

Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Link: https://lore.kernel.org/all/22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net/
---
 net/mac80211/cfg.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..920681eb2e87 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2637,19 +2637,25 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	int err;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	if (params->vlan) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
+		struct ieee80211_sub_if_data *vlansdata =
+			IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    vlansdata->vif.type != NL80211_IFTYPE_AP)
+			return -EINVAL;
+
+		/* the VLAN must belong to the AP we're adding the station to */
+		if (vlansdata->bss != sdata->bss)
 			return -EINVAL;
-	} else
-		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+		sdata = vlansdata;
+	}
 
 	if (ether_addr_equal(mac, sdata->vif.addr))
 		return -EINVAL;
@@ -2845,6 +2851,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
+		/* the VLAN must belong to the AP the station is on */
+		if (vlansdata->bss != sdata->bss)
+			return -EINVAL;
+
 		if (params->vlan->ieee80211_ptr->use_4addr) {
 			err = ieee80211_set_sta_4addr(local, vlansdata, sta);
 			if (err)
-- 
2.55.0

