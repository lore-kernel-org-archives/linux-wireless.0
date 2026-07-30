Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811844162B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422125; cv=none; b=AwDMG017m3I4+KXNZnokuytojtCGOV45qzdPZ3t9G1wdj2uDNpAz1n+cI7wlLkw0IfpSoKT2pjnV8iLZyQIKKG0u9nIiGXdgksRunNsTYeRXyFdc954aZcRkaZ6eJO/G3xjOKkMA+reUWpu0THl5GcTB7hbItv8/CDM8T/qK2OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422125; c=relaxed/simple;
	bh=7kyXi0jcGUoy2dLS1hUgFMKHdsRFcvFjLniiRy0H13M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d96tERYUY1bYzb3ZMI0WC5djghi7b3n8JgNLJWVRE/Hqt5akLDIyvFuWrGhV6Vbn7fyQsFMu6nBgS+DY2zbQSdbzCJyq98PMtRFJNgVstSUlXHEVlLkmjfE0/zDNhHnHx7NeuKhtCZrm9PMchv6d0QHEFYLbXGQ/bA4aXRocFpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Bmajnd3W; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Bmajnd3W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+9xpFw0wqEVWWEAzU3lf6x9HB/OT7k/1x4YCuibARxE=;
	t=1785422124; x=1786631724; b=Bmajnd3WaFjlBvpC+T/CO2hMvfu8ppC9IAoFTWzzDirpMuH
	TEPy8bJ0UMYKPh7W9+HfVpbNZu1usJXw+VVzW18I47drkPOdpJbUQmgIIS8XNn5lVbOj/fi34yvb9
	9wGXA75oHIHLmvenqz4zSfbnnQF1sNjYy6Tisx01l0ZJMEwQpAmtznH8MSWPluiMz1V5VlK00HOzK
	76tt699pB4MeSe6tLnNk+3tVPbjuf+jFYaSDRWps/5fOYUTcOIsnmRHZvRl+UrRivz9pB/OFZeQhu
	KkllEe42T61yBj1fw7Qdczz9XmgG0/O2L34u85H50ENWBn8wtxQqikLwtQUgeZ8A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpRqx-00000004mKH-3IKV;
	Thu, 30 Jul 2026 16:35:20 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Jouni Malinen <j@w1.fi>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 8/8] wifi: mac80211: pass error station if non-STA transmit was requested
Date: Thu, 30 Jul 2026 16:34:24 +0200
Message-ID: <20260730163415.3690583c0990.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730143415.1833312-10-benjamin@sipsolutions.net>
References: <20260730143415.1833312-10-benjamin@sipsolutions.net>
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

v1:
 * Only pass error station if NO_STA flag is set
---
 net/mac80211/offchannel.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 272418650be1..3834f596af17 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -856,8 +856,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
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
@@ -886,7 +888,8 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		     local->ops->remain_on_channel &&
 		     memcmp(sdata->vif.cfg.ap_addr, mgmt->bssid, ETH_ALEN))) {
 			need_offchan = true;
-		} else if (sdata->u.mgd.associated &&
+		} else if (!params->no_sta &&
+			   sdata->u.mgd.associated &&
 			   ether_addr_equal(sdata->vif.cfg.ap_addr, mgmt->da)) {
 			sta = sta_info_get_bss(sdata, mgmt->da);
 			mlo_sta = sta && sta->sta.mlo;
@@ -1031,7 +1034,9 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	if (!need_offchan) {
-		ieee80211_tx_skb_tid(sdata, skb, NULL, 7, link_id);
+		ieee80211_tx_skb_tid(sdata, skb,
+				     params->no_sta ? sta : ERR_PTR(-ENOENT),
+				     7, link_id);
 		ret = 0;
 		goto out_unlock;
 	}
-- 
2.55.0

