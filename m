Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C954A446078
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428177; cv=none; b=IEB5EGl3O8wwrN/dAGwuflcrwu7VazcmCZzhKGIdijkKHKJoGNdO5c/+6v9mN38o9Xr8b1apmRp2U0FG/9u7mx8eK9lf66oMvgmeFNMgoPNUd+BlX4wOLOCiadXGhCYNnHd8u65tmp4FCfCnzRlCsmEBC3tIvAXLcGInimXIz7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428177; c=relaxed/simple;
	bh=LUOKLW93mqf8RjtHN0p0iMoIMIPbPBea724oGo8LpO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GMXj0IorVQWZ53mHOemImRE0u8QBsT1+RnK2qocdpylHVfWUTqNehoZ9DFJtRydAz+w5PKY4pAu+Wy8sMHoGYamvhi5XcvTGQanbfWWYbZ7rYucNUsz7iN5EgQeByQ88bCb2lTmqtYnoSvIM46SFEbXxjuNr55wQ6ejDQ/U5rWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSrZKpzp; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSrZKpzp"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4957952e0f8so2051145e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428161; x=1786032961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7t/jNvVOTJGSFD4mqKW4xRVQwvTrNP0aXYpKjiO3ZI=;
        b=NSrZKpzpvLBmzyfLFm2peoeg/4t971PxYMXkRhXulp82lD0c6Fwp6EJYSQ60jMCqSG
         5c/asaiL9+gcboYeDS2G7HvLkZ01i0UlqZ5fgRxI8360A3n5IwNRpjQpG0DLnSDxKuSL
         opyYqsxydV8wvqHZUl4jlHFjQ0/0z2j3r9ZwTUF+XePBQp4XS1ws0CXB+6tINChjbvcF
         XL+dmV3J+a3ZW6e/6whS51GF91Q4D4Fau635UE1fI3+pzgfSbD20RA19brV+xhiSs1/e
         uqFQoQnIlvXaUiKju0Ow0WrwOQYM/HxgT/saTaYBBrgsfi+Vv+gpoAv6XpAH6nYyIyXj
         kogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428161; x=1786032961;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L7t/jNvVOTJGSFD4mqKW4xRVQwvTrNP0aXYpKjiO3ZI=;
        b=ssUWW7PGlIsogeWmVyCEfldBTTHvODnVO2hxbzhFy133Kgi+ov4/8j4eugmdHGwemI
         3ml7uU2kmh13waNeI57OiQivFkQPHzVZeU7gTylSWaljf5OC2KIP113upqPyZe9KTsfi
         0/QJ9e8MkyFsmCVfWa9tGcsRy3u5fs2H+/QMgBxwFtP7cXomrOHD2vnDPWg41qs8SdrK
         Y5ppZ4mvQcW4ritYYVybYhof6TIWJ8FOSIwZitOzBn84IIzffICs4X/QGC0rPzBLJ/KV
         3q3t6WVjxLvzX72DZm0LKRGRaK0YuXFZXC1v60ifkhs9iN6MJ9gJmefVce7MP1v8DPhT
         jcig==
X-Forwarded-Encrypted: i=1; AHgh+Rok6pEbVPg4MutEjURqB3otNa3d7vYT98u47ltLCc8Rw7yv7XBj7mOOcDsWUj976EjXOi1Ws1V8gACCa5Q+Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBOpuc6C5uggcfu7gUZMRa09nhgzVhOZdjJ9ajTu5xRvKrVJyY
	TfJUs0swjR2F45ALh13phXsz1VdrRYdMxjzoZ9Ffzj8dKgiE4ZjVUkH9aAmBItE2Z3M=
X-Gm-Gg: AR+sD11XtgVNnSCD04NEfvYwHBMpDmyvGUzOhf0ob0gWdXbsD1rzU/ubV9sdpOp3Ip1
	TdCRGWP3sXtoB7dkZ6dvLwQoEfaNZwxfX2Yensxf0Kom7Mbry1fxnCOni61qQVUmmGhWhm2B0R/
	lAEykziD4ibFZSuPyw7m3tuqaKkofRFaj5RDTdl2vi5V1KhD/TGNASZAh6mQe5HSjEvtqX96d+h
	w0Zz+AtjIsa1TryxJf6j+pwLF7CruKGwgeotqGbq5t/iHuLOO/wB591iKbJHovNa+TMEy1jpQv0
	qanWbpZRP0pPG98DOu2koeEwoKpiABuSjEftYvylBvGGGPLLSwSqf1EabmACU91yshcjpUPxKSH
	4XoTbivyubtnbMKgFLkh5yMQXqflxQ7Ndsnz+1jXrFLcWENHwq+uOfyimHyIaUFmOx6CWP9j6iL
	XZj7w8eMDnNMQgnMxcjhsyfram9rDmB67CQ/uZd/lmqbF5s17xgKFWbK/ZcSeFH/WVa3WvE7/Wv
	7TGfCr5NyL0UuhistO+6I/numYX9Hv1nkE8bGgwqtRPEMP24gqVEzY=
X-Received: by 2002:a05:600c:3b8b:b0:493:ec89:db4a with SMTP id 5b1f17b1804b1-49804a976e1mr18488565e9.0.1785428161077;
        Thu, 30 Jul 2026 09:16:01 -0700 (PDT)
Received: from m715q (host-82-50-146-57.retail.telecomitalia.it. [82.50.146.57])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-498011fec37sm69056805e9.9.2026.07.30.09.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:16:00 -0700 (PDT)
From: andcov23@gmail.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrea Covelli <andcov23@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
Date: Thu, 30 Jul 2026 18:14:02 +0200
Message-ID: <20260730161531.3535100-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Covelli <andcov23@gmail.com>

