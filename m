Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916F37DE97
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657528; cv=none; b=t5vnbTKyJSOEsLz2UBpwOUy9lDaKefc0iKEp1bgd1V9rFnhsYy7k4+8EhczMa2O20zbqfq2hgwpnDB6SYue9W5f8aBHBFlDanID9hGpx4xfRJjFG06C6pxAvblifNOZDzA604ZAlwEAHvRskRilKngH2tkSfWUYJM6fI689PkYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657528; c=relaxed/simple;
	bh=81oFB8MOTqw4lWLzFAy4xrARRFsjTVGVFlQ7iOCKMJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orRlC15DsGt0J7QEEFAxKrbFz0WHn4/BLL62oyjFOeLjp95alu0wnmnqLKYhDcFeeC4B2CS0cbYdRmhgrcdXmiitMc+bKdjjJa8Qx3JwUPCPkWsvRVVvuJ+cszm1XfwSCEAvOzlBvNUXT2tXY87CmvU43CE6qO8oxTJ0FB4gY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ICJ8DY8y; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICJ8DY8y"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4956242332dso19094395e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784657525; x=1785262325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AL61nYl2zovT6RprywQrFjf39hMsz8k4qeU+GbUkx68=;
        b=ICJ8DY8yGLCXfpxEvpOpfN6FUgMhbtdrCsPm0IxMwn1x5Y7sQOmXwr+BeD/I81hahA
         4ePO0mLN9aZjUMSaXffCXcpiasVB1w9ggTod3dVPC4Zruv6M6cehDY2/sGtPy62Ck//U
         0vhsKYDnHI438dJ8RVLejxZOgEFVu/4bDbXVVdyXewSx9GgA7veUgljx5pz80aAW30yt
         cvlVsezYYjNjn5irjzk/7EWeBoc+RPn8XqBWv2b5/Gp99GJdQURQkaC+o3PwVj4hjbKC
         pcxLo4cFmKMdnfrkLduZ08i9Wu5G+Az9EAjJYfhrg7HfZuM56FCTiRIUMv7YvWgrq+t6
         +uHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657525; x=1785262325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AL61nYl2zovT6RprywQrFjf39hMsz8k4qeU+GbUkx68=;
        b=Zz1YuhWI450KqJyOE4oH8sbTytRfrKB8HIAETpxNP0oWYKXBSSYw1pIRpoLakc9UT2
         +2S7x0f3v4oux+gzeBXtte+fofUwuZIn5qJDXdvDyyw+aNYFdlTHTpuY5cucQC5So6SD
         BMnI/mDeoqSSGeQsae6TWh1+VafcbGXYn+EKlLzceHdR57xW9ye1xiX854tsZ0LJ3VfE
         Y7St99EzrSZbgALIBmkHTX4Sfp3/Tp0ZppMe9eU7+Il6eJibcjbKqOs+Dh3+PV5IJKBU
         hsCcULAmM0dxbKOk+fsKMSHGleqJ/Ta0c/iOrmURHzXvVP6T0q889aGprqqMiJhxTh0J
         wMbg==
X-Gm-Message-State: AOJu0Yw6OtXr3hx4+ChBiS0ilqwEvvRuCCO3xxmybj7Ry1CSc/yCqAyJ
	hyAYkKEPF0WnMoRRvrI7CMKtV8iDEn+qZhuhEqhAdP6hRnq/bp8OzzM3
X-Gm-Gg: AfdE7cnh9Nwdw5sAfI7t7sGklanPTv9+vkHmsISNtsAqDaEUdcr1c6+bdOMM4dGqlgT
	dcIAhiSc+sBKeFQMnmAcOySGeLtq/Tt9GnWOgGWxWJ2joO08w2y9I1ndANkDer8DwOTQLpCzMHR
	DQyVA1rM1ZoECO5oJ0kAjDhcmUIeY++CfzKBxJ+4w/sLyVOUsxWj65dqnWi7axFgUGDpPXnip/l
	Qq+fynaDzmpQampjyacAZTCOXTWCk+xXVuMh023LKM0m0QeWVe2AeRO4rLelNX8FeUPZunZIGOI
	LINHdUG9n3InGbBdYbyPGqFuESrzpvzHOCxpRR7mfRzVAd+MIWLuoTON5m/9ggxTTmHQa/AeYGW
	09lv5UpBaSpUcxYtS3NTPOs/f9F/IVLVlJqDgP3t+0XMwqwhRqZ09Lm9RsEetrDmf1ozMI091Sr
	wI3yh2A8P5PH6YkF2vjGQfEnyxXUqGiKiAqK9H
X-Received: by 2002:a05:600c:e549:20b0:493:b4cf:d37f with SMTP id 5b1f17b1804b1-4954a3f0e58mr155945995e9.16.1784657525048;
        Tue, 21 Jul 2026 11:12:05 -0700 (PDT)
