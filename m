Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2GaNVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 09:21:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwCOQ-0000MS-GW
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 15:21:46 +0200
Message-ID: <1343740905.4474.4.camel@jlt3.sipsolutions.net> (sfid-20120731_152156_847107_A8C0BA4F)
Subject: Re: [PATCH v2 1/4] cfg80211: add P2P Device abstraction
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2012 15:21:45 +0200
In-Reply-To: <1343734338-14772-2-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133232_929766_E74C1A3D)
References: <1343734338-14772-1-git-send-email-johannes@sipsolutions.net>
	 <1343734338-14772-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120731_133232_929766_E74C1A3D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 13:32 +0200, Johannes Berg wrote:

> +++ b/net/wireless/chan.c
> @@ -143,6 +143,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
>  	case NL80211_IFTYPE_WDS:

A little earlier in this function this change is also needed:


@@ -105,7 +105,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 
        ASSERT_WDEV_LOCK(wdev);
 
-       if (!netif_running(wdev->netdev))
+       if (wdev->netdev && !netif_running(wdev->netdev))
                return;
 
        switch (wdev->iftype) {


johannes

