Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE842FDC53
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787143304; cv=none; b=f/BM9qIVgYiNQ7qNx+RzNaB5z61wYLl7J9QEvz5SpMW2i+s1Hx+iaTkU9YE7JxakxzHHD4uD7FFhF9Y3uP7bdtm2iW6CP2S5U1QlX3V3NvE/R/WTJvVBS9/buvieFfVemrV3fHng5Zx8hbhcG9tbIY3opND6XoeYCDC0D+3vB/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787143304; c=relaxed/simple;
	bh=3OHkp+HGy9ycga9jFb0pGWfz6e8iXW4zTiXKLFJ7iSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzpJHc1y+4sDBHQLhE6qmSfz0p8sAGgvEDWrn4q34qZxHYLYi3Zbmcp7VUQ239I1j4/jJHGYSu17fVci0jSYdvTfjIZWIMAdYuxIZDyx3jyj7OHaZTtRpvDC52Giuf1MkzBZvniGYRTg+XcNm7DhozBy1yCGEH1iIhqbxKf2Iyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=V8W2q4Qj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="V8W2q4Qj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=FCs3m/nbR42yHyoYS36kqATC6DY/xbaSZxxoT3A5Xys=;
	t=1787143292; x=1788352892; b=V8W2q4QjQ81f9Div+bgbuKgiG+IBPpY2OzGDtawWSgxKE6/
	WTHGWBy8gT/mtkolGNw4FPyD3yZ2V/VukuBk3IoIZcnivwJepbT0BB8kbCKsRsL5kEXtsbU8BCrDd
	+XCTgKZtz0fHlWAvpAbsV//7zMBEo8Rh3S6aOaY9+jAcLebFROc623bYfBkaBPFmku6jhy/Mg/DS6
	FoIWqI0+YnHFm7JiinNU7JlEBkI3tFyz04e15XpkqAoWOKRxZjZZsxgThCHPeWCUsuxzrlBUXgeEx
	+JPmOpbdsZWrT6/1443U2wceUSme5SBdH3S6qleSCFagZbELgIsGxFWXXKhk92bg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wwfbd-000000089Cs-2pK4;
	Wed, 19 Aug 2026 14:41:22 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [wireless-next PATCH v2 8/8] wifi: mac80211: pass error station if non-STA transmit was requested
Date: Wed, 19 Aug 2026 14:39:07 +0200
Message-ID: <20260819143858.594e05877995.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819123858.4025935-10-benjamin@sipsolutions.net>
References: <20260819123858.4025935-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

When cfg80211 requested a transmit without a station, pass an error
station to ieee80211_tx_skb_tid instead of the correct one.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v2:
 * Fix logic error in v1 update

v1:
 * Only pass error station if NO_STA flag is set
---
 net/mac80211/offchannel.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5cec8747b193..ddd7a96a2f81 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -854,8 +854,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			need_offchan = true;
 
 		rcu_read_lock();
-		sta = sta_info_get_bss(sdata, mgmt->da);
-		mlo_sta = sta && sta->sta.mlo;
+		if (!params->no_sta) {
+			sta = sta_info_get_bss(sdata, mgmt->da);
+			mlo_sta = sta && sta->sta.mlo;
+		}
 
 		if (!ieee80211_is_action(mgmt->frame_control) ||
 		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
@@ -884,7 +886,8 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		     local->ops->remain_on_channel &&
 		     memcmp(sdata->vif.cfg.ap_addr, mgmt->bssid, ETH_ALEN))) {
 			need_offchan = true;
-		} else if (sdata->u.mgd.associated &&
+		} else if (!params->no_sta &&
+			   sdata->u.mgd.associated &&
 			   ether_addr_equal(sdata->vif.cfg.ap_addr, mgmt->da)) {
 			sta = sta_info_get_bss(sdata, mgmt->da);
 			mlo_sta = sta && sta->sta.mlo;
@@ -1022,7 +1025,9 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	if (!need_offchan) {
-		ieee80211_tx_skb_tid(sdata, skb, NULL, 7, link_id);
+		ieee80211_tx_skb_tid(sdata, skb,
+				     params->no_sta ? ERR_PTR(-ENOENT) : sta,
+				     7, link_id);
 		ret = 0;
 		goto out_unlock;
 	}
-- 
2.55.0

