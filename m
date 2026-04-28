Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5E0389DE8
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368438; cv=none; b=get+P8LiHMiGeyOs0ReDbb5Mb5UXNwPNEsd3h5izeDxPWe0Sdq97puIerX7IxQY4myovhkJzI1uXsW/3ZxVby4e3Jcq9owBIj26bLKYo6K6bOYMxnxfdESy7Zm934WLHOfLdKovmZfi+E1N4yPPJ4ATiBVKP3K/xqYo/SU+Ty1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368438; c=relaxed/simple;
	bh=RP4N+dsk8V3or+vrvMzkdCZyBzuJQfLtWorLIUQkVRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frGqKL5HBBo2zrLKt0hLUPpOJr97xB06Ot/TjbGhX9WoedqvquceSjji50uYIpU1Z7CaSHl6Ar1/5vABd/8fnk6fjFejcMenCSrpzrx6a13XvS92ZOsZX+MQNrlP7/3txsgzoXliQFm9quprADYhXDmwpv6wKDaJfwn0SfsJMXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iTg0JtTA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iTg0JtTA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WDq0h5LvA9keh+Sy181Ye07f3RlqfamJ64EAgJ/nYG0=;
	t=1777368436; x=1778578036; b=iTg0JtTAHW/kuoNyQ33t+Z9anplNNdtz6N/HHsdq1QQH6A2
	ntTsd5U+cRPrsRLIC1n0wmsS7M4PI87fjHiZuxh8QJ43DJiyMykhM1MVtfQZxzHGUhl0TXcoq9KNf
	ntVXSh84VufZCY42v2/jBrpnr8sxHBTB7PIX7U0cwrMXVcX2R4PfffoSFWjpaHi7qa2UJUvk7uEcU
	phtcbb7DiEa9fv6Quw9KW6NW14KBHL0XLOSvCm8R/Eh+wjXJZXF2npnePAjx/jch/ZmL308zOuQYj
	+gYr1cXQLuTK1Q+tarfr7Zk2XZwYf7gmXOpmJY8PSZr429SUGSQnl10/J7riW1Jw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHein-0000000HLwg-1d8l;
	Tue, 28 Apr 2026 11:27:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 02/14] wifi: mac80211: move ieee80211_chandef_usable() up
Date: Tue, 28 Apr 2026 11:25:30 +0200
Message-ID: <20260428112708.266c56537f81.I0d7266f2961e5bca4bd9f9503c4b1953d92255b1@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428092708.71740-16-johannes@sipsolutions.net>
References: <20260428092708.71740-16-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

For UHR DBE this is going to be needed in the AP channel
determination function, move it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 25c7427e11c4..0bf51774c155 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -149,6 +149,21 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
+static bool ieee80211_chandef_usable(struct ieee80211_sub_if_data *sdata,
+				     const struct cfg80211_chan_def *chandef,
+				     u32 prohibited_flags)
+{
+	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy,
+				     chandef, prohibited_flags))
+		return false;
+
+	if (chandef->punctured &&
+	    ieee80211_hw_check(&sdata->local->hw, DISALLOW_PUNCTURING))
+		return false;
+
+	return true;
+}
+
 struct ieee80211_determine_ap_chan_data {
 	/* input data */
 	struct ieee80211_channel *channel;
@@ -851,21 +866,6 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 	}
 }
 
-static bool ieee80211_chandef_usable(struct ieee80211_sub_if_data *sdata,
-				     const struct cfg80211_chan_def *chandef,
-				     u32 prohibited_flags)
-{
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy,
-				     chandef, prohibited_flags))
-		return false;
-
-	if (chandef->punctured &&
-	    ieee80211_hw_check(&sdata->local->hw, DISALLOW_PUNCTURING))
-		return false;
-
-	return true;
-}
-
 static int ieee80211_chandef_num_subchans(const struct cfg80211_chan_def *c)
 {
 	if (c->width == NL80211_CHAN_WIDTH_80P80)
-- 
2.53.0

