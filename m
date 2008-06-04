Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYFDBr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 21:47:29 -0400
Subject: [PATCH] mac80211: send association event on IBSS create
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain
Date: Tue, 03 Jun 2008 21:46:21 -0400
Message-Id: <1212543981.4237.19.camel@localhost.localdomain> (sfid-20080604_034749_066514_4F9BFBC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise userspace has no idea the IBSS creation succeeded.

Signed-off-by: Dan Williams <dcbw@redhat.com>
-------------

John, please apply to 2.6.26 and later.

Stable: applicable to 2.6.24 and 2.6.25 as well.  File used to be called
net/mac80211/ieee80211_sta.c and diff should still apply with minor
fuzz.

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c220bed..fe7deb6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2348,6 +2348,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
+	union iwreq_data wrqu;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -2865,6 +2866,10 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		}
 	}
 
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+
 	ieee80211_rx_bss_put(dev, bss);
 }
 

