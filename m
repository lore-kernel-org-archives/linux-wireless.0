Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0FJI0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:04 -0400
Message-Id: <20100610082229.632383239@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/23] mac80211: common work skb freeing
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All the management processing functions free the
skb after they are done, so this can be done in
the new common code instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c  |    2 --
 net/mac80211/iface.c |    3 ++-
 net/mac80211/mesh.c  |    2 --
 net/mac80211/mlme.c  |    5 +----
 4 files changed, 3 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-06-09 17:21:08.000000000 +0200
@@ -754,8 +754,6 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mesh.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-06-09 17:21:08.000000000 +0200
@@ -620,8 +620,6 @@ void ieee80211_mesh_rx_queued_mgmt(struc
 		ieee80211_mesh_rx_mgmt_action(sdata, mgmt, skb->len, rx_status);
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-09 17:21:08.000000000 +0200
@@ -1754,7 +1754,7 @@ void ieee80211_sta_rx_queued_mgmt(struct
 		default:
 			WARN(1, "unexpected: %d", rma);
 		}
-		goto out;
+		return;
 	}
 
 	mutex_unlock(&ifmgd->mtx);
@@ -1799,9 +1799,6 @@ void ieee80211_sta_rx_queued_mgmt(struct
 
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 	}
-
- out:
-	kfree_skb(skb);
 }
 
 static void ieee80211_sta_timer(unsigned long data)
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-09 17:21:08.000000000 +0200
@@ -738,9 +738,10 @@ static void ieee80211_iface_work(struct
 			break;
 		default:
 			WARN(1, "frame for unexpected interface type");
-			kfree_skb(skb);
 			break;
 		}
+
+		kfree_skb(skb);
 	}
 
 	/* then other type-dependent work */


