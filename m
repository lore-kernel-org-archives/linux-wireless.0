Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54708 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbbCCJN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:13:29 -0500
Message-ID: <1425374007.2450.16.camel@sipsolutions.net> (sfid-20150303_101334_257158_8C30DE3D)
Subject: Re: [PATCH v2 2/2] cfg80211: add support for connecting to PBSS
 network type
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 03 Mar 2015 10:13:27 +0100
In-Reply-To: <1423403524-22540-3-git-send-email-dlansky@codeaurora.org>
References: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
	 <1423403524-22540-3-git-send-email-dlansky@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-02-08 at 15:52 +0200, Dedy Lansky wrote:

> @@ -961,6 +961,12 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
>  	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
>  	wdev->ssid_len = connect->ssid_len;
>  
> +	wdev->conn_bss_type = IEEE80211_BSS_TYPE_ESS;
> +	if (connect->channel &&
> +	    connect->channel->band == IEEE80211_BAND_60GHZ &&
> +	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)
> +		wdev->conn_bss_type = IEEE80211_BSS_TYPE_PBSS;

This looks wrong, what if the driver did channel selection? Then all of
this breaks.

Perhaps it'd be better to punt this to drivers by introducing
cfg80211_connect_result_bss() along with the existing
cfg80211_roamed_bss(), so drivers can just look up and pass the correct
BSS entry.

johannes

