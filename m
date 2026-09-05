Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9043515FA
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788630605; cv=none; b=Wfkvr/2a/blvCijEpcuYvVf7oiA7yUHbIfl8LfVDUeJjjUS9TfVouHdH3EqtM9O7MCcZYCyOm5NVW/L9vZuSSRA4Z7JjL+DUgEFDvvLyGobL3r+3iifnD9XmuQe41htXqjMLg16+sbipsTz/aLgSVZqmXF385Uf1EYTU0oZI20c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788630605; c=relaxed/simple;
	bh=5qOdUu+usie/ittSLXS3sgWJWCbsh0fnq9rg3HOd4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpwfyY+kTivYu5hszjzyYyHXLph3JGvxdHm6VKAiZOMTkU7OtYT5kTCTjMsABt/2SYgwJGvcZYQBAP7JT9jc4v8chQL/4zJLvpuWCkqtYqQsgIo4K1oiH4rapycOyED6Q+yM3me0mlRTLwPV5VD0uS9oUuJAS+yzgAa4Zbik0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lmt99Tid; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lmt99Tid"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4858a186d5bso99948f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 10:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788630602; x=1789235402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WfCwUbP9u0tmfbAhnGZKlvf1bni4u516wfTWmE+uKh0=;
        b=Lmt99TidtHOXAzQPFIpE0ePX8p1fAsQvpNvSJ+p3QSNtjiUwR30ppX73JTf+A9IGFu
         ne5qzC+Uas917F/B/ugq0xvvMBxHh6w70prCLblAZrkqYNJpQP8AYv8IHQPUVVbSboSw
         3DbZWcYTqa3nm4Yz0EyDnQBaNpRm8mO3sHPn1sr2jy2O5opmERu0o3IV+9xgvsSLDKgX
         oPmqa0V55ebnCj6Ce/DS4l54Cq4QXb+2if3ybyuy3zeOVryxgfR9A7cPh5T59gjHgca4
         7oIwpXciqpbAFFVhxai+wWpq/n2sbqPLb+BQyEOArqXoO/ZxakwJ7lWNev+wr/0z4Eaf
         TAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788630602; x=1789235402;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WfCwUbP9u0tmfbAhnGZKlvf1bni4u516wfTWmE+uKh0=;
        b=K6k8a1RndY0yU6jnGgemR+ykCueP/zcyEJ4x/vOFv91Topfo/km42LHqSlRBaKgdlA
         +fWMR/skRnViHKoo2PbBx1wvjy3G8DmTG/GVk+zHYs+VEwi0PgLVokOijRPfY1DgUBa5
         XPtlsHEoR4nbDRysTWpocmBFOx965klrqPBAsb4FzpVeEzJX6VpWb8EB3HgNSO8Gc44x
         /5d1Fx1htNZ3qrUjX9DEDl6rzL4GxSgBImxzYKzWHkSaaZBFvzPiwArui+BhfX+rQB8i
         Rb3u6sHhBukgwC0DPubz0GZbAoaLdcYgxJXiz5fJfgmnm5F5Hc7Y2wpIMj/viIsh5Rqm
         es/g==
X-Forwarded-Encrypted: i=1; AKwUvBzSGkvwojBYRNses731OejrD9Z4BbPwFSXSqPJq8bJcdFVpDx5y5RUZMhkyWQMB2fPCRV1dIu7Ysez4JeFkfA==@vger.kernel.org
X-Gm-Message-State: AFuF++ks/vjnDwkaqk4VfvIHspbOaTwpjlrQ+kW4+g9XrXS01sNWe74f
	5F4+GT/rxV/d1tgU9xsFVigPZg2Kcp7mthYEXZdr7mDsz0oLZqyop8G7
X-Gm-Gg: AYBFou37SJY8gjHs2bYwcVYeogabzj0Omym12mOiMtXy5EfvMegQ9xX3UBYMwPJhCgD
	b0YRGHHEc5jxf7SqKbysO8IuF6zGijPAKs9KEWJhmf/kZkUhZ8nP54V79s26mhZ/8H9SW0jK+JI
	Kv7ywHMU7D9V3dSTPo44yjOQK0hC+zvp8qAfjKQobDq7VFYmGYRlPTrDtexNjT0hl9wLZIbKDxF
	T00ty/Tbs6QiBZ7ExEwwg2/NjWw5VaG1lLkqUApdj/bS3Jg3cwlYx6AHYwj3gyuG6ttyN17iUGq
	4tmlyCwpLQ5tR6IiH4gHNhMyJMMgXZRfDkPX+w7Q3q9W6K7vqG7aZIgS7wziM/bY4ISiGBBAaXo
	pfoqJLgYb/nF7Y4LxeRc5sU5fDbs59Zdkbodib540msjz+SbrNZfwgzSPclLl2Azs2tqWQIQrOq
	Rxe1EPfrIZlvjDEH76fBGwwL36g3MO+Wb5VwoNomFPugB9eSRnuRO93H5QEngj2ycRDF67bXU/a
	JoVLIjOnrFwfldd9t/XKLBWhQat9p8OiH6deg1wSJCl9zpfGCE=
