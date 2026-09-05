Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B532475F7
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 11:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608613; cv=none; b=mFcvimOVsuCuxOUH3CHUSA4PjnIAvXiRhGQp37FrWiMPAEo7xqBoyHFp027LEYMwW3o4LtMtoGyhCMjgh3Wt/lG3ANTBP3DDQzW0Pi8PqEknnCyubqQf4uA/brEtWE846OCiKKhOWCfJ1O1ufEFGI4/ppzin2YYhuXTNnIuTXW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608613; c=relaxed/simple;
	bh=UJzLXZaU7lagCXQTXWbXGJ9ntw1oz8X2525Ya1Coe5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ym5bxFIrEu7fdWdbSRpWUXhdMPGuVxRAbhsouNJvQEpewpIzTZGntCI2GnWPxuWUcphB7ZitQLXo3dq+VFsXaadc9IMZKv9t7gHMcKwb9dP9792RevQGCsWaU6e7qomuhkK6Bh18wjIBGenkB4drTBY2FHCfuZWistMsVfHrPE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9Zqnxed; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9Zqnxed"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b55da8so173282f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 04:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788608610; x=1789213410; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rg3OKYTwsBapMxp5JDG7snb7fqo2b0kyuX5EAeb35U4=;
        b=C9ZqnxednGaze+5Glbxn0faWq1EBZLxfTGGX+cqXk3967VzT6sbMDiNP4ICpRA7Z3a
         SbWjlXHw5/5w4jEhRjK2LRPS8H8sIeqGr24vAx9AlLRIzRBZk2OhEAoawbLkrJmscHe7
         kUbq/kr94V9R8oFTM1Lr6aMvekx7zeIerLdc8prYS1VZI2f2UChYwCsI3otnMpc04puE
         4hZdo/inymI7oKM3Bza/4XeMNWfK7qnCPG3kgB9uw5Ox2ez49jx4RN1/Q50qAm6ShjJs
         SG8jmgWQaC/BZmaH7jLBaGHB1f4Urh7IeSqNHDmY0qHTu5+QROvBubqeiXOJ+oub42cZ
         nxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788608610; x=1789213410;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rg3OKYTwsBapMxp5JDG7snb7fqo2b0kyuX5EAeb35U4=;
        b=GDnl/emGiEAb1quxAiN66fn7kQe33uE95+qHoCYRUYHiwtvuWqENO8k2jEHfEBLTH2
         2NYguJuij8MEjwJsfyM6ITggR7XiDmNWl7PrL+S2ZcVVdIQnINlCcSvdUUqSAQ0lM8V6
         D8iDgxK1jpe07b00CVKRU+OAeifrFUV0j8Bik+GSaOvMq9DZR2dZXlg5tfiDLnMsOqde
         1URsWWqXa6HXVgEJbibL3FPcL1ayCjIJfi3aXpp5AekkaHSjoKUy6oIO2W4yZc6lB2HZ
         OrZ90DyEhCQtZIaCKmOTwtLXaJyn4/y8o1z8BpvU5OSELtlH3/vmZn1T4rbODv8A5AGN
         R3/Q==
X-Forwarded-Encrypted: i=1; AKwUvByhkd6fxNURRHOYjiSW08eEqDWL1r3rgoFlkDrfcD0ZZkAlpjklSXwg/GsakgnJru1wD9rynRfbt+Eb32aVWQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nQu/q5W+zq2Di146266CjQympZduWHl15t5J72VomB3wVeFxZT
	U5wjC6e/KzR+RuAt/2MUkUWKJLb4WyvoOg3AZmnHgjrZgN2ebCG/y/Vj
X-Gm-Gg: AYBFou0VzdwzHsKYZTUuilmyH0+mKG9ia6CcZ4yV2yEO5XD5n1VQ/QMHEgpk74rgzwp
	F8nRC4UCYcU1CsSn7eH1w0CVbE3Oaywazq+gPyo6P3OH45x3zHowxcEsBdqpIDFsLWISv4GXIvS
	Z/b090xY+GBx6uLyrKxz91msq4LoFZvIO0aevJztT9QAEZDwM9FDKtBe1c+q1FhAt7ztkiyv4rY
	D6hJqqSX5fM6jdHyDKkfPBvh3I02zJNvLFgqCwQNTWXYOZaCdtr2SbV1zPiOyarodkKiHsL5ere
	jb3xmzBE+qvhZgC0dKrB5XC653tvw7VjCyQuxEXUzQY/vZT90pAbtp8AzUvz6eygfY+gH7ZK3Zk
	3tShTYBekFpZ2J3ow1qAeSZfYrqptey4tSrqO7x6EoFcVVT5sMvVoxiwwkPuRAC/ViknHAJlXXd
	fXBlM5vM4gBTFRqN04CvcBu8lwiQ7ZWSq3cVoAtnkjAYTANwlGI3m9M32dX0AdTZzp9ZV996ES+
	Np6BvN9pUXhmxHe6iM/HAaPow8OWMRsPNjiwpOrqF6sL2KbVzU=
X-Received: by 2002:a05:600c:a305:b0:49c:ff81:e062 with SMTP id 5b1f17b1804b1-49cff81e076mr52291765e9.2.1788608609569;
        Sat, 05 Sep 2026 04:43:29 -0700 (PDT)
