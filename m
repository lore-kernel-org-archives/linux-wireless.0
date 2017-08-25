Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17794 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755012AbdHYIoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:44:19 -0400
Date: Fri, 25 Aug 2017 11:43:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] rsi: missing unlocks on error paths
Message-ID: <20170825082645.z2hiotefhzizb7sr@mwanda> (sfid-20170825_104442_452225_F5C12C9F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a missing unlock if rsi_find_sta() fails in
rsi_mac80211_ampdu_action() or if we hit the -EINVAL path in
rsi_mac80211_sta_add().

Fixes: 3528608f3a79 ("rsi: handle station connection in AP mode")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 8b983d03f2da..25331aa16e8e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -906,7 +906,8 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 		rsta = rsi_find_sta(common, sta->addr);
 		if (!rsta) {
 			rsi_dbg(ERR_ZONE, "No station mapped\n");
-			return 0;
+			status = 0;
+			goto unlock;
 		}
 		sta_id = rsta->sta_id;
 	}
@@ -974,6 +975,7 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	}
 
+unlock:
 	mutex_unlock(&common->mutex);
 	return status;
 }
@@ -1202,6 +1204,7 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 	struct rsi_common *common = adapter->priv;
 	bool sta_exist = false;
 	struct rsi_sta *rsta;
+	int status = 0;
 
 	rsi_dbg(INFO_ZONE, "Station Add: %pM\n", sta->addr);
 
@@ -1215,8 +1218,8 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 		/* Check if max stations reached */
 		if (common->num_stations >= common->max_stations) {
 			rsi_dbg(ERR_ZONE, "Reject: Max Stations exists\n");
-			mutex_unlock(&common->mutex);
-			return -EOPNOTSUPP;
+			status = -EOPNOTSUPP;
+			goto unlock;
 		}
 		for (cnt = 0; cnt < common->max_stations; cnt++) {
 			rsta = &common->stations[cnt];
@@ -1241,7 +1244,8 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 			rsi_dbg(ERR_ZONE,
 				"%s: Some problem reaching here...\n",
 				__func__);
-			return -EINVAL;
+			status = -EINVAL;
+			goto unlock;
 		}
 		rsta = &common->stations[sta_idx];
 		rsta->sta = sta;
@@ -1289,9 +1293,10 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 		}
 	}
 
+unlock:
 	mutex_unlock(&common->mutex);
 
-	return 0;
+	return status;
 }
 
 /**
