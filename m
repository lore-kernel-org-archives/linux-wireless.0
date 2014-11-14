Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbaKNKFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 05:05:33 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211-hwsim: hwname is always known in wiphy
Date: Fri, 14 Nov 2014 12:05:29 +0200
Message-Id: <1415959529-15830-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141114_110544_086156_A7A475A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can always know the hwname of the radio so use the value
from wiphy.
---
 drivers/net/wireless/mac80211_hwsim.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 58f11bb..d1bb775 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2474,12 +2474,10 @@ static void hwsim_mcast_del_radio(int id, const char *hwname,
 	if (ret < 0)
 		goto error;
 
-	if (hwname) {
-		ret = nla_put(skb, HWSIM_ATTR_RADIO_NAME, strlen(hwname),
-			      hwname);
-		if (ret < 0)
-			goto error;
-	}
+	ret = nla_put(skb, HWSIM_ATTR_RADIO_NAME, strlen(hwname),
+		      hwname);
+	if (ret < 0)
+		goto error;
 
 	genlmsg_end(skb, data);
 
@@ -2513,7 +2511,8 @@ static void mac80211_hwsim_free(void)
 						list))) {
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_del_radio(data, NULL, NULL);
+		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
+					 NULL);
 		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2799,7 +2798,8 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_del_radio(data, hwname, info);
+		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
+					 info);
 		return 0;
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2844,7 +2844,7 @@ static void destroy_radio(struct work_struct *work)
 	struct mac80211_hwsim_data *data =
 		container_of(work, struct mac80211_hwsim_data, destroy_work);
 
-	mac80211_hwsim_del_radio(data, NULL, NULL);
+	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
 }
 
 static void remove_user_radios(u32 portid)
-- 
1.8.3.1

