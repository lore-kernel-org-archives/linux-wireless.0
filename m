Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYFDDk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:40:28 -0400
Subject: [PATCH v2] mac80211: send association event on IBSS create
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1212543981.4237.19.camel@localhost.localdomain>
References: <1212543981.4237.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf8
Date: Tue, 03 Jun 2008 23:39:55 -0400
Message-Id: <1212550795.11852.1.camel@localhost.localdomain> (sfid-20080604_054030_524076_8E1E3D1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=EF=BB=BFOtherwise userspace has no idea the IBSS creation succeeded.

Signed-off-by: Dan Williams <dcbw@redhat.com>
-------------

John, please apply to 2.6.26 and later.

Stable: applicable to 2.6.24 and 2.6.25 as well.  File used to be calle=
d
net/mac80211/ieee80211_sta.c and diff should still apply with minor
fixup to the second hunk.

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c220bed..73c66e0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2348,6 +2348,7 @@ static int ieee80211_sta_join_ibss(struct net_dev=
ice *dev,
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
+	union iwreq_data wrqu;
=20
 	sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
=20
@@ -2491,6 +2492,10 @@ static int ieee80211_sta_join_ibss(struct net_de=
vice *dev,
 	ifsta->state =3D IEEE80211_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
=20
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+
 	return res;
 }
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
