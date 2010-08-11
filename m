Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:40509 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab0HKRvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 13:51:32 -0400
Subject: [PATCH] staging/wlan-ng: Explicitly set some fields in cfg80211
 interface
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 18:16:08 +0100
Message-ID: <1281546968.2010.5.camel@dellpc>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg

Now that the wlan-ng driver has been switched to cfg80211 in mainline,
can this small patch be forwarded also, to catch up with some new fields
that have gone into the cfg80211 api also in this cycle.

Thanks
Karl





Explicitly set some fields in cfg80211 interface

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>

---

The cfg80211 api has introduced a few new fields. Rather than assume
what cfg80211 api does by default, set these explicitly.


--- a/drivers/staging/wlan-ng/cfg80211.c	2010-08-11 18:04:27.000000000
+0100
+++ b/drivers/staging/wlan-ng/cfg80211.c	2010-07-07 10:17:27.000000000
+0100
@@ -214,6 +214,7 @@ int prism2_get_key(struct wiphy *wiphy, 
 	} else return -ENOENT;
 	params.key_len = len;
 	params.key = wlandev->wep_keys[key_index];
+	params.seq_len = 0;
 
 	callback(cookie, &params);
 	return 0;
@@ -709,6 +710,8 @@ struct wiphy *wlan_create_wiphy(struct d
 	priv->band.n_channels = ARRAY_SIZE(prism2_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(prism2_rates);
+	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.ht_cap.ht_supported = false;
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 	set_wiphy_dev(wiphy, dev);


