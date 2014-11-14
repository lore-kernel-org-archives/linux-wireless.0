Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbaKNLQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 06:16:40 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211-hwsim: hwname is always known so use the value from wiphy
Date: Fri, 14 Nov 2014 13:16:34 +0200
Message-Id: <1415963794-28664-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141114_121658_943954_812D6F1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can always know the hwname of the radio so use the value
from wiphy.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
Hi,

this v2 adds the missing signed-off-by

Cheers,
Jukka

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

