Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37604 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdBUOra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:47:30 -0500
Message-ID: <1487688447.15350.4.camel@sipsolutions.net> (sfid-20170221_154733_396618_1C023A7D)
Subject: Re: [RFC v2 1/2] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Tue, 21 Feb 2017 15:47:27 +0100
In-Reply-To: <1487688369.15350.3.camel@sipsolutions.net> (sfid-20170221_154616_216812_DC7B7832)
References: <20170221123758.5339-1-johannes@sipsolutions.net>
         <20170221144335.GA17601@w1.fi> <1487688369.15350.3.camel@sipsolutions.net>
         (sfid-20170221_154616_216812_DC7B7832)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The .len verifies that it's at least that long. We're thus ignoring
> additional bytes in the PSK case if they're present, which I suppose
> we should fix by checking the exact length in the code separately.
> 
IOW, I'll add this:

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8044,6 +8044,8 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		if (!wiphy_ext_feature_isset(&rdev->wiphy,
 					     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK))
 			return -EINVAL;
+		if (nla_len(info->attrs[NL80211_ATTR_PMK]) != WLAN_PMK_LEN)
+			return -EINVAL;
 		settings->psk = nla_data(info->attrs[NL80211_ATTR_PMK]);
 	}
 

johannes
