Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863503;
	b=pB9fTdAapvp+CFHUqo5dV9hMYxNgLtwxZdbNeqLU/RFeguj75aMwfTb/PUGp3qoUClDI
	 FL2J4w3WRrnTBpvhwCshwmKp4fvtoHEZGvwHdSfjl0sQ5+g0WdUs662W1zWJ3TsB0HXml
	 59iTHb7afRlzZQeqZacAuFgr/aTduOYSSa0lUG0p0grIirQknEMHTB6MSAw+mLkxXl4gZ
	 nJyDvJurCxMT4cGqhB3+Snw/52gOCU6gt+A9zVCwtKRafpZ1PfbdqXiNOFWhKOuh+CgLo
	 9TVzAu4Ve5ont2rTXlCRxu1sYemoMwPPNiMQ8rzJVRTJZbQg7VgrC8D8G8i9fp0B+/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863503;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UiGdZD80y37KqWu1IGFvaquLJHRJodWi0r37J76J66Y=;
	b=a0BoK25YHKdfQn8oh4X0bIa0yMvldQm1vgsydLSVUuSGV2JYvg7XlpUY1tZTdnjsn3/m
	 eiFWpn2sp6eb2c8zwGiubj2tgmZQUaXAwLtVE1ZNVjCqlLnOWrqoKtyW4WXyVvHGMUfIk
	 4fcoLJwPoOE2RO46UTvtLi2j5VM85V/3VS5xECdOH0574l9qi574kzoJI5FP1fmyEqiOp
	 qIQMrqUNeVjLQY8Z3Et5a7cKjcTWxrg86iGm3PKO0X4l5OjmY0FvttqiSeJ9jr7+xirJ9
	 NbRqJ7ohFYfk6up2958s5y2G6Y2S2k/qUMGdf3ZdiErFJAP1iWzNH2ipFxVc/it53Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kGayVkMs;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D7B606D80C
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kGayVkMs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UiGdZD80y37KqWu1IGFvaquLJHRJodWi0r37J76J66Y=;
	t=1793863502; x=1795073102; b=kGayVkMsoPnYwjXK5RCk+IyB4T0yxQzrIU0yQFNgnBhWpGo
	/611HAmpRPdlpvfLEc4qqEY+hnbTA+0JNmoocnNA1AWNmx2sOk6W+XTktCCw4dmc2qwj6ei3/9/3J
	1m49xc6r3dJql5ey0p5DMouNUr5jJX4coMoyleDlKq7Jje58v4k9L7iNb0uH4vtBNQKWFb46qxMip
	MwpXTRi67IGpNFqNJLRCKvOC+lwf5MuDrW2ncUi4ueQzjvZY80KZb9MMiQlXVoJz63me95M06sl5b
	SS23MOkMwSD2MvfOmDuq0C9HVJqWzx/OkxEIh0wJ/m6oVdKyggHIfo5y3/QRqDBw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqF-00000007Ped-34r0;
	Thu, 05 Nov 2026 08:24:59 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next v2 6/6] wifi: cfg80211: fix regdomain vs. wiphy registration
Date: Thu,  5 Nov 2026 08:23:54 +0100
Message-ID: <20261105082451.ad7f9d872e6f.I68140f259882756698561ad3b94793b6ea57e5d8@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105072451.1710800-8-johannes@sipsolutions.net>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
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
index 2bf3bcd8809b..c009ecfd15e9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3237,6 +3237,10 @@ static void reg_process_self_managed_hint(struct wiphy *wiphy)
 
 	lockdep_assert_wiphy(wiphy);
 
+	/* not registered yet, apply later during registration */
+	if (!rdev->wiphy.registered)
+		return;
+
 	spin_lock(&reg_requests_lock);
 	regd = rdev->requested_regd;
 	rdev->requested_regd = NULL;
@@ -4146,7 +4150,8 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
 	if (ret)
 		return ret;
 
-	schedule_work(&reg_work);
+	if (wiphy->registered)
+		schedule_work(&reg_work);
 	return 0;
 }
 EXPORT_SYMBOL(regulatory_set_wiphy_regd);
@@ -4174,30 +4179,28 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
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

