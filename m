Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1JLBCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:54 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: [RFC 06/07] compat-wireless: UAPSD configuration in STA mode
Date: Wed, 12 Oct 2011 03:02:50 +0200
To: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27ru00wya27un@edmitar> (sfid-20111012_030257_788340_E3ADB568)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Wed, 3 Aug 2011 09:46:05 +0200

This patch adds UAPSD queues configuration as a param to assoc request.
With the patch it's possible to configure UAPSD from user space.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
  include/linux/nl80211.h |    2 ++
  include/net/cfg80211.h  |    1 +
  net/mac80211/main.c     |    3 ++-
  net/mac80211/mlme.c     |    2 ++
  net/wireless/core.h     |    6 ++++--
  net/wireless/mlme.c     |   10 +++++++---
  net/wireless/nl80211.c  |    7 ++++++-
  net/wireless/sme.c      |    2 +-
  8 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a9bee60..74c5458 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1349,6 +1349,8 @@ enum nl80211_attrs {
  	NL80211_ATTR_P2P_PS_LEGACY_PS,
  	NL80211_ATTR_P2P_PS_OPP_PS,
  	NL80211_ATTR_P2P_PS_CTWINDOW,
+	NL80211_ATTR_UAPSD,
+
  	/* add attributes here, update the policy in nl80211.c */

  	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c08e475..228194f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1050,6 +1050,7 @@ struct cfg80211_assoc_request {
  	size_t ie_len;
  	struct cfg80211_crypto_settings crypto;
  	bool use_mfp;
+	int uapsd;
  };

  /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b9b9765..5f99907 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -630,7 +630,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t  
priv_data_len,
  	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
  	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
  	local->user_power_level = -1;
-	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+	/* Disable all UAPSD AC by default */
+	local->uapsd_queues = 0;
  	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;

  	INIT_LIST_HEAD(&local->interfaces);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dde286a..5116ee1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2754,6 +2754,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data  
*sdata,

  	if (bss->wmm_used && bss->uapsd_supported &&
  	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
+		if (req->uapsd != -1)
+			sdata->local->uapsd_queues = req->uapsd;
  		wk->assoc.uapsd_used = true;
  		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
  	} else {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9ec306..71763ae 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -339,13 +339,15 @@ int __cfg80211_mlme_assoc(struct  
cfg80211_registered_device *rdev,
  			  const u8 *bssid, const u8 *prev_bssid,
  			  const u8 *ssid, int ssid_len,
  			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt);
+			  struct cfg80211_crypto_settings *crypt,
+			  int uapsd);
  int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
  			struct net_device *dev, struct ieee80211_channel *chan,
  			const u8 *bssid, const u8 *prev_bssid,
  			const u8 *ssid, int ssid_len,
  			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt);
+			struct cfg80211_crypto_settings *crypt,
+			int uapsd);
  int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
  			   struct net_device *dev, const u8 *bssid,
  			   const u8 *ie, int ie_len, u16 reason,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4194b3e..3a03fd2 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -507,7 +507,8 @@ int __cfg80211_mlme_assoc(struct  
cfg80211_registered_device *rdev,
  			  const u8 *bssid, const u8 *prev_bssid,
  			  const u8 *ssid, int ssid_len,
  			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt)
+			  struct cfg80211_crypto_settings *crypt,
+			  int uapsd)
  {
  	struct wireless_dev *wdev = dev->ieee80211_ptr;
  	struct cfg80211_assoc_request req;
@@ -537,6 +538,7 @@ int __cfg80211_mlme_assoc(struct  
cfg80211_registered_device *rdev,
  	memcpy(&req.crypto, crypt, sizeof(req.crypto));
  	req.use_mfp = use_mfp;
  	req.prev_bssid = prev_bssid;
+	req.uapsd = uapsd;
  	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
  				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
  	if (!req.bss) {
@@ -574,14 +576,16 @@ int cfg80211_mlme_assoc(struct  
cfg80211_registered_device *rdev,
  			const u8 *bssid, const u8 *prev_bssid,
  			const u8 *ssid, int ssid_len,
  			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt)
+			struct cfg80211_crypto_settings *crypt,
+			int uapsd)
  {
  	struct wireless_dev *wdev = dev->ieee80211_ptr;
  	int err;

  	wdev_lock(wdev);
  	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
-				    ssid, ssid_len, ie, ie_len, use_mfp, crypt);
+				    ssid, ssid_len, ie, ie_len, use_mfp,
+				    crypt, uapsd);
  	wdev_unlock(wdev);

  	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 683f56e..0e5c8a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -206,6 +206,7 @@ static const struct nla_policy  
nl80211_policy[NL80211_ATTR_MAX+1] = {
  	[NL80211_ATTR_P2P_PS_LEGACY_PS] = { .type = NLA_U32 },
  	[NL80211_ATTR_P2P_PS_OPP_PS] = { .type = NLA_U32 },
  	[NL80211_ATTR_P2P_PS_CTWINDOW] = { .type = NLA_U32 },
+	[NL80211_ATTR_UAPSD] = { .type = NLA_U32 },
  };

  /* policy for the key attributes */
@@ -4362,6 +4363,7 @@ static int nl80211_associate(struct sk_buff *skb,  
struct genl_info *info)
  	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
  	int err, ssid_len, ie_len = 0;
  	bool use_mfp = false;
+	int uapsd = -1;

  	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
  		return -EINVAL;
@@ -4405,11 +4407,14 @@ static int nl80211_associate(struct sk_buff *skb,  
struct genl_info *info)
  	if (info->attrs[NL80211_ATTR_PREV_BSSID])
  		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);

+	if (info->attrs[NL80211_ATTR_UAPSD])
+		uapsd = nla_get_u32(info->attrs[NL80211_ATTR_UAPSD]);
+
  	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
  	if (!err)
  		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
  					  ssid, ssid_len, ie, ie_len, use_mfp,
-					  &crypto);
+					  &crypto, uapsd);

  	return err;
  }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0acfdc9..daef93c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -190,7 +190,7 @@ static int cfg80211_conn_do_work(struct wireless_dev  
*wdev)
  					    prev_bssid,
  					    params->ssid, params->ssid_len,
  					    params->ie, params->ie_len,
-					    false, &params->crypto);
+					    false, &params->crypto, -1);
  		if (err)
  			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
  					       NULL, 0,
-- 
1.7.1