During an AP-side Fast Transition, hostapd may install the PTK after
creating a station entry but before marking it associated. The ASSOC gate
in ieee80211_add_key() rejects the request with -ENOENT, producing:

  nl80211: kernel reports: key addition failed

Userspace may retry after association, but this race can instead break
the roam, particularly with PMF.

Accept pre-association pairwise keys on AP and AP_VLAN interfaces once
the station exists. Mark only those keys as deferred so hardware upload
is skipped while the key is stored in mac80211. Upload the marked PTKs
after the driver's AUTH-to-ASSOC state transition succeeds.

Track deferred state on each key and scan the station's PTK slots at
ASSOC so hardware upload is limited to keys accepted before association.
EPP peers are excluded from this deferral because EPP requires the PTK
to be available before association to encrypt and decrypt
(Re)Association Request and Response frames.

Fixes: 1626e0fa740d ("mac80211: fix FT roaming")
Cc: stable@vger.kernel.org
Link: https://github.com/openwrt/openwrt/pull/23181
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Andrea Covelli <andcov23@gmail.com>
---
A backport of this change was tested with mt76 on Cudy WR3000E v1 and
WR3000P v1 devices running OpenWrt 25.12.5. Repeated bidirectional
802.11r FT roams completed without new "key addition failed" messages.

 net/mac80211/cfg.c      | 18 +++++++++++++++---
 net/mac80211/key.c      | 27 +++++++++++++++++++++++++++
 net/mac80211/key.h      |  4 ++++
 net/mac80211/sta_info.c |  1 +
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0a9247be26af..a95435b720a9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -666,7 +666,14 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		key->conf.flags |= IEEE80211_KEY_FLAG_NO_AUTO_TX;
 
 	if (mac_addr) {
+		bool defer_hw_upload;
+
 		sta = sta_info_get_bss(sdata, mac_addr);
+		defer_hw_upload =
+			sta && pairwise && !sta->sta.epp_peer &&
+			!test_sta_flag(sta, WLAN_STA_ASSOC) &&
+			(sdata->vif.type == NL80211_IFTYPE_AP ||
+			 sdata->vif.type == NL80211_IFTYPE_AP_VLAN);
 		/*
 		 * The ASSOC test makes sure the driver is ready to
 		 * receive the key. When wpa_supplicant has roamed
@@ -681,14 +688,19 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 * If (re)association frame encryption support is not present,
 		 * cfg80211 will not allow key installation in non‑AP STA mode.
 		 *
-		 * TODO: accept the key if we have a station entry and
-		 *	 add it to the device after the station associates.
+		 * AP-side FT may also install a pairwise key before the
+		 * station is associated. Keep it in mac80211 and upload it
+		 * to the driver after the station reaches ASSOC.
 		 */
 		if (!sta || (!sta->sta.epp_peer &&
-			     !test_sta_flag(sta, WLAN_STA_ASSOC))) {
+			     !test_sta_flag(sta, WLAN_STA_ASSOC) &&
+			     !defer_hw_upload)) {
 			ieee80211_key_free_unused(key);
 			return -ENOENT;
 		}
+
+		if (defer_hw_upload)
+			key->flags |= KEY_FLAG_DEFERRED_HW_UPLOAD;
 	}
 
 	switch (sdata->vif.type) {
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f45e792abede..180e2aa9649e 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -144,6 +144,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return -EINVAL;
 	}
 
+	if (key->flags & KEY_FLAG_DEFERRED_HW_UPLOAD) {
+		ret = 1;
+		goto out_unsupported;
+	}
+
 	if (!key->local->ops->set_key)
 		goto out_unsupported;
 
@@ -997,6 +1002,28 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+void ieee80211_upload_deferred_sta_keys(struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_key *key;
+	int i, ret;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	for (i = 0; i < ARRAY_SIZE(sta->ptk); i++) {
+		key = wiphy_dereference(local->hw.wiphy, sta->ptk[i]);
+		if (!key || !(key->flags & KEY_FLAG_DEFERRED_HW_UPLOAD))
+			continue;
+
+		key->flags &= ~KEY_FLAG_DEFERRED_HW_UPLOAD;
+		ret = ieee80211_key_enable_hw_accel(key);
+		if (ret)
+			sdata_err(key->sdata,
+				  "failed to enable deferred key (%d, %pM): %d\n",
+				  key->conf.keyidx, sta->sta.addr, ret);
+	}
+}
+
 static void
 ieee80211_key_iter(struct ieee80211_hw *hw,
 		   struct ieee80211_vif *vif,
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 826e4e9387c5..97d3bbcf0ac2 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -32,10 +32,13 @@ struct sta_info;
  * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
  *	in the hardware for TX crypto hardware acceleration.
  * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
+ * @KEY_FLAG_DEFERRED_HW_UPLOAD: Key upload is deferred until the station
+ *	is associated.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
+	KEY_FLAG_DEFERRED_HW_UPLOAD	= BIT(2),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -165,6 +168,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 			 bool force_synchronize);
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
+void ieee80211_upload_deferred_sta_keys(struct sta_info *sta);
 void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata);
 int ieee80211_key_switch_links(struct ieee80211_sub_if_data *sdata,
 			       unsigned long del_links_mask,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d12aed9c1756..625f628b46a0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1468,6 +1468,7 @@ static int _sta_info_move_state(struct sta_info *sta,
 	case IEEE80211_STA_ASSOC:
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
+			ieee80211_upload_deferred_sta_keys(sta);
 			sta->assoc_at = ktime_get_boottime_ns();
 			if (recalc) {
 				ieee80211_recalc_min_chandef(sta->sdata, -1);
-- 
2.53.0
