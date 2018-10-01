Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C439BC64EAD
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 07:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C26E2083C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 07:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C26E2083C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbeJANs4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 09:48:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53894 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbeJANsz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 09:48:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6sNg-00070c-6N; Mon, 01 Oct 2018 09:12:36 +0200
Message-ID: <1538377946.3126.0.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix wext-compat memory leak
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stefan.seyfried@googlemail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     Stefan Seyfried <seife+kernel@b1-systems.com>
Date:   Mon, 01 Oct 2018 09:12:26 +0200
In-Reply-To: <20180930105300.30797-1-stefan.seyfried@googlemail.com> (sfid-20180930_125439_767875_5C23A914)
References: <20180930105300.30797-1-stefan.seyfried@googlemail.com>
         (sfid-20180930_125439_767875_5C23A914)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stefan,

Thanks for the investigation & fix. I've changed the fix to use
cfg80211_sinfo_release_content(), take care of the error path in
cfg80211_wext_giwrate() and added a Fixes tag :-)

Applied with those changes.

johannes


On Sun, 2018-09-30 at 12:53 +0200, stefan.seyfried@googlemail.com wrote:
> From: Stefan Seyfried <seife+kernel@b1-systems.com>
> 
> cfg80211_wext_giwrate and sinfo.pertid might allocate sinfo.pertid via
> rdev_get_station(), but never release it
> 
> Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
> ---
>  net/wireless/wext-compat.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index 167f7025ac98..f462336aac1c 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -1277,12 +1277,16 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
>  	err = rdev_get_station(rdev, dev, addr, &sinfo);
>  	if (err)
>  		return err;
> -
>  	if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
>  		return -EOPNOTSUPP;
>  
>  	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
>  
> +	/* sta_set_sinfo(), called from ieee80211_get_station(), called from
> +	 * rdev_get_station via rdev->ops->get_station, allocates pertid struct
> +	 * which we do not use here. */
> +	kfree(sinfo.pertid);
> +
>  	return 0;
>  }
>  
> @@ -1293,7 +1297,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
>  	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
>  	/* we are under RTNL - globally locked - so can use static structs */
>  	static struct iw_statistics wstats;
> -	static struct station_info sinfo;
> +	static struct station_info sinfo = {};
>  	u8 bssid[ETH_ALEN];
>  
>  	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
> @@ -1352,6 +1356,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
>  	if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_TX_FAILED))
>  		wstats.discard.retries = sinfo.tx_failed;
>  
> +	/* see cfg80211_wext_giwrate() above */
> +	kfree(sinfo.pertid);
> +
>  	return &wstats;
>  }
>  
