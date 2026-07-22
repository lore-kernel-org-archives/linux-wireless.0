Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6493136212F
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 07:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704065; cv=none; b=SSEofjcAqwhuszkYh9AhquOx/kTZkDtaeMz5ZZizU1Tc67ay1qTo1/CbpPl2ZcOVF7kiZ2wVvzyRgqO768TtPzd1lulPYdpGtbzm5HmnilmIKHoZ2mHYnvC6gGCQPqyy0H1y8b/CxinHUiTF6sPNSpepS0JS3qlAEgwTcBOQqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704065; c=relaxed/simple;
	bh=MgByV0Tlub9VinUkUuHNK72OBiVzMw/nFbBw/Dd/bYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn4gQzdyE3wH3iC/vhn1V+K+w4InDjoB8DKb5UzZuGPv3aobwjnRwd7WMA+RSQwFitC/8LG3hSAD2v4RiE1VgVIHvSndazfjl+sS2L0yG8yjI/uvYzmWU4MOuXOZyx5rIuff+FjgJGlNx06J/LHCHu3HPNORj7icBWpv8u3ims4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3ePY9Wc; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3ePY9Wc"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso20747505e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 00:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704061; x=1785308861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k69g0iM0Xhrh1qoTi7U6OlgKbSMioEAgJAhLpRRzuDw=;
        b=k3ePY9Wcn8d8rb02rKkeP3RHYzE/cgAQyicXARuhA9VQ6eaVa7lth5ev9e0vbh2XZ1
         E8jv0fRBKWF0JWSJU2lxg4vO5u8a5ilTlv7TAAKXFoMfq07w2gaL9VU3OT8+8EDGH0TI
         ZxWx7TjSTL6A6mX3RGRdjlaBie7ASj7tYDzfBuc5gLF2DGoDg8HaCSy3EFMRGBRBJt45
         0Ouo/skqUkjXEYP4hwjsjS51NxW9U6a6qQ9rPYzQfNqoUU7DB1tjcD5PygXtSGMNqIgL
         JHXK8q5hGsMimyfe2c/e9f+wOKBmf32utwBLz95EM0MSBSTcKWPRRIFwdgcKAVEEEmtu
         hO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704061; x=1785308861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k69g0iM0Xhrh1qoTi7U6OlgKbSMioEAgJAhLpRRzuDw=;
        b=AUy5LgTL6bHpO4ZUMa6K4tW5zuy6JHCJ5OUUHoBIxKSfmn7GgSN6TrtGG/xCBLTMTp
         9VoTzyZYJxagrmk24sTdOYoBcGBDLqEdLi5Jabasypoz0CjA44Ii0rHBFNujS1k/MEZB
         R0+WjDDYZrAvfUPeSGw85Xkq9E1DgbPhs9zMpg/IA6o8kNTXA/HeYvEeFDS94AM/4Mcw
         j3preE1fT3gdeFc/xhmSQh1Q1rygg54OyUnAcRVi3MULT+9SqMgYhwhc6R7OXgO55uTo
         Fu2axxoBe4ujhmFbOMlIip+h02NYEZGoMPftob92XSnmCkeoFoq/8RC1fYk2SgBzYdxv
         IFKA==
X-Gm-Message-State: AOJu0YxsvBcfnaxLrUpLRL8fO1xMwXnDFF3pJXomWfop6TmUCPpC+70o
	eaqJP/BxTQVPWNwH15fWGSGC743ACfJhk8WDjX4ojyXzSO1nb6NF+7+J
X-Gm-Gg: AR+sD11oiyf0Nm8HfZqRwBT7+ZH9Pk2K7pj1uuMbcKNDLmbn8A7K8DOdv/79O+B4+5d
	b7B6x30qNeT9H6aE2Mp0CI4m2KqdADCPr2WkmRv/V23N3D3Ji8iti17NDSIKTHWFT4Om/TF2Ch2
	1Xp1wRN3E3o1wKRbZvVTW327WQNXZLkqj/TMylWHgDe5sJebpcrE/5yFuLiFplJxro4SnKKlcJ0
	guvBBNaqX1SobQ0/GpspTz8WFvgoTLNf8BEYDQjbBUjlcBBCuDGaXzoeF9l7DkME4Icy7/NFOgD
	RwjVhG1pAHgvAGMZB1+51xQjgsSzv30L31K6plfKxEjV8FgRVPIugl5SC4oOjhkzlVssa0fRgZo
	BLLrqMDYDZF1RA5Utw7lw75KUWg6qss1+L99gKgUxHIEgQH01FMRtXEcoeOBOSQDz2T62j4o0PP
	qCUv22nynDcRCSu2w9PtGoLF2Oh9IdLO2njtUo
X-Received: by 2002:a05:600c:4512:b0:493:bc4a:fb56 with SMTP id 5b1f17b1804b1-4954a50e92bmr242989165e9.39.1784704061349;
        Wed, 22 Jul 2026 00:07:41 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653c9d99sm127305425e9.12.2026.07.22.00.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:07:41 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v3 1/2] wifi: cfg80211: say why the auth/assoc BSS lookup failed
