Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E07D218EBA
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787148211; cv=none; b=USHJfeKfJ4QXb9ycXUpQbhlGMcfa3MGsQeIgZkl0ap7M51g3IXd/O2CXuTnp7qA+ECYzlcJboHx/7lSMRTtuF1c+jiidrQgkhFJBmu6rnDKo9+HuDsRh+OLJIHnRm8r5GW0OmjQkwpPBHbIu5gqoU4A66wgJ1eHoODFwFpJtMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787148211; c=relaxed/simple;
	bh=Q3MhCxwPJGpjQJKMyrBLuzgawCo0Yl9l/5BLvIPctJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBZ3NDxFaLK35MVOuXJXyZtMKtYSf3m/QewL3tfF1KM0dySybIuNB4J+Nof1s0CYOTyRBypBb1kIAn5DL+xW7xAoAf2AsKqCCzOj9Z8CEw0xPN00gZWfuzfRgXsPnqVTIMdWRQexolRt02ZMDvSwA54ZvG9WzIRy2SXOTAkiZ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=N6zaUr2V; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="N6zaUr2V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iTTHacjo3JAjq62LysYrValW8hFSvyVEKw224joKbQU=;
	t=1787148210; x=1788357810; b=N6zaUr2VjDhC5QCEtOF2DBsoFFgRm1aqqvx44PGylIjSyUj
	uyWNTijQIpL4aRhizJ/5Y38oFJ2x5XmvskHatrdRTd9YjAGmF+eXjVRsimHG0GIpQpD9Q77o8/D7P
	hQrRksp4N9SXgwxwkaqcPtWuW88IH9V5ycElq7I9xl2tkFX9O6icMX/Q8abcZGEqfxw1+q9MNqXpS
	5EsAOo4oQXOUMhPMYOCt/a+q6mppZ8de5FiugZxETEk5w4xwPq/ycaA/4KOW9TlUVfZ63c8yXT7to
	+ZU4eWiuWSChY8nFigShsjx9a5L/a5UjxGq5asGfR3PXmPCJaw4hBCkp1ageJ6Xg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wwgt2-0000000B7qc-1K3P;
	Wed, 19 Aug 2026 16:03:24 +0200
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
Subject: [PATCH wireless-next v3 8/8] uwifi: mac80211: pass error station if non-STA transmit was requested
Date: Wed, 19 Aug 2026 15:57:12 +0200
Message-ID: <20260819155703.64912484c2ba.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819135703.4072215-10-benjamin@sipsolutions.net>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
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

