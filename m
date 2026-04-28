Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C8138B7C3
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368441; cv=none; b=kjzQvDDcQFp84c1f/VuWyeiFtNIUbdkCUlplXZuvyA6uyE+Z8hpWXxDoUKztmhqxvyhPvOTcJ3wV5IR3GjI1QxjXqGWgBNhAg6q6CSaZoKeUBiJpFXFe4MPMRnzV6WLRFBspVPH164rbZh2SEaJ255k3DE7nX4+sWtl4rY5rAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368441; c=relaxed/simple;
	bh=a1r06fBOvQxwEZ3UQW8S799Hii7eQGSEwKebl7YjxJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iet9JwkQCWzNr/bKoM29Hg/66ORPcw4z7ISUTS44cI07zNHp1xZkZ1AqD5vD3Q8Uy9rzYzS6j+HjsuTjrZpTGE9T7jTS0Fa+zGxNg5/lKAYAGVmfoLxRkip0wNlMbbSciaO9Q4aUh9k9Mnyl7/e3vv0hNnbk1ByKQ4lON6CMOzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=O2ggMfnK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="O2ggMfnK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NuBoAFPIQ6P9hUCItx0SjOwtURQ2+XkRFWiFN5ONUKU=;
	t=1777368439; x=1778578039; b=O2ggMfnKo8IwGJRJVezWcKp+P7QMID5c+NZeA1ng4leUcpO
	MYg+3bLtWt9pkBTgMujPWY/4yLwehiJFE0cwxc15j3l5dthIJzpoBP/kmt6n8sW40M52hadR9C+p3
	JraqMMNV/CMVCK7tVjmZEw+dNsvkczBcmqI3Ik6aARjnHuq7Cw9xMMnrmIZMbk2/oMVneYuKwC8Hh
	5mO0FYBSuHWI/qNWxMGcHTzpJClRRrvaKHhgPNVwI5LaYN1Tz4uwjuRlMZEiXtMgcVOR3YLAbQKvG
	CyZd+FbH4aCecA+cWTOp5q390Hg2zijYESbE6JsmnNfO5ZbiBaFCSps09YGb8oPg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeiq-0000000HLwg-20UV;
	Tue, 28 Apr 2026 11:27:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 05/14] wifi: cfg80211: add helper for parsing NPCA to chandef
Date: Tue, 28 Apr 2026 11:25:33 +0200
Message-ID: <20260428112708.5cdc4e69a306.I95d396ac671da438f340b1afb735ebfe33164894@changeid>
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

Add a cfg80211_chandef_add_npca() helper function that takes an
existing chandef without NPCA and sets the NPCA information from
the format used in UHR operation and UHR Parameters Update.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 13 ++++++++++++
 net/wireless/chan.c    | 46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9e66490dab4f..2546567792e2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1150,6 +1150,19 @@ int cfg80211_chandef_primary(const struct cfg80211_chan_def *chandef,
 			     enum nl80211_chan_width primary_chan_width,
 			     u16 *punctured);
 
+/**
+ * cfg80211_chandef_add_npca - parse and add NPCA information to chandef
+ * @wiphy: the wiphy this will be used for, for channel pointer lookup
+ * @chandef: the chandef to modify, must be a valid chandef without NPCA
+ * @npca: the NPCA information, can be %NULL
+ *
+ * Returns: 0 if the NPCA information was added and the resulting
+ *	chandef is valid, a negative error code on errors
+ */
+int cfg80211_chandef_add_npca(struct wiphy *wiphy,
+			      struct cfg80211_chan_def *chandef,
+			      const struct ieee80211_uhr_npca_info *npca);
+
 /**
  * nl80211_send_chandef - sends the channel definition.
  * @msg: the msg to send channel definition
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index fae71f2d13ed..70fec444955e 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -556,6 +556,52 @@ int cfg80211_chandef_primary(const struct cfg80211_chan_def *c,
 }
 EXPORT_SYMBOL(cfg80211_chandef_primary);
 
+int cfg80211_chandef_add_npca(struct wiphy *wiphy,
+			      struct cfg80211_chan_def *chandef,
+			      const struct ieee80211_uhr_npca_info *npca)
+{
+	struct cfg80211_chan_def new_chandef = *chandef;
+	u32 width, npca_freq;
+	u8 offs;
+
+	if (chandef->npca_chan || chandef->npca_punctured)
+		return -EINVAL;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return -EINVAL;
+
+	if (!npca)
+		return 0;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_320:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	offs = le32_get_bits(npca->params,
+			     IEEE80211_UHR_NPCA_PARAMS_PRIMARY_CHAN_OFFS);
+
+	width = cfg80211_chandef_get_width(chandef);
+	npca_freq = chandef->center_freq1 - width / 2 + 10 + 20 * offs;
+	new_chandef.npca_chan = ieee80211_get_channel(wiphy, npca_freq);
+	if (!new_chandef.npca_chan)
+		return -EINVAL;
+
+	if (npca->params & cpu_to_le32(IEEE80211_UHR_NPCA_PARAMS_DIS_SUBCH_BMAP_PRES))
+		new_chandef.npca_punctured = le16_to_cpu(npca->dis_subch_bmap[0]);
+
+	if (!cfg80211_chandef_valid(&new_chandef))
+		return -EINVAL;
+
+	*chandef = new_chandef;
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_chandef_add_npca);
+
 static const struct cfg80211_chan_def *
 check_chandef_primary_compat(const struct cfg80211_chan_def *c1,
 			     const struct cfg80211_chan_def *c2,
-- 
2.53.0

