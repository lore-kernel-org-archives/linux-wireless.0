Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A1F3B7771
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788536924; cv=none; b=VeHJ49hR6w7vn+Ivk2ZVQ4SK3+Lkn4p7CXIAX4rYdEDEKGEPZ5O53LRoFuApgHxtATrmoHt8QUGWyqdk+8UYCJ02uW0yfGRLiReNianHVX8JN2+DAPA6qm7llVZ42T/cY7V4YYe1j6RLPJcQgYoe8me5cqCcxRHB5vRKiP1ABq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788536924; c=relaxed/simple;
	bh=Hhr25ch5ZpMwrsqwvm0mw27PQ34q8fUwVkHlvCTuzb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hum6DGXIaFAHmlRAnAAa/TWa0TYtSHOB8n0C6s6GURuJE4zMYoqYzeheAic15Pxt+lt+wdUfZB8N/Yw9KEbTwaji/3K8fNFCNMLsgE8rikXI8ITWEDogrpOvgF8ZELwz3oVxLcfwaKplK1BSzOmoNQHJbDhPgFUFOA1fKq+vgCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pVuIfAS7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVuIfAS7"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4994d41ceb9so928505e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 08:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788536921; x=1789141721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tu22tLPP9rgVmUnbQICBjefAe0jl7Prkeq46ND1Nj5o=;
        b=pVuIfAS714j77ssHasxD6ui08NhN9SUmUTiHGMqqNa9MqE+G7HABCtNwEIcvvoW1Cb
         ei/KVXdTJlc+cgaam9CSsLyrn/TkAUsCRnsH/Rr08mfKN3n/FWiFKZP0II2mwJYo2z/P
         oyA1YlFtN7SiNTI3YYEbrNCTSWbxOt+EabA49VkbxTunyJZ8iDBrh5Ir6CvWA2jRSfsf
         rjGiJxw4CtVtWHiK7DanyWgtvtS34L4mB5rlGq6TYtGkuwPPOp32xxG0xa+o5qzHUci6
         D0jni2qKKQHWuOJDGD0Bp3sS3d7XlYPWO1iFDcihItl+KAptoHwRkBmd3sEsyA+ctNHK
         1pOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536921; x=1789141721;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tu22tLPP9rgVmUnbQICBjefAe0jl7Prkeq46ND1Nj5o=;
        b=Wpo7WFTEV+vsNfGcz0/0mMopEQ+WCkWkgpNXlFzllHJYSb/aYgexGpcLQ9QypvGe7w
         56ddVnwxdovVK2nt2+sG9bMBZPJKh+BccAbW6WO4rSAFFiWXqRxrhjBUltrtIsi6yraD
         9oP8WdMAYan6sYzKFppbY1+9wCUkRroUkb0C1B1c+NT4ewtE7YB76HvKB2UxUI8HamZr
         iZhKhQDZOkiBIINbQnZmDSk+IjvOD0wVZ+6Q3bQIDDVLFtXKrmpVdypZVTz6dMBi8cEk
         b0VBtJaClOYE7hpi+Y66Z8bWw4ANPdTEHWKX8/aDZaTaBKxebIw2GrxMS5pht1VvB5nB
         adLQ==
X-Forwarded-Encrypted: i=1; AKwUvByEkpat0cl0O86+H50/C4KLFWFDP7iCm6eDvFUAIFxU5YcPovi+x8/qFj81U/+bISZH20Zm56PGtUi2CIaEYA==@vger.kernel.org
X-Gm-Message-State: AFuF++ltGU+EMjV9NDZp6zl0LO9ylKi9dy3CdU+ORGdXV72fGi5o6H7V
	D/WHZ/FtHZpFkM5uMiNdUm8eMpfdduR8KOWQG1hwMX2n8V7wNjQnZ9Sk
X-Gm-Gg: AYBFou3S2S1XT94mUJw4HY54xIDKjyEiHRW1l4cOJmOhpPJgXmp/dGHz99DHLLS2Fyt
	pDtLvXYTdlcjxHQhLYpC+EZWBlPqeJRLEYJESq4JNuJI4u4Sqan1gG30P4ykKUQ8psq6t8xnngq
	cMbaufsHY8waLup+g4sKS6wWE98lviQOHJB6IVcqH2bG5LfxcR0YkSUlPTbyuEcXtXwO/hOzfqd
	rH64F69FdCmRd49UmpUH5JRwY/t7Poy1JjRimAAg9xBSWO+qnLfEk/ar04jsTX8wdTC4iEGAbME
	LC6o3uMRFDKV+7QPfeQF/HufaUKOF0Vyvq9yRN/jA/wdh+8/8ONW/pKydHiGs9sovQ/n6a1CQlN
	rG9O1fTkfN/XbzA/A0NcKfToCgCWnu8P2O9UyMZ0aakkqP1Kx+Ldt9pJYdWuA4yp1CqMjwz5RLv
	7Tc6A60/VoqE/zG8mz8ntssAJYRG4qCZ7KXRiKOhaWTfsZRROGwjY/IfmV4Ms9tUzDK5MCOAO4Z
	QtUnVH0i2LIfgupfvlTdYiB+VnxMCBHhts5gdnOlZgPUMqfhBOnMm77rROFX3o=
X-Received: by 2002:a05:600c:a00d:b0:499:d95a:41f with SMTP id 5b1f17b1804b1-49cf7f51dcbmr51375445e9.0.1788536920536;
        Fri, 04 Sep 2026 08:48:40 -0700 (PDT)
