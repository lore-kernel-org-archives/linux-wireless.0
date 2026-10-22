Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664329;
	b=YBLz1786zBc3Sd0W+yN/JrZ6RuRViTZ6NdqUY7P7dehisQtsuzoglYtpN0bu43lVxJl5
	 4b1I3AVI72LsF8od2IpghT8vManZtJnubei/lRrTuQ1aPrt5zY2RY+7qUaiy4jjSOQTov
	 nN2QIbWztZE0RCxJQ1AjvBbhW2znJTOozDxdfy3FU4JLu9FUzgmZrK6Ma4yDfQ1s9G4YF
	 N5QgnNHhVRoVFBly8dM+FaA+3KzsmJ7UDxamNE1fPSigDdTdU004x2GS8hm/SkHdJX8GY
	 gcjOkCEyVzJXaHOw8DYV+zd7tOOFahhppBhUGecBek3y4/z6Tn9rtsv3T3NUOh4/Dxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664329;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HHMQv2AHMM4W7lB88T9qkuYT7LxDVCsFqIlkSzNQ+ZY=;
	b=icGF4i12wxkQFDNArEPh9YvHOSZIjUZh2C2uZLwxxRgK+cRlV7N8+phydr2JkzCUWJNm
	 awqeUnvCjSLqllCkWufnReKI4QuL/XUSXVw4VTV8srEknxNLDJztAFFK1p+mKOEOZTFtq
	 yKYvS5vsBR8no1GL++a38m9wwnxrUUZ/NYKBejvs8g4r1A8BMLIA2PXgH2jPtAz3Db+QI
	 +Et6P5YFCsEa0OWiqOwiqH0xlaPzwESOaN1L5hOGUoX0g4V2ZihYUItCKrXLamoG5VLBm
	 g725uyW+nShIUlI1FNGbwhNNoX+LRGfpkQ2/pRov+aD1zYsOX9okUXEjjsSHYpxalyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=b51MT4F4;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B15606A323
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=b51MT4F4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=HHMQv2AHMM4W7lB88T9qkuYT7LxDVCsFqIlkSzNQ+ZY=;
	t=1792664328; x=1793873928; b=b51MT4F4VJ7++BnwRXvrAVWwGZzaQdfngvZFsEZ+IejZBVt
	wgNTPJQV1ErxIXnj6avtwMKilO5vxTfLzlWcMdDt5Rz89nsQ/fXYxEwoVlPrvDyTxV1XINzqRiei/
	jC0UHKsrhbPWAi0EU4saamfuQBzP3tED22Wmo/uaWLxV8Fq+MKjr8WjbCTyrIAVfRtmU8BOIKwMfL
	pzj/nb9utdNhiXbqrR3HVxFtSCzu1t2Hfu7eWEyEI8e+B9yJq1parchr7F1JWG/8/YxWi3jtH3fB7
	vF6d+NgOrZpnHZVAWojxUe46DonhhXcz2hw8VB2gnWuBs560mim9t4B5lCM3yR4Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsk-00000004Ifb-1uAv;
	Thu, 22 Oct 2026 12:18:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 6/6] wifi: cfg80211: fix regdomain vs. wiphy registration
Date: Thu, 22 Oct 2026 12:15:37 +0200
Message-ID: <20261022121836.296cc02fac3b.I68140f259882756698561ad3b94793b6ea57e5d8@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Setting the driver's self-managed regulatory domain is
currently applied immediately, even if the wiphy isn't
actually ever registered, and (for some broken drivers
like iwlmld) might not update channels correctly since
the regdomain is set before the channels are linked to
the wiphy.

Regardless of broken drivers though, it doesn't really
make sense to apply the regdomain on the spot, if the
wiphy never registers we don't need to do this work,
nor does it make sense to send a regdomain event for
a wiphy userspace doesn't know about.

Change it so that a regdomain set before the wiphy is
registered doesn't cause any action yet and is just
remembered and then apply it correctly when the wiphy
is registered.

Also WARN if a driver registers a self-managed wiphy
without a regdomain, that just leads to confusion in
userspace, and a later WARN in nl80211 can be hit if
it queries for it quickly enough.

Due to locking changes this also removes processing of
self-managed hints for all wiphys when one registers,
but that never really made much sense anyway.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |  5 ++++-
 net/wireless/reg.c  | 45 ++++++++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..9d586a3e2b44 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1259,10 +1259,13 @@ int wiphy_register(struct wiphy *wiphy)
 	rdev->wiphy.registered = true;
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
-	wiphy_unlock(&rdev->wiphy);
 
 	/* set up regulatory info */
 	wiphy_regulatory_register(wiphy);
+	/* TODO: make this a hard failure when drivers are fixed? */
+	WARN_ON(wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		!get_wiphy_regdom(wiphy));
+	wiphy_unlock(&rdev->wiphy);
 
 	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request = {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 87eb581aee34..2ac6a0f312ad 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3235,6 +3235,10 @@ static void reg_process_self_managed_hint(struct wiphy *wiphy)
 
 	lockdep_assert_wiphy(wiphy);
 
+	/* not registered yet, apply later during registration */
+	if (!rdev->wiphy.registered)
+		return;
+
 	spin_lock(&reg_requests_lock);
 	regd = rdev->requested_regd;
 	rdev->requested_regd = NULL;
@@ -4144,7 +4148,8 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
 	if (ret)
 		return ret;
 
-	schedule_work(&reg_work);
+	if (wiphy->registered)
+		schedule_work(&reg_work);
 	return 0;
 }
 EXPORT_SYMBOL(regulatory_set_wiphy_regd);
@@ -4172,30 +4177,28 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 	struct regulatory_request *lr = get_last_request();
 
 	lockdep_assert_held(&cfg80211_mutex);
+	lockdep_assert_wiphy(wiphy);
 
-	scoped_guard(wiphy, wiphy) {
-		/* self-managed devices ignore beacon hints and country IE */
-		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
-			wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
-						   REGULATORY_COUNTRY_IE_IGNORE;
+	/* self-managed devices ignore beacon hints and country IE */
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
+		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
+					   REGULATORY_COUNTRY_IE_IGNORE;
 
-			/*
-			 * The last request may have been received before this
-			 * registration call. Call the driver notifier if
-			 * initiator is USER.
-			 */
-			if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-				reg_call_notifier(wiphy, lr);
-		}
-
-		if (!reg_dev_ignore_cell_hint(wiphy))
-			reg_update_cell_hint_num(wiphy, 1);
-
-		wiphy_update_regulatory(wiphy, lr->initiator);
-		wiphy_all_share_dfs_chan_state(wiphy);
+		/*
+		 * The last request may have been received before this
+		 * registration call. Call the driver notifier if
+		 * initiator is USER.
+		 */
+		if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
+			reg_call_notifier(wiphy, lr);
 	}
 
-	reg_process_self_managed_hints();
+	if (!reg_dev_ignore_cell_hint(wiphy))
+		reg_update_cell_hint_num(wiphy, 1);
+
+	wiphy_update_regulatory(wiphy, lr->initiator);
+	wiphy_all_share_dfs_chan_state(wiphy);
+	reg_process_self_managed_hint(wiphy);
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
-- 
2.56.0