X-Received: by 2002:a05:6000:983:b0:484:3d59:5ed with SMTP id ffacd0b85a97d-4858ffa115fmr5192876f8f.0.1788630601785;
        Sat, 05 Sep 2026 10:50:01 -0700 (PDT)
Received: from m715q (host-79-27-15-19.retail.telecomitalia.it. [79.27.15.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885be1c1sm14619350f8f.32.2026.09.05.10.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 10:50:01 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrea Covelli <andcov23@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: [PATCH v4 wireless-next] wifi: mac80211: defer AP-side FT key upload until association
Date: Sat,  5 Sep 2026 19:47:40 +0200
Message-ID: <20260905174744.1434165-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905114306.940931-1-andcov23@gmail.com>
References: <20260905114306.940931-1-andcov23@gmail.com>
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
when constructing authenticated data. Compute the final flags locally and
store them with WRITE_ONCE() so the refresh does not expose a temporary
cleared state to RX/TX readers of an already-published key.

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
Changes since v3:
- compute the refreshed key capability flags locally and publish them
  with WRITE_ONCE(), avoiding temporarily cleared flags visible to
  concurrent RX/TX processing.

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

v3: https://lore.kernel.org/r/20260905114306.940931-1-andcov23@gmail.com
v2: https://lore.kernel.org/r/20260904154804.295802-1-andcov23@gmail.com
v1: https://lore.kernel.org/r/20260730161531.3535100-1-andcov23@gmail.com

As of this base, ath10k, ath11k, and ath12k are the only drivers advertising
SW_CRYPTO_CONTROL. Their existing behavior is deliberately unchanged.

The v4 implementation was runtime-tested through its OpenWrt
backport on Cudy WR3000E v1 and WR3000P v1 devices running OpenWrt 25.12.5.
AP and AP_VLAN FT paths were exercised, including WPA3-SAE with PMF.
Repeated bidirectional 802.11r FT roams completed without new
"key addition failed" messages.

The capability flag refresh was checked with a userspace test harness
covering all 16 PMF/SPP A-MSDU combinations at key installation and
association, including clearing stale flags, preserving unrelated flags,
and selecting only deferred PTKs. Reader observations at capability-query
and publication boundaries also checked that published flags contain
only a complete old or new value. These deterministic checks do not
exercise kernel memory ordering or concurrent packet processing.

A separate lifecycle test harness covered association failure and retry,
hardware-upload failure and software fallback, key deletion/replacement,
tailroom accounting, and station movement between AP and AP_VLAN. It uses
kernel routines with driver calls and kernel infrastructure simulated,
and passed ASan/LSan and UBSan.

Build-tested with x86_64_defconfig and W=1 for net/wireless/ and
net/mac80211/.

 net/mac80211/cfg.c      | 22 ++++++++++++++++++---
 net/mac80211/key.c      | 43 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/key.h      |  4 ++++
 net/mac80211/sta_info.c |  1 +
 4 files changed, 67 insertions(+), 3 deletions(-)

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
index f45e792abede..6f5673b57bed 100644
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
 
@@ -997,6 +1005,41 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+void ieee80211_upload_deferred_sta_keys(struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_key *key;
+	u16 flags;
+	int i, ret;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	for (i = 0; i < ARRAY_SIZE(sta->ptk); i++) {
+		key = wiphy_dereference(local->hw.wiphy, sta->ptk[i]);
+		if (!key || !(key->flags & KEY_FLAG_DEFERRED_HW_UPLOAD))
+			continue;
+
+		/*
+		 * Capabilities may have changed since key installation.
+		 * Avoid exposing temporarily cleared flags to RX/TX.
+		 */
+		flags = key->conf.flags & ~(IEEE80211_KEY_FLAG_RX_MGMT |
+					    IEEE80211_KEY_FLAG_SPP_AMSDU);
+		if (test_sta_flag(sta, WLAN_STA_MFP))
+			flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+		if (sta->sta.spp_amsdu)
+			flags |= IEEE80211_KEY_FLAG_SPP_AMSDU;
+		WRITE_ONCE(key->conf.flags, flags);
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