Received: from m715q (host-79-27-15-19.retail.telecomitalia.it. [79.27.15.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf75ce49esm244246125e9.1.2026.09.05.04.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 04:43:29 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrea Covelli <andcov23@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: [PATCH v3 wireless-next] wifi: mac80211: defer AP-side FT key upload until association
Date: Sat,  5 Sep 2026 13:43:00 +0200
Message-ID: <20260905114306.940931-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904154804.295802-1-andcov23@gmail.com>
References: <20260904154804.295802-1-andcov23@gmail.com>
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
mac80211 using the normal software fallback, and scan the station's PTK
slots to upload the marked keys after the driver's AUTH-to-ASSOC state
transition succeeds. If hardware upload fails, the keys remain usable
through software crypto.

Before uploading a deferred key, refresh its RX_MGMT and SPP_AMSDU flags
from the station's association parameters. These capabilities may not
have been known when the key was installed. Drivers need RX_MGMT to
select appropriate PMF handling, and software CCMP/GCMP uses SPP_AMSDU
when constructing authenticated data.

Drivers advertising SW_CRYPTO_CONTROL remain subject to the association
gate. For those drivers, only a return value of 1 from set_key() permits
software crypto, and skipping the callback cannot provide that permission.

Some drivers could handle set_key() before association, but outside the
EPP-specific NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION opt-in mac80211
has no general readiness contract for an ordinary AP-side FT PTK. mt7915
rejects key installation until wcid->sta is set during AUTH-to-ASSOC, and
wlcore allocates its AP firmware link during that transition. The deferred
path therefore does not call drivers before ASSOC.

EPP peers are excluded from this deferral because EPP requires the PTK
to be available before association to encrypt and decrypt
(Re)Association Request and Response frames.

Fixes: 1626e0fa740d ("mac80211: fix FT roaming")
Link: https://github.com/openwrt/openwrt/pull/23181
Link: https://lore.kernel.org/r/20260904154804.295802-1-andcov23@gmail.com
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Andrea Covelli <andcov23@gmail.com>
---
Changes since v2:
- refresh RX_MGMT and SPP_AMSDU from the association parameters before
  uploading deferred PTKs, including clearing flags that no longer apply;
- clarify software fallback after an unsuccessful hardware upload and
  remove duplicated description of the per-key deferral;
- simplify the software-fallback comment and add base-commit information.

Changes since v1:
- defer only when automatic software-crypto fallback is allowed, leaving
  SW_CRYPTO_CONTROL drivers unchanged;
- keep deferred keys on the normal software-fallback path and upload them
  only after the driver's AUTH-to-ASSOC transition succeeds;
- document why pre-association set_key() cannot be assumed for all drivers;
- drop Cc: stable@vger.kernel.org as requested;
- rebase onto wireless-next commit 1b60ed34f712.

v2: https://lore.kernel.org/r/20260904154804.295802-1-andcov23@gmail.com
v1: https://lore.kernel.org/r/20260730161531.3535100-1-andcov23@gmail.com

As of this base, ath10k, ath11k, and ath12k are the only drivers advertising
SW_CRYPTO_CONTROL. Their existing behavior is deliberately unchanged.

The v3 logic was runtime-tested through its OpenWrt backport on Cudy WR3000E
v1 and WR3000P v1 devices running OpenWrt 25.12.5. AP and AP_VLAN FT paths
were exercised, including WPA3-SAE with PMF. Repeated bidirectional 802.11r
FT roams completed without new "key addition failed" messages.

The capability flag refresh was checked with a userspace test harness
covering all 16 PMF/SPP A-MSDU combinations at key installation and
association, including clearing stale flags, preserving unrelated flags,
and selecting only deferred PTKs.

A separate lifecycle test harness covered association failure and retry,
hardware-upload failure and software fallback, key deletion/replacement,
tailroom accounting, and station movement between AP and AP_VLAN. It uses
kernel routines with driver calls and kernel infrastructure simulated,
and passed ASan/LSan and UBSan.

Build-tested with x86_64_defconfig and W=1 for net/wireless/ and
net/mac80211/.

 net/mac80211/cfg.c      | 22 +++++++++++++++++++---
 net/mac80211/key.c      | 38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/key.h      |  4 ++++
 net/mac80211/sta_info.c |  1 +
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..2fa1ea64abda 100644
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
+		 * path since only their set_key() return value can permit
+		 * software crypto.
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
index f45e792abede..4eb706bc18f2 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -144,6 +144,14 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		return -EINVAL;
 	}
 
+	if (key->flags & KEY_FLAG_DEFERRED_HW_UPLOAD) {
+		/*
+		 * Deferred keys allow automatic software fallback. Keep ret at
+		 * -EOPNOTSUPP until the station is ready for hardware upload.
+		 */
+		goto out_unsupported;
+	}
+
 	if (!key->local->ops->set_key)
 		goto out_unsupported;
 
@@ -997,6 +1005,36 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
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
+		/* Capabilities may have changed since key installation. */
+		key->conf.flags &= ~(IEEE80211_KEY_FLAG_RX_MGMT |
+				     IEEE80211_KEY_FLAG_SPP_AMSDU);
+		if (test_sta_flag(sta, WLAN_STA_MFP))
+			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+		if (sta->sta.spp_amsdu)
+			key->conf.flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
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

base-commit: 1b60ed34f712e9f606d80951f1586f4274ebadf1
-- 
2.53.0
