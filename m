Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JXMAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:00:04 -0400
Received: by bkbzt19 with SMTP id zt19so8104604bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2011 05:00:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111023194059.GA18385@jm.kir.nu>
References: <20111023194059.GA18385@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Oct 2011 13:59:45 +0200
Message-ID: <CA+XVXfdP5VjMLaYxh6Saa+SM+cDUG+h18L0ixheQmaAo+yQX+Q@mail.gmail.com> (sfid-20111024_140009_039885_E67FDF92)
Subject: Re: [RFC] mac80211: Fix STA supported rate configuration with dummy entry
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 23, 2011 at 21:40, Jouni Malinen <j@w1.fi> wrote:
>
> Are all rate control algorithms fine with the second
> rate_control_rate_init() call? That is needed in the TDLS use case where
> the supported rate set is known only after the STA entry has been

Note that the sta-rates are not really required before second addition
(which also sets them). Initially the STA is not authorized for direct
Tx (as determined by the WLAN_STA_TDLS_PEER_AUTH bit).
We don't expect direct frames during link setup.

> added. I guess it would be possible to delay addition of the STA entry
> for TDLS until the supported rates are known, but I did not look at the
> details on what exactly that would require.

The STA is added to let us know we should drop all non-setup packets
between TDLS peers currently in link setup. We could have used a
different indication, but the STA entry is make the most sense here
since it is automatically cleaned up when we are disconnected from the
AP (as all TDLS state should be).

How about this one instead (tested hwsim with it):

>From d8b7acc16073e50f4fda3365d98ad01b21e2c631 Mon Sep 17 00:00:00 2001
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Oct 2011 13:44:07 +0200
Subject: [RFC] mac80211: init rate-control for TDLS sta when supp-rates are
 known

Initialize rate control algorithms only when supported rates are known
for a TDLS peer sta. Direct Tx between peers is not allowed before the
link is enabled. In turn, this only occurs after a change_station()
call that sets supported rates.
---
 net/mac80211/cfg.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1309bb9..9f05416d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -829,7 +829,12 @@ static int ieee80211_add_station(struct wiphy
*wiphy, struct net_device *dev,
 	      sdata->vif.type == NL80211_IFTYPE_STATION))
 		return -ENOTSUPP;

-	rate_control_rate_init(sta);
+	/*
+	 * for TDLS, rate control should be initialized only when supported
+	 * rates are known.
+	 */
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		rate_control_rate_init(sta);

 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
@@ -913,6 +918,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,

 	sta_apply_parameters(local, sta, params);

+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
+		rate_control_rate_init(sta);
+
 	rcu_read_unlock();

 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-- 
1.7.5.4
