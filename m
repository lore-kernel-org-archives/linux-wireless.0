Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC3B407CEF
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760276; cv=none; b=tRqD1JkOY9E67fQA2Bx0Orkql/aihhyJotKJq5+8NF3pxhVxvjZu507f+vecEzYHHGyaPNh8u2fYpbcK6izkQAZKWH13VMHjWuNnvGnkFEdZJ1nJGPEgT1yEd7J+xg6qLZ3f6ZR9s9We1fPp+fmxmPR3w8EvkxDCNwItmrfcGdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760276; c=relaxed/simple;
	bh=e88oQtFlR/gisAH/gbY2Y5+2RpGTMHb8JdyNcHvp6mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X20Mv2HWCuGxQeRf0I1CAsPjGEClvKMx08a/aPrYpZsY1vC4i/0Ow8N3X4Hv6Ud1A2cLqhjsLe2dpMqCxb3G5kjJisM1rsZlZuFJI2Ji+jkEOzG7IUcnpOOE5t7DHFB01txfMfmoyB/ouNZjx+lVd89AectrlbH7l+auIzSqpM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ECFMVsKU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ECFMVsKU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nvN8oiUGeCjQc0TXwf/FrdwVTlvIUYUbhBIran0XVWg=;
	t=1785760274; x=1786969874; b=ECFMVsKUQpgxjogwy5s0zHmCgxJsm58+4RklHB0/7Fdt+p5
	eCOUqFnQ3bsqpPtMTxXsLPpmUA8k9Xqs6zEbERNTpjieHLQEbebNwxfZPYICbnndO74HRn7tz+Fg2
	ch13KO+VIKuArNgD4MJVb+YxmmeqjthcARVfMZpSC+5K06DIiZqYOsHDpLtdebIVWLW7VnMWYVVQF
	e6Y6YgQrljrNN9ZnZdxNKS5z1/UsOYA6n9ORiB9xmnaNHz5IsJxGqun+UDWDZQ13pW8ZLE8T+Uuah
	8egZfcvBVtfxf7KSBMQdFEwVWLYStRLCdUzbGHfPy27TfKY3sR0O41QQKxAsGk+A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqrp2-0000000CbZU-0ekQ;
	Mon, 03 Aug 2026 14:31:12 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 8/8] wifi: mac80211: pass error station if non-STA transmit was requested
Date: Mon,  3 Aug 2026 14:30:13 +0200
Message-ID: <20260803143005.e05860849ef7.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803123004.281626-10-benjamin@sipsolutions.net>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
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
index 5cec8747b193..653710576831 100644
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
+				     params->no_sta ? sta : ERR_PTR(-ENOENT),
+				     7, link_id);
 		ret = 0;
 		goto out_unlock;
 	}
-- 
2.55.0

