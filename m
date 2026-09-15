Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA73BBFBA
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478530; cv=none; b=Pm8Dj8e3uMfcQz8FjQQlyxDZ4/2cS7syrQyFIT4gwvaoVFLL+D7EMTMCKoaMpLT/1PkNcAzR8XxS/hPHzXysNMJXDF55X/3eIT4EHpXyqq477xjVxKx/OyDfL+VWxkKfPJv3JwdwhMPNeG1ZiwdgdabH3ozdHdIFhzMAgG96k5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478530; c=relaxed/simple;
	bh=hWGsPvDG8mr12tWw1l+lbVfpm52vTVvs4O0TwcuMmZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR0i5yLlXwHL/V5kn4/xS3rRuGyuTybg43bwLacN5Dt2UHpdSzQbTgE60TTO7zGqvRB9jJioeOGn67akH3V188qoZd3fdneqMvXKVHCy6ySl27asSJwPJqgcDu5l07/CWt/A9J/OhmPib5yIkXNGJibjcHV30wPqbLNLrVvEt24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BpmvxbV9; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BpmvxbV9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Z3qD+/A7jhv0PWCPSvpwUGPxq8lg0rVk9lWjUUhnDS4=;
	t=1789478528; x=1790688128; b=BpmvxbV9UMvU/NvxmRCXsGVTN4+hkakWZjhp9fDPxltHqMe
	6Mw7uQdwo5lMgxE9Cx43NN+T4GaNsmzhzAnD6zkat15CTNvWEdR1Qq0NDVffoQ8PT1Nact5jZl4ZT
	JZ+mku6UgNZSCfLvBNDswvdzpAyZJ4uYKdUQVUsfA8Xt74zOg/av8+N5XPrf79lnGcxNPMqQ4SNtp
	3UFmQ1yDjP5LdN5HUs7+tAfev1q+KaAl+Qf86maBliHy21qMErewuy/Y0eoC31HVFK9m4lFEgA4Py
	fZLMnPPmVmbBNpx7iPJgv35sR5RoTu52Qh3TCSRNGHSxdL+ksdhJjQbFC450f27w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x6T6n-0000000H08V-3olp;
	Tue, 15 Sep 2026 15:22:02 +0200
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
Subject: [PATCH wireless-next v4 8/8] wifi: mac80211: pass error station if non-STA transmit was requested
Date: Tue, 15 Sep 2026 15:19:34 +0200
Message-ID: <20260915151925.92499fb21e4a.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915131925.1780764-10-benjamin@sipsolutions.net>
References: <20260915131925.1780764-10-benjamin@sipsolutions.net>
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

v4:
 * Fix typo in subject

v3:
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

