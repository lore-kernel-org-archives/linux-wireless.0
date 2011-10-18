Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45091 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1JRGxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:53:49 -0400
Date: Tue, 18 Oct 2011 09:50:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwmc3200wifi: add some more range checks
Message-ID: <20111018065043.GB25814@longonot.mountain> (sfid-20111018_085354_162704_0FCD1E6D)
References: <20111012081036.GA32384@elgon.mountain>
 <20111012082656.GA13878@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111012082656.GA13878@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch added a check to get_key() but missed a couple
other places which need range checks.

The problem here is that wifi drivers have different numbers of keys.
The lower levels assume that they can have up to 4 default keys and
2 management keys but this driver only has the default keys so we
could go past the end of the ->keys[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index ed57e44..e20a38d 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -165,11 +165,15 @@ static int iwm_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 				struct key_params *params)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
-	struct iwm_key *key = &iwm->keys[key_index];
+	struct iwm_key *key;
 	int ret;
 
 	IWM_DBG_WEXT(iwm, DBG, "Adding key for %pM\n", mac_addr);
 
+	if (key_index >= IWM_NUM_KEYS)
+		return -ENOENT;
+
+	key = &iwm->keys[key_index];
 	memset(key, 0, sizeof(struct iwm_key));
 	ret = iwm_key_init(key, key_index, mac_addr, params);
 	if (ret < 0) {
@@ -210,8 +214,12 @@ static int iwm_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 				u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
-	struct iwm_key *key = &iwm->keys[key_index];
+	struct iwm_key *key;
 
+	if (key_index >= IWM_NUM_KEYS)
+		return -ENOENT;
+
+	key = &iwm->keys[key_index];
 	if (!iwm->keys[key_index].key_len) {
 		IWM_DBG_WEXT(iwm, DBG, "Key %d not used\n", key_index);
 		return 0;
@@ -232,6 +240,9 @@ static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
 
 	IWM_DBG_WEXT(iwm, DBG, "Default key index is: %d\n", key_index);
 
+	if (key_index >= IWM_NUM_KEYS)
+		return -ENOENT;
+
 	if (!iwm->keys[key_index].key_len) {
 		IWM_ERR(iwm, "Key %d not used\n", key_index);
 		return -EINVAL;
