Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63ED3B7749
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281239; cv=none; b=EWVJH7Uj73FWibN+jhfiMajgOuo8CVBcUQ73RgISqOVmiNHpYF02RMbdiiPq0QG7NaUlDBNewqCXaVaIy6tuD6qPKN208qxR/GmqR+9dkyRD0aFzrwz7u9oFGyHUVA3r2JV3ORlHoYCOhS29xoLApGELhLxwxPDF8o6OAeDDjrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281239; c=relaxed/simple;
	bh=1vRxpT7dE8Rigxf0PYSrQJRNAAtsyaaJH15CuNdOkK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypdx8dIGeIwDHOf7LHoMSJJ33tmBIIWABoCzjRZeBfalzLLp9XuUqomIRD3739hbu+/EKG/bL0lIXEnj+HoQ5VC5PWkUTH9mzJDtdyLXpDmscLtwQbk/3J5AxfszRsYZyauGxCAr+l0mVWTtsgEI9432c8kmBP4/ZIQZkuiEArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZlJq/Jqo; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZlJq/Jqo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NHD9gkSFfDYFdJU2FRTFBhjWbaIVU2ilp0FT3Mv4jlA=;
	t=1791281226; x=1792490826; b=ZlJq/JqopTvmu7qIDOOtuPzv93u2Kq8xxmxMKjn8zI73aGw
	VKuXOyIDQELpjdOJYExtzY1uGPf4ZNdup60MrDYvKuSqWz2urac2xctCibz1lsYNs/H3WTtcYSi7V
	aTVPy+zBIkQj2XtNILzVLaoRj1jDGMkgCufOQW1t7B2q77hEc1M5ejorNhe0Vry3x6/HF8VKJca4z
	U8JNZsXBmoWrCNDNQGlghRKLj4H6E3vPlx9LsETG290Eehx9qa5NJQX40y/cj16iFC8VTd5g38bSl
	v8wt0KNu4JghChfci8p93weQVc/aMKr/UBBCYUqsVgRczGfZkHnXeRA2OT8ML3yg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24d-00000006XqW-3jFX;
	Tue, 06 Oct 2026 12:07:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 02/19] wifi: cfg80211: track netdev running state under wiphy mutex
Date: Tue,  6 Oct 2026 12:04:00 +0200
Message-ID: <20261006120655.7ed32b42c297.I9ac8bb8e7cd07c962116949aa0c56aab4e87839b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

wdev_running() uses netif_running() for netdevs, which
can only be used under RTNL in a completely race-free
way.

Track the state for all wdevs via the existing netdev
notifier so we can check the state under wiphy mutex
in later changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 7 +++----
 net/wireless/core.c    | 3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 92f0dcc4a35f..c6a606b6b26f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7242,8 +7242,9 @@ enum ieee80211_ap_reg_power {
  * @mgmt_registrations_need_update: mgmt registrations were updated,
  *	need to propagate the update to the driver
  * @address: The address for this device, valid only if @netdev is %NULL
- * @is_running: true if this is a non-netdev device that has been started, e.g.
- *	the P2P Device.
+ * @is_running: true if the device has been started, e.g. the P2P Device;
+ *	for netdevs, tracked under the wiphy mutex from NETDEV_UP until
+ *	NETDEV_GOING_DOWN
  * @ps: powersave mode is enabled
  * @ps_timeout: dynamic powersave timeout
  * @unexpected_nlportid: (private) netlink port ID of application
@@ -7407,8 +7408,6 @@ static inline const u8 *wdev_address(struct wireless_dev *wdev)
 
 static inline bool wdev_running(struct wireless_dev *wdev)
 {
-	if (wdev->netdev)
-		return netif_running(wdev->netdev);
 	return wdev->is_running;
 }
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 45a1709cffe7..fa56208f8c8e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1836,6 +1836,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		}
 		break;
 	case NETDEV_GOING_DOWN:
+		scoped_guard(wiphy, &rdev->wiphy)
+			wdev->is_running = false;
 		cfg80211_leave(rdev, wdev, -1);
 		scoped_guard(wiphy, &rdev->wiphy) {
 			cfg80211_remove_links(wdev);
@@ -1866,6 +1868,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_UP:
 		wiphy_lock(&rdev->wiphy);
+		wdev->is_running = true;
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		switch (wdev->iftype) {
 #ifdef CONFIG_CFG80211_WEXT
-- 
2.55.0

