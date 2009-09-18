Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36983 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZIRU6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 16:58:13 -0400
Received: by bwz6 with SMTP id 6so951902bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 13:58:16 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: don't overwrite privacy setting
From: ASIC Felix <ic.felix@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1253232931.23567.6.camel@johannes.local>
References: <1253232931.23567.6.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 13:52:37 -0700
Message-Id: <1253307157.6138.4.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-17 at 17:15 -0700, Johannes Berg wrote:
> When cfg80211 is instructed to connect, it always
> uses the default WEP key for the privacy setting,
> which clearly is wrong when using wpa_supplicant.
> Don't overwrite the setting, and rely on it being
> false when wpa_supplicant is not running, instead
> set it to true when we have keys.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> --- wireless-testing.orig/net/wireless/wext-sme.c	2009-09-17 17:12:03.000000000 -0700
> +++ wireless-testing/net/wireless/wext-sme.c	2009-09-17 17:12:53.000000000 -0700
> @@ -26,11 +26,11 @@ int cfg80211_mgd_wext_connect(struct cfg
>  
>  	wdev->wext.connect.ie = wdev->wext.ie;
>  	wdev->wext.connect.ie_len = wdev->wext.ie_len;
> -	wdev->wext.connect.privacy = wdev->wext.default_key != -1;
>  
>  	if (wdev->wext.keys) {
>  		wdev->wext.keys->def = wdev->wext.default_key;
>  		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
> +		wdev->wext.connect.privacy = true;
>  	}
>  
>  	if (!wdev->wext.connect.ssid_len)

This patch fixes my issue "Re: regression?  No connection with
master-2009-09-16 was fine until master-2009-09-14"

Best regards,
Felix