Received: from localhost ([102.128.173.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a64d4b6sm8780595e9.15.2026.07.21.11.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:12:04 -0700 (PDT)
From: Louis Kotze <loukot@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loukot@gmail.com
Subject: [PATCH v2 1/2] wifi: cfg80211: say why the auth/assoc BSS lookup failed
Date: Tue, 21 Jul 2026 20:11:57 +0200
Message-ID: <20260721181158.3004022-2-loukot@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721181158.3004022-1-loukot@gmail.com>
References: <2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
 <20260721181158.3004022-1-loukot@gmail.com>
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
does not say whether rescanning would help. In practice the expired
case is common for MLO partner links: 6 GHz is passive-scan in many
regulatory domains, so the partner-link entry is routinely stale by
the time userspace requests the association even though the link is
perfectly usable.

Let __cfg80211_get_bss() take an optional extack and record, during
the same bss_lock walk that fails the lookup, whether any matching
entry was rejected only for being expired or only for not being
usable for the requested use, and set a distinct message for each
case. Reorder the checks in the walk so that an entry's identity
(type, privacy, channel, BSSID/SSID) is established before the
usability checks; this doesn't change which entry is returned since
an entry is only used when all checks pass. When matching entries
were rejected for both reasons, the use_for message wins: it is only
set for a current (non-expired) entry, so suggesting a rescan would
be misleading.

Also give the -EINVAL paths in nl80211_assoc_bss() proper messages
while at it, and keep pointing the bad_attr at the failing link on
the MLO path.

Signed-off-by: Louis Kotze <loukot@gmail.com>
---
v2: reworked per Johannes' feedback: the reason is captured inside
__cfg80211_get_bss() during the single bss_lock walk (no separate
re-walk helper, no race), reported via a new optional extack
parameter. The authentication path is now covered too, and the
patch grew a KUnit companion (patch 2). Retitled nl80211 -> cfg80211.

 include/net/cfg80211.h    |  7 +++++--
 net/wireless/nl80211.c    | 28 +++++++++++++++++-----------
 net/wireless/scan.c       | 35 +++++++++++++++++++++++++++--------
 net/wireless/tests/scan.c |  2 +-
 4 files changed, 50 insertions(+), 22 deletions(-)

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
index 242071ad10d6..7fb6786a5e8e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12889,9 +12889,11 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
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
 
@@ -13036,6 +13038,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 }
 
 static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device *rdev,
+					      struct genl_info *info,
 					      const u8 *ssid, int ssid_len,
 					      struct nlattr **attrs,
 					      int assoc_link_id, int link_id)
@@ -13045,8 +13048,10 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 	const u8 *bssid;
 	u32 freq, use_for = 0;
 
-	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		NL_SET_ERR_MSG(info->extack, "BSSID or frequency missing");
 		return ERR_PTR(-EINVAL);
+	}
 
 	bssid = nla_data(attrs[NL80211_ATTR_MAC]);
 
@@ -13055,8 +13060,10 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 		freq += nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ_OFFSET]);
 
 	chan = nl80211_get_valid_chan(&rdev->wiphy, freq);
-	if (!chan)
+	if (!chan) {
+		NL_SET_ERR_MSG(info->extack, "invalid or disabled channel");
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (assoc_link_id >= 0)
 		use_for = NL80211_BSS_USE_FOR_MLD_LINK;
@@ -13067,7 +13074,7 @@ static struct cfg80211_bss *nl80211_assoc_bss(struct cfg80211_registered_device
 				 ssid, ssid_len,
 				 IEEE80211_BSS_TYPE_ESS,
 				 IEEE80211_PRIVACY_ANY,
-				 use_for);
+				 use_for, info->extack);
 	if (!bss)
 		return ERR_PTR(-ENOENT);
 
@@ -13106,13 +13113,12 @@ static int nl80211_process_links(struct cfg80211_registered_device *rdev,
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
+			NL_SET_BAD_ATTR(info->extack, link);
 			return err;
 		}
 
@@ -13328,8 +13334,8 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		if (req.link_id >= 0)
 			return -EINVAL;
 
-		req.bss = nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
-					    -1, -1);
+		req.bss = nl80211_assoc_bss(rdev, info, ssid, ssid_len,
+					    info->attrs, -1, -1);
 		if (IS_ERR(req.bss))
 			return PTR_ERR(req.bss);
 		ap_addr = req.bss->bssid;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 05b7dc6b766c..f26e8436dbc1 100644
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
 
@@ -1634,22 +1636,39 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (!is_valid_ether_addr(bss->pub.bssid))
 			continue;
-		if ((bss->pub.use_for & use_for) != use_for)
+		if (!is_bss(&bss->pub, bssid, ssid, ssid_len))
 			continue;
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
+		if (unusable)
+			NL_SET_ERR_MSG(extack,
+				       "BSS cannot be used for the requested operation");
+		else if (expired)
+			NL_SET_ERR_MSG(extack,
+				       "BSS entry is expired, scan again");
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

