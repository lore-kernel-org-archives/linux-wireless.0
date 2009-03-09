Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45190 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZCIWQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 18:16:57 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Userspace (wpa_supplicant) not notified on interface down with 2.6.29/wireless-testing
Date: Mon, 9 Mar 2009 18:50:00 -0300
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903091850.01604.herton@mandriva.com.br> (sfid-20090309_231701_087871_0B5A3600)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have the problem when using 2.6.29 and judging by the code the situation
stays the same with wireless-testing, even after the fix "mac80211: deauth when
interface is marked down" (the fix doesn't work with kernel 2.6.28 or later, as
I'll explain).

The problem is, with latest kernels wpa_supplicant isn't still notified when
interface goes down, even after commit "mac80211: deauth when interface is
marked down" (e327b847 on Linus tree). There isn't a problem with this commit,
but because of other code changes it doesn't work on latest kernels (but works
if I apply same/similar change on 2.6.27 for example).

The issue is as follows: after commit "mac80211: restructure disassoc/deauth
flows" in 2.6.28, the call to ieee80211_sta_deauthenticate added by commit
e327b847 will not work: because we do sta_info_flush(local, sdata); inside
ieee80211_stop (iface.c), all stations in interface are cleared, so when calling
 ieee80211_sta_deauthenticate->ieee80211_set_disassoc (mlme.c), inside
ieee80211_set_disassoc we have this in the beginning:

        sta = sta_info_get(local, ifsta->bssid);
        if (!sta) {

the !sta check triggers, so the function returns early and
ieee80211_sta_send_apinfo(sdata, ifsta); later isn't called, so wpa_supplicant
isn't notified with SIOCGIWAP

One possible fix is moving sta_info_flush, to avoid !sta, and seems good, like
the following:

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2acc416..0929581 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -370,25 +370,6 @@ static int ieee80211_stop(struct net_device *dev)
 	rcu_read_unlock();
 
 	/*
-	 * Remove all stations associated with this interface.
-	 *
-	 * This must be done before calling ops->remove_interface()
-	 * because otherwise we can later invoke ops->sta_notify()
-	 * whenever the STAs are removed, and that invalidates driver
-	 * assumptions about always getting a vif pointer that is valid
-	 * (because if we remove a STA after ops->remove_interface()
-	 * the driver will have removed the vif info already!)
-	 *
-	 * We could relax this and only unlink the stations from the
-	 * hash table and list but keep them on a per-sdata list that
-	 * will be inserted back again when the interface is brought
-	 * up again, but I don't currently see a use case for that,
-	 * except with WDS which gets a STA entry created when it is
-	 * brought up.
-	 */
-	sta_info_flush(local, sdata);
-
-	/*
 	 * Don't count this interface for promisc/allmulti while it
 	 * is down. dev_mc_unsync() will invoke set_multicast_list
 	 * on the master interface which will sync these down to the
@@ -539,6 +520,26 @@ static int ieee80211_stop(struct net_device *dev)
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
+
+		/*
+		 * Remove all stations associated with this interface.
+		 *
+		 * This must be done before calling ops->remove_interface()
+		 * because otherwise we can later invoke ops->sta_notify()
+		 * whenever the STAs are removed, and that invalidates driver
+		 * assumptions about always getting a vif pointer that is valid
+		 * (because if we remove a STA after ops->remove_interface()
+		 * the driver will have removed the vif info already!)
+		 *
+		 * We could relax this and only unlink the stations from the
+		 * hash table and list but keep them on a per-sdata list that
+		 * will be inserted back again when the interface is brought
+		 * up again, but I don't currently see a use case for that,
+		 * except with WDS which gets a STA entry created when it is
+		 * brought up.
+		 */
+		sta_info_flush(local, sdata);
+
 		local->ops->remove_interface(local_to_hw(local), &conf);
 	}
 
My question is, is the patch above safe? that is, do we need to always
call sta_info_flush on interface down like currently, or just for the case we
call remove_interface, like the comment states? if the latter, patch above
is good, and solves the wpa_supplicant/userspace issue.

--
[]'s
Herton.
