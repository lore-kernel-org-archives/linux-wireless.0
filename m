Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2971 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/17] staging: brcm80211: cleaned up function
 brcmf_cfg80211_get_key()
Date: Tue, 13 Sep 2011 09:49:55 +0200
Message-ID: <1315900197-7260-16-git-send-email-rvossen@broadcom.com> (sfid-20110913_095048_199134_3F5CB3E1)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unnecessary endianess conversion and struct member setting was deleted.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b001e40..926b019 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -258,17 +258,6 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key)
 	key->iv_initialized = cpu_to_le32(key->iv_initialized);
 }
 
-static void convert_key_to_CPU(struct brcmf_wsec_key *key)
-{
-	key->index = le32_to_cpu(key->index);
-	key->len = le32_to_cpu(key->len);
-	key->algo = le32_to_cpu(key->algo);
-	key->flags = le32_to_cpu(key->flags);
-	key->rxiv.hi = le32_to_cpu(key->rxiv.hi);
-	key->rxiv.lo = le16_to_cpu(key->rxiv.lo);
-	key->iv_initialized = le32_to_cpu(key->iv_initialized);
-}
-
 static s32
 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
@@ -1722,7 +1711,6 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
-	struct brcmf_wsec_key key;
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
@@ -1733,12 +1721,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	memset(&key, 0, sizeof(key));
-	key.index = key_idx;
-	convert_key_to_CPU(&key);
 	memset(&params, 0, sizeof(params));
-	params.key_len = (u8) min_t(u8, WLAN_MAX_KEY_LEN, key.len);
-	memcpy(params.key, key.data, params.key_len);
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
-- 
1.7.4.1


