Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421E247533F
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194749; cv=none; b=E20aAHlN00m+JkGJg74NJ6aVCw4GxK7HW9MDIRR2M3zYsPMf0Nm7+uxqGVa3wwj2ZXk3gFgXUp5j2yoebJBlZZF8G7VjVCcLuKFis1QTt7b4A6ym+7fgcbztKvBT1fYX29I2tO5ooeEPuZu8s7zNs2Hq70GWGKjiOutpKbSAVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194749; c=relaxed/simple;
	bh=DfTWEuOMImKf0DmJ7/jVVj7JBL/NuiONAR5Sac7DNi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZVdYRtH3ZzZQCBrogyCbugFU789tYKusZG2kZNAzsyKVS5bATWb9Fh4esd8hmcpYYXnF7wvfIh02Bdf4WtxcpIZ0olsF6C7tcuO7TG/spGA5DQz7oIq8TvG9FhNna4eS50F01rcLpfhFysRbzP6njOXJSE6f+vFAowcpaoEjwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hbog0R/R; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hbog0R/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+6qonkHvVbAPPpX5MrIEU/pRdjZG5B9kfbHn/yB/ebQ=;
	t=1791194748; x=1792404348; b=hbog0R/RLWPofMtS+plCdLT8Ny0N4Q2c8avJGSj/qp+L0ez
	E/S8YE5lpzZz8CiA0cGKnGdTdpKHZTbNvDEylmKXbvET+lR61TBXBNf9szd8mhEXcBKa3o/sVtqij
	f5nCMDwlZgFx29daHnHl/uA/boUzBWoVDMXGwT/wc4wY0Rq4/8F/p5/8nz3B203kY6oY3M/Rn0yUP
	Hs5GDMqcTct/ayAzG0gAhfx8FmAqH75BRR8eyc/+wvZE8PXepBE4tKLg/xTBASHg/Oehg+HzPPzcT
	GomT+C5tOUYNOWGN//Z8H0mKhhoLmT9Q2VuCgWXxQwFWmrdDPnGq1mDw5mb2+aXA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZl-00000005Bml-21Wg;
	Mon, 05 Oct 2026 12:05:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 09/18] wifi: cfg80211: document wiphy mutex for radar/CAC events
Date: Mon,  5 Oct 2026 12:03:36 +0200
Message-ID: <20261005120526.fe5960ae72ab.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
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

The DFS state of channels and the CAC state of the wdev is
protected by the wiphy mutex, so the radar and CAC events
must be reported by drivers with the wiphy mutex held. In
mac80211 we do this, but some drivers don't yet:
 - mwifiex/nxpwifi have an event handling worker,
 - qtnfmac also does it from event processing, and
 - mt7915 and mt7996 don't acquire a mutex for background
   radar events.

Document the requirement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9cb536fc8cb8..eb376a54a07f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -9794,6 +9794,7 @@ void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp);
  * @gfp: context flags
  *
  * This function is called when a radar is detected on the current chanenl.
+ * Must be called with the wiphy mutex held.
  */
 void __cfg80211_radar_event(struct wiphy *wiphy,
 			    struct cfg80211_chan_def *chandef,
@@ -9839,7 +9840,7 @@ void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
  *
  * This function is called when a Channel availability check (CAC) is finished
  * or aborted. This must be called to notify the completion of a CAC process,
- * also by full-MAC drivers.
+ * also by full-MAC drivers. Must be called with the wiphy mutex held.
  */
 void cfg80211_cac_event(struct net_device *netdev,
 			const struct cfg80211_chan_def *chandef,
-- 
2.55.0