Date: Wed, 22 Jul 2026 09:07:33 +0200
Message-ID: <20260722070734.3612581-2-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722070734.3612581-1-loukot@gmail.com>
References: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
 <20260722070734.3612581-1-loukot@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BSS lookup for an authentication or association request can fail
for three distinct reasons: cfg80211 has no scan entry at all for the
BSSID/channel, an entry exists but is older than
IEEE80211_SCAN_RESULT_EXPIRE (and not held), or a fresh entry exists
but its use_for flags do not allow this use. All three currently
surface as the same generic extack message "Error fetching BSS for
link" on the MLO association path, and as a bare -ENOENT with no
message at all on the authentication and non-MLO association paths.

Since wpa_supplicant logs the extack message verbatim ("nl80211:
kernel reports: ..."), that message is often the only diagnostic a
user sees when an MLO association degrades to fewer links, and it
does not say whether a fresh scan could have helped. In practice the
expired case is common for MLO partner links: 6 GHz is passive-scan
in many regulatory domains, so the partner-link entry is routinely
stale by the time userspace requests the association even though the
link is perfectly usable.

Let __cfg80211_get_bss() take an optional extack and record, during
the same bss_lock walk that fails the lookup, whether any matching
entry was rejected for being expired or for not being usable for the
requested use, and set a distinct message for each case (and a
combined one when different entries were rejected for different
reasons). Reorder the checks in the walk so that an entry's identity
(type, privacy, channel, BSSID/SSID) is established before the
usability checks; this doesn't change which entry is returned since
an entry is only used when all checks pass.

Also give the -EINVAL paths in nl80211_assoc_bss() proper messages
while at it, and keep pointing the bad_attr at the failing link on
the MLO path there; the message for that case is already set by the
lookup itself.

Signed-off-by: Louis Kotze <loukot@gmail.com>
---
v3: use GENL_SET_ERR_MSG for the -EINVAL messages; comment the bare
NL_SET_BAD_ATTR (the lookup already set the specific message);
comment the check ordering in the walk; combined message when
matching entries were rejected for different reasons; drop the
"scan again" instruction; minimal diff at the nl80211_associate()
call site.

v2: capture the reason inside __cfg80211_get_bss() during the single
bss_lock walk (per Johannes' feedback on v1); cover the auth path;
KUnit test added as patch 2.

 include/net/cfg80211.h    |  7 +++++--
 net/wireless/nl80211.c    | 27 +++++++++++++++---------
 net/wireless/scan.c       | 44 ++++++++++++++++++++++++++++++++-------
 net/wireless/tests/scan.c |  2 +-
 4 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b8e9fbb89e69..15c08b24502f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8424,6 +8424,8 @@ cfg80211_inform_bss(struct wiphy *wiphy,
  * @bss_type: type of BSS, see &enum ieee80211_bss_type
  * @privacy: privacy filter, see &enum ieee80211_privacy
  * @use_for: indicates which use is intended
+ * @extack: (optional) extack that is filled with the reason when no
+ *	usable entry was found; may be %NULL
  *
  * Return: Reference-counted BSS on success. %NULL on error.
  */
@@ -8433,7 +8435,8 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wiphy *wiphy,
 					const u8 *ssid, size_t ssid_len,
 					enum ieee80211_bss_type bss_type,
 					enum ieee80211_privacy privacy,
-					u32 use_for);
+					u32 use_for,
+					struct netlink_ext_ack *extack);
 
 /**
  * cfg80211_get_bss - get a BSS reference
@@ -8457,7 +8460,7 @@ cfg80211_get_bss(struct wiphy *wiphy, struct ieee80211_channel *channel,
 {
 	return __cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len,
 				  bss_type, privacy,
-				  NL80211_BSS_USE_FOR_NORMAL);
+				  NL80211_BSS_USE_FOR_NORMAL, NULL);
 }
 
 static inline struct cfg80211_bss *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d962b5944533..ac0c0da45241 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12890,9 +12890,11 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				   IEEE80211_BSS_TYPE_ESS,
-				   IEEE80211_PRIVACY_ANY);
+	req.bss = __cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
+				     IEEE80211_BSS_TYPE_ESS,
+				     IEEE80211_PRIVACY_ANY,
+				     NL80211_BSS_USE_FOR_NORMAL,
+				     info->extack);
 	if (!req.bss)
 		return -ENOENT;
 
@@ -13037,6 +13039,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 }
 
 static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device *rdev,
+					      struct genl_info *info,
 					      const u8 *ssid, int ssid_len,
 					      struct nlattr **attrs,
 					      int assoc_link_id, int link_id)
@@ -13046,8 +13049,10 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 	const u8 *bssid;
 	u32 freq, use_for = 0;
 
-	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		GENL_SET_ERR_MSG(info, "BSSID or frequency missing");
 		return ERR_PTR(-EINVAL);
+	}
 
 	bssid = nla_data(attrs[NL80211_ATTR_MAC]);
 
@@ -13056,8 +13061,10 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 		freq += nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ_OFFSET]);
 
 	chan = nl80211_get_valid_chan(&rdev->wiphy, freq);
-	if (!chan)
+	if (!chan) {
+		GENL_SET_ERR_MSG(info, "invalid or disabled channel");
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (assoc_link_id >= 0)
 		use_for = NL80211_BSS_USE_FOR_MLD_LINK;
@@ -13068,7 +13075,7 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 				 ssid, ssid_len,
 				 IEEE80211_BSS_TYPE_ESS,
 				 IEEE80211_PRIVACY_ANY,
-				 use_for);
+				 use_for, info->extack);
 	if (!bss)
 		return ERR_PTR(-ENOENT);
 
@@ -13107,13 +13114,13 @@ static int nl80211_process_links(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 		}
 		links[link_id].bss =
-			nl80211_assoc_bss(rdev, ssid, ssid_len, attrs,
+			nl80211_assoc_bss(rdev, info, ssid, ssid_len, attrs,
 					  assoc_link_id, link_id);
 		if (IS_ERR(links[link_id].bss)) {
 			err = PTR_ERR(links[link_id].bss);
 			links[link_id].bss = NULL;
-			NL_SET_ERR_MSG_ATTR(info->extack, link,
-					    "Error fetching BSS for link");
+			/* the BSS lookup set the specific message already */
+			NL_SET_BAD_ATTR(info->extack, link);
 			return err;
 		}
 
