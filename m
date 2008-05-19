Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:55013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbYESLhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 07:37:18 -0400
From: Helmut Schaa <hschaa@suse.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Date: Mon, 19 May 2008 13:37:08 +0200
Cc: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de> <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
In-Reply-To: <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805191337.09535.hschaa@suse.de> (sfid-20080519_133723_798923_CAED0CED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag, 18. Mai 2008 12:37:23 schrieb Tomas Winkler:
> Again, mac should rather solve the problem that we do not connect to
> AP's that are not in the BSS list

I just tried that approach (see patch below) and could not find a regression 
at a first glance. Nevertheless I'm not sure in which situations a bss is
removed from the list and if this approach would cause a regression?

Regards,
Helmut


diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ad4ed..8595bfd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -678,7 +678,7 @@ static int ieee80211_compatible_rates(struct 
ieee80211_sta_bss *bss,
 	return count;
 }
 
-static void ieee80211_send_assoc(struct net_device *dev,
+static int ieee80211_send_assoc(struct net_device *dev,
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -716,6 +716,10 @@ static void ieee80211_send_assoc(struct net_device *dev,
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
 				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
+
+	if (!bss)
+		return 1;
+
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
@@ -829,6 +833,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
 
 	ieee80211_sta_tx(dev, skb, 0);
+
+	return 0;
 }
 
 
@@ -945,7 +951,11 @@ static void ieee80211_associate(struct net_device *dev,
 		return;
 	}
 
-	ieee80211_send_assoc(dev, ifsta);
+	if (ieee80211_send_assoc(dev, ifsta)) {
+		printk(KERN_DEBUG "%s: send association request failed", dev->name);
+		ifsta->state = IEEE80211_DISABLED;
+		return;
+	}
 
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
