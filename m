Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F6463B76
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194737; cv=none; b=eKGC0ymjdp0OKYMyEH40ywQm5SEQP69nStMdfTOB0uvgXHDBim77BCDJsxc12S4pC7JB5NCzGJIR9Z3H3HTOH/i5xapw7v36KK1SAf+eipo1SOovbzXNu6m8PRNwIZEVANikWQDMPWsGSv7RiH0//b7qmt1o5YL9/75gGLD0NC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194737; c=relaxed/simple;
	bh=J5A1nt6TWrjujIRoC1yhFZd6e8DSvu19y4hYXBBqV+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qb4JW4DLBOadwYNq5sp1RnsiRtvRqKNHwsq5VH2d8bKBTLZzTG1EjaY6D2pl4SmhhL5YfHhdyPDye5d7ZtJw/JlbV2EkxTIR1tA1evFZkbK1j2psZNW7/MQpsp80m8d3f+Qnz5Bc6SAjsBbN706edgvjRLR1pVrSMk2emzB9GWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kv6A14X5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kv6A14X5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kHaYKqFTgGuYFqB3rL3vHe1fkTCH8VVcCAxkszpVtEY=;
	t=1791194735; x=1792404335; b=kv6A14X57WEJasxRdLDpw2til+diDJXoS/pX7yBUHCx5vru
	1zumMlJkRJwlkHc+khDq1AfP7HwQsyo2SNBermxBSYy1U75oa0WQhb4WqSWWzNovUhwlWy7PpZRhK
	upMXVI8+FhtT6r0ZI2Uf+41ojjUu3ZL02jwUJVvyEWyWlMmJbariA//gLLuAGU2nn+VXFBEUOwXni
	EDjUVFPTwCh8XIX5j4dT7To7f5eYPnZoTFxIjuQ4vQu0GECvvEYoTPfeM1IFzYiPI632HgOBdguQM
	J33ypQfyScQ6quH2G8zC0S8dOlS98bhsYTM3ElXhT7KraONHkrwlqoz6dzn/RPnQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZb-00000005Bml-0fjj;
	Mon, 05 Oct 2026 12:05:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 01/18] wifi: cfg80211: track netdev running state under wiphy mutex
Date: Mon,  5 Oct 2026 12:03:28 +0200
Message-ID: <20261005120526.90fde4e42da9.I9ac8bb8e7cd07c962116949aa0c56aab4e87839b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
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