@@ -13329,7 +13336,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		if (req.link_id >= 0)
 			return -EINVAL;
 
-		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
+		req.bss = nl80211_assoc_bss(rdev, info, ssid, ssid_len, info->attrs,
 					    -1, -1);
 		if (IS_ERR(req.bss))
 			return PTR_ERR(req.bss);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e62b7dd2b7c2..90a4f285654f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1609,10 +1609,12 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wiphy *wiphy,
 					const u8 *ssid, size_t ssid_len,
 					enum ieee80211_bss_type bss_type,
 					enum ieee80211_privacy privacy,
-					u32 use_for)
+					u32 use_for,
+					struct netlink_ext_ack *extack)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
+	bool expired = false, unusable = false;
 	unsigned long now = jiffies;
 	int bss_privacy;
 
@@ -1634,22 +1636,48 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (!is_valid_ether_addr(bss->pub.bssid))
 			continue;
-		if ((bss->pub.use_for & use_for) != use_for)
+		if (!is_bss(&bss->pub, bssid, ssid, ssid_len))
 			continue;
+
+		/*
+		 * The identity checks above must all come first so that
+		 * the expired/unusable classification below only ever
+		 * applies to entries that actually match the request.
+		 */
+
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
-		    !atomic_read(&bss->hold))
+		    !atomic_read(&bss->hold)) {
+			expired = true;
+			continue;
+		}
+
+		if ((bss->pub.use_for & use_for) != use_for) {
+			unusable = true;
 			continue;
-		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
-			res = bss;
-			bss_ref_get(rdev, res);
-			break;
 		}
+
+		res = bss;
+		bss_ref_get(rdev, res);
+		break;
 	}
 
 	spin_unlock_bh(&rdev->bss_lock);
-	if (!res)
+	if (!res) {
+		if (expired && unusable)
+			NL_SET_ERR_MSG(extack,
+				       "BSS entries are expired or cannot be used for the requested operation");
+		else if (unusable)
+			NL_SET_ERR_MSG(extack,
+				       "BSS cannot be used for the requested operation");
+		else if (expired)
+			NL_SET_ERR_MSG(extack,
+				       "BSS entry in scan results is expired");
+		else
+			NL_SET_ERR_MSG(extack,
+				       "BSS not found in scan results");
 		return NULL;
+	}
 	trace_cfg80211_return_bss(&res->pub);
 	return &res->pub;
 }
diff --git a/net/wireless/tests/scan.c b/net/wireless/tests/scan.c
index b1a9c1466d6c..2fc717317ac3 100644
--- a/net/wireless/tests/scan.c
+++ b/net/wireless/tests/scan.c
@@ -617,7 +617,7 @@ static void test_inform_bss_ml_sta(struct kunit *test)
 	link_bss = __cfg80211_get_bss(wiphy, NULL, sta_prof.bssid, NULL, 0,
 				      IEEE80211_BSS_TYPE_ANY,
 				      IEEE80211_PRIVACY_ANY,
-				      0);
+				      0, NULL);
 	KUNIT_ASSERT_NOT_NULL(test, link_bss);
 	KUNIT_EXPECT_EQ(test, link_bss->signal, 0);
 	KUNIT_EXPECT_EQ(test, link_bss->beacon_interval,
-- 
2.55.0

