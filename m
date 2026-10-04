Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3A548FF6D
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140495; cv=none; b=iUmcF37gZJdy4tjCi6CIX2ISQvNX7lEyHtfA0Hft81JAoBH2Nj/EO9utgU8m/eKcAaMQkGzmdRicS/+PTBU6byAOwCD7zIMNRkpSvA8MFENpw+3rz0Bpy9HfTOV/hNj5WpdEnx1iMwFCSN6WWt8Te1fL5qTuCyCjp2Pggc2VUBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140495; c=relaxed/simple;
	bh=J5A1nt6TWrjujIRoC1yhFZd6e8DSvu19y4hYXBBqV+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZO8FFAAfZqKDyUOtF3eyibNbLQECzapBirKz8gYsj2g59LJFLo/AGV6OeeCUYg0b1FmpGn5U1sSlApijilqa/14d+raqFNv0oJn7X06rLSs3ov94Bb0IQdERFT7wOtylH9nb+PunSnHNuy1jMW7Bg7mUqcz1IVDeIXisntYQt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bNT844x1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bNT844x1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kHaYKqFTgGuYFqB3rL3vHe1fkTCH8VVcCAxkszpVtEY=;
	t=1791140490; x=1792350090; b=bNT844x14uIquqO7v4vy7PfChLUoBd8veEVtRpralX5/B28
	vYIv+qDnL9FteCgvcetnlT4S8/AkslUMFu6mYDGFSf0Y6OIRIOAdkvyLx3HIcGQWxq3TJ2Nnjj2kw
	EuNkpS9o8AU4h1UDlUDN1WOk8yvsf8rVnJCqNIdNlfYRLJOfaOKHRqnMshIL7Q8O/vJ0lilQXkMbS
	aTr8nZ0ma0DpH9ESRFt1hsMMOaAJhVBF+oU29uzZiAH/QdHJjqikF0mdnbY2wVgZFwjZ4VyVsLJxP
	rMOr204nNy0t1EoTJoVd4NbdxdPRzMpdcYqabhbyfXobNkQwYebVDO8p0F0+Q4qQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSg-00000004Jlo-0W8d;
	Sun, 04 Oct 2026 21:01:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 01/18] wifi: cfg80211: track netdev running state under wiphy mutex
Date: Sun,  4 Oct 2026 21:01:15 +0200
Message-ID: <20261004210122.90fde4e42da9.I9ac8bb8e7cd07c962116949aa0c56aab4e87839b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
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
index b603f1804cc2..9cb536fc8cb8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7233,8 +7233,9 @@ enum ieee80211_ap_reg_power {
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
@@ -7398,8 +7399,6 @@ static inline const u8 *wdev_address(struct wireless_dev *wdev)
 
 static inline bool wdev_running(struct wireless_dev *wdev)
 {
-	if (wdev->netdev)
-		return netif_running(wdev->netdev);
 	return wdev->is_running;
 }
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index dc1e0522340a..805b0958daa8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1824,6 +1824,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		}
 		break;
 	case NETDEV_GOING_DOWN:
+		scoped_guard(wiphy, &rdev->wiphy)
+			wdev->is_running = false;
 		cfg80211_leave(rdev, wdev, -1);
 		scoped_guard(wiphy, &rdev->wiphy) {
 			cfg80211_remove_links(wdev);
@@ -1854,6 +1856,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_UP:
 		wiphy_lock(&rdev->wiphy);
+		wdev->is_running = true;
 		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		switch (wdev->iftype) {
 #ifdef CONFIG_CFG80211_WEXT
-- 
2.55.0