Received: from m715q (host-79-27-15-19.retail.telecomitalia.it. [79.27.15.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858dd90e1fsm3185960f8f.28.2026.09.04.08.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:48:39 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrea Covelli <andcov23@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: [PATCH v2 wireless-next] wifi: mac80211: defer AP-side FT key upload until association
Date: Fri,  4 Sep 2026 17:47:58 +0200
Message-ID: <20260904154804.295802-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

During an AP-side Fast Transition, hostapd may install the PTK after
creating a station entry but before marking it associated. The ASSOC gate
in ieee80211_add_key() rejects the request with -ENOENT, producing:

  nl80211: kernel reports: key addition failed

Userspace may retry after association, but this race can instead break
the roam, particularly with PMF.

Accept pre-association pairwise keys on AP and AP_VLAN interfaces once
the station exists, but only when mac80211 is allowed to fall back to
software crypto. Mark only those keys as deferred, keep them in
mac80211 using the normal software fallback, and upload the marked PTKs
after the driver's AUTH-to-ASSOC state transition succeeds.

Drivers advertising SW_CRYPTO_CONTROL remain subject to the association
gate. For those drivers, only a return value of 1 from set_key() permits
software crypto, and skipping the callback cannot provide that permission.

Some drivers could handle set_key() before association, but outside the
EPP-specific NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION opt-in mac80211
has no general readiness contract for an ordinary AP-side FT PTK. mt7915
rejects key installation until wcid->sta is set during AUTH-to-ASSOC, and
wlcore allocates its AP firmware link during that transition. The deferred
path therefore does not call drivers before ASSOC.

Track deferred state on each key and scan the station's PTK slots at
ASSOC so hardware upload is limited to keys accepted before association.
EPP peers are excluded from this deferral because EPP requires the PTK
to be available before association to encrypt and decrypt
(Re)Association Request and Response frames.

Fixes: 1626e0fa740d ("mac80211: fix FT roaming")
Link: https://github.com/openwrt/openwrt/pull/23181
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Andrea Covelli <andcov23@gmail.com>
---
Changes since v1:
- defer only when automatic software-crypto fallback is allowed, leaving
  SW_CRYPTO_CONTROL drivers unchanged;
- keep deferred keys on the normal software-fallback path and upload them
  only after the driver's AUTH-to-ASSOC transition succeeds;
- document why pre-association set_key() cannot be assumed for all drivers;
- drop Cc: stable@vger.kernel.org as requested;
- rebase onto wireless-next commit 1b60ed34f712.

v1: https://lore.kernel.org/r/20260730161531.3535100-1-andcov23@gmail.com

As of this base, ath10k, ath11k, and ath12k are the only drivers advertising
SW_CRYPTO_CONTROL. Their existing behavior is deliberately unchanged by this
revision.

The v2 logic was runtime-tested through its OpenWrt backport on Cudy WR3000E
v1 and WR3000P v1 devices running OpenWrt 25.12.5. AP and AP_VLAN FT paths
were exercised, including WPA3-SAE with PMF. Repeated bidirectional 802.11r
FT roams completed without new "key addition failed" messages.

Build-tested with x86_64_defconfig and W=1 for net/wireless/ and
net/mac80211/.

 net/mac80211/cfg.c      | 22 +++++++++++++++++++---
 net/mac80211/key.c      | 31 +++++++++++++++++++++++++++++++
 net/mac80211/key.h      |  4 ++++
 net/mac80211/sta_info.c |  1 +
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..ff993a7a9e44 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -666,7 +666,15 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		key->conf.flags |= IEEE80211_KEY_FLAG_NO_AUTO_TX;
 
 	if (mac_addr) {
+		bool defer_hw_upload;
+
 		sta = sta_info_get_bss(sdata, mac_addr);
+		defer_hw_upload =
+			sta && pairwise && !sta->sta.epp_peer &&
+			!test_sta_flag(sta, WLAN_STA_ASSOC) &&
+			(sdata->vif.type == NL80211_IFTYPE_AP ||
+			 sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
+			!ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL);
 		/*
 		 * The ASSOC test makes sure the driver is ready to
 		 * receive the key. When wpa_supplicant has roamed
@@ -681,14 +689,22 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 * If (re)association frame encryption support is not present,
 		 * cfg80211 will not allow key installation in non‑AP STA mode.
 		 *
-		 * TODO: accept the key if we have a station entry and
-		 *	 add it to the device after the station associates.
+		 * AP-side FT may also install a pairwise key before the
+		 * station is associated. If automatic software fallback is
+		 * allowed, keep it in mac80211 and upload it after the station
+		 * reaches ASSOC. Drivers with SW_CRYPTO_CONTROL cannot use this
+		 * path since only their set_key return value can permit software
+		 * crypto.
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
index f45e792abede..774a92ba7bd8 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -144,6 +144,15 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return -EINVAL;
 	}
 
+	if (key->flags & KEY_FLAG_DEFERRED_HW_UPLOAD) {
+		/*
+		 * Keys are only deferred if automatic software fallback is
+		 * allowed. Leave ret as -EOPNOTSUPP so the normal fallback path
+		 * is used without pretending the driver returned 1.
+		 */
+		goto out_unsupported;
+	}
+
 	if (!key->local->ops->set_key)
 		goto out_unsupported;
 
@@ -997,6 +1006,28 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
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
index fdf00cbf49d8..753dcdd90701 100644
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
