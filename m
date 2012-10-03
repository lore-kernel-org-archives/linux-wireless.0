Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:57763
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab2JCEad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 00:30:33 -0400
Message-ID: <506BBF62.4080906@posedge.com> (sfid-20121003_063124_928046_C5431E8D)
Date: Wed, 3 Oct 2012 10:00:26 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 1/2] mac80211: VHT peer STA caps
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

Rename vht_capabilities to vht_cap

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---

  include/linux/ieee80211.h |    2 +-
  net/mac80211/main.c       |    2 +-
  net/mac80211/mlme.c       |    4 ++--
  net/mac80211/util.c       |    4 ++--
  4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2385119..afd12d9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1109,7 +1109,7 @@ struct ieee80211_ht_operation {

  #define VHT_MCS_SUPPORTED_SET_SIZE      8

-struct ieee80211_vht_capabilities {
+struct ieee80211_vht_cap {
  	__le32 vht_capabilities_info;
  	u8 vht_supported_mcs_set[VHT_MCS_SUPPORTED_SET_SIZE];
  } __packed;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c80c449..0ec170f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -832,7 +832,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)

  	if (supp_vht)
  		local->scan_ies_len +=
-			2 + sizeof(struct ieee80211_vht_capabilities);
+			2 + sizeof(struct ieee80211_vht_cap);

  	if (!local->ops->hw_scan) {
  		/* For hw_scan, driver needs to set these up. */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbd9e1..85a7005 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -343,7 +343,7 @@ static void ieee80211_add_vht_ie(struct 
ieee80211_sub_if_data *sdata,
  	cap = vht_cap.cap;

  	/* reserve and fill IE */
-	pos = skb_put(skb, sizeof(struct ieee80211_vht_capabilities) + 2);
+	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
  	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
  }

@@ -392,7 +392,7 @@ static void ieee80211_send_assoc(struct 
ieee80211_sub_if_data *sdata)
  			4 + /* power capability */
  			2 + 2 * sband->n_channels + /* supported channels */
  			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
-			2 + sizeof(struct ieee80211_vht_capabilities) + /* VHT */
+			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
  			assoc_data->ie_len + /* extra IEs */
  			9, /* WMM */
  			GFP_KERNEL);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22ca350..4af69cc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1788,8 +1788,8 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct 
ieee80211_sta_vht_cap *vht_cap,
  	__le32 tmp;

  	*pos++ = WLAN_EID_VHT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_vht_capabilities);
-	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
+	*pos++ = sizeof(struct ieee80211_vht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_vht_cap));

  	/* capability flags */
  	tmp = cpu_to_le32(cap);
