Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0E1S5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kV-00048O-NM
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:39 +0200
Message-Id: <20100528185505.318151040@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 5/7] mac80211: common work skb freeing
References: <20100528185302.639535282@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-28 20:37:08.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-28 20:37:10.000000000 +0200
@@ -754,8 +754,6 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mesh.c	2010-05-28 20:37:08.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-05-28 20:37:10.000000000 +0200
@@ -623,8 +623,6 @@ void ieee80211_mesh_rx_queued_mgmt(struc
 		ieee80211_mesh_rx_mgmt_action(sdata, mgmt, skb->len, rx_status);
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-28 20:37:08.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-28 20:37:10.000000000 +0200
@@ -1754,7 +1754,7 @@ void ieee80211_sta_rx_queued_mgmt(struct
 		default:
 			WARN(1, "unexpected: %d", rma);
 		}
-		goto out;
+		return;
 	}
 
 	mutex_unlock(&ifmgd->mtx);
@@ -1762,9 +1762,6 @@ void ieee80211_sta_rx_queued_mgmt(struct
 	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
 	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH)
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
-
- out:
-	kfree_skb(skb);
 }
 
 static void ieee80211_sta_timer(unsigned long data)
--- wireless-testing.orig/net/mac80211/iface.c	2010-05-28 20:37:08.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-05-28 20:37:10.000000000 +0200
@@ -741,9 +741,10 @@ static void ieee80211_iface_work(struct
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


