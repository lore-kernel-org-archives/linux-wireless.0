Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63767 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZIRV1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 17:27:46 -0400
Received: by ewy2 with SMTP id 2so1682729ewy.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253232931.23567.6.camel@johannes.local>
References: <1253232931.23567.6.camel@johannes.local>
Date: Fri, 18 Sep 2009 23:27:49 +0200
Message-ID: <2d0a357f0909181427g6f54fc24ga07aa6d2238e2b5b@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: don't overwrite privacy setting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ASIC Felix <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quick Feedback:

Fixes also compat-wireless (2009-09-18) built against 2.6.31 with iwl3945.
ath5k driver on another machine is also OK.
With yesterday's c-w I had no connection to my AP (WPA2-PSK/CCMP).

$ sudo wpa_cli -iwlan0 status
bssid=$myBSSID
ssid=$mySSID
id=0
pairwise_cipher=CCMP
group_cipher=CCMP
key_mgmt=WPA2-PSK
wpa_state=COMPLETED
ip_address=$myIPADDR


-Sedat

On Fri, Sep 18, 2009 at 2:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When cfg80211 is instructed to connect, it always
> uses the default WEP key for the privacy setting,
> which clearly is wrong when using wpa_supplicant.
> Don't overwrite the setting, and rely on it being
> false when wpa_supplicant is not running, instead
> set it to true when we have keys.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> --- wireless-testing.orig/net/wireless/wext-sme.c       2009-09-17 17:12:03.000000000 -0700
> +++ wireless-testing/net/wireless/wext-sme.c    2009-09-17 17:12:53.000000000 -0700
> @@ -26,11 +26,11 @@ int cfg80211_mgd_wext_connect(struct cfg
>
>        wdev->wext.connect.ie = wdev->wext.ie;
>        wdev->wext.connect.ie_len = wdev->wext.ie_len;
> -       wdev->wext.connect.privacy = wdev->wext.default_key != -1;
>
>        if (wdev->wext.keys) {
>                wdev->wext.keys->def = wdev->wext.default_key;
>                wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
> +               wdev->wext.connect.privacy = true;
>        }
>
>        if (!wdev->wext.connect.ssid_len)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
