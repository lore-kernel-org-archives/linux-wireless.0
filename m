Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAF7C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E0D218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfCWMcv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 08:32:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48936 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfCWMcv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 08:32:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h7fpR-0008Ft-96; Sat, 23 Mar 2019 13:32:49 +0100
Message-ID: <3d76d0d033609fff4e72448a9fd7d63ad1365cb2.camel@sipsolutions.net>
Subject: Re: [RFC PATCH] mac80211/cfg80211: update bss channel on channel
 switch
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Date:   Sat, 23 Mar 2019 13:32:47 +0100
In-Reply-To: <20190321151915.16826-1-sergey.matyukevich.os@quantenna.com> (sfid-20190321_162003_388890_DC9426EB)
References: <20190321151915.16826-1-sergey.matyukevich.os@quantenna.com>
         (sfid-20190321_162003_388890_DC9426EB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-03-21 at 15:19 +0000, Sergey Matyukevich wrote:
> FullMAC STAs have no way to update bss channel after CSA channel switch
> completion. As a result, user-space tools may provide inconsistent
> channel info. For instance, consider the following two commands:
> $ sudo iw dev wlan0 link
> $ sudo iw dev wlan0 info
> The latter command gets channel info from the hardware, so most probably
> its output will be correct. However the former command gets channel info
> from scan cache, so its output will contain outdated channel info.
> In fact, current bss channel info will not be updated until the
> next [re-]connect.
> 
> Note that mac80211 STAs have a workaround for this, but it requires
> access to internal cfg80211 data, see ieee80211_chswitch_work:
> 
> 	/* XXX: shouldn't really modify cfg80211-owned data! */
> 	ifmgd->associated->channel = sdata->csa_chandef.chan;
> 
> This patch suggests to convert mac80211 workaround to cfg80211 behavior
> and to update current bss channel in cfg80211_ch_switch_notify.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> ---
> 
> This issue has been observed for both qtnfmac and brcmfmac. Fix tested
> for qtnfmac and iwlwifi, to make sure there is no regression for mac80211.
> However this is not going to be enough to fix brcmfmac behavior as it
> does not use cfg80211_ch_switch_notify. This issue may also affect
> ath6kl and mwifiex, but I have no hardware to check.

Yeah, I think this makes sense.

> +	if (wdev->iftype == NL80211_IFTYPE_STATION) {
> +		if (wdev->current_bss)
> +			wdev->current_bss->pub.channel = chandef->chan;
> +	}

Maybe do

	if (wdev->iftype == ... &&
	    !WARN_ON(!wdev->current_bss))
		wdev->current_bss->... = ...

I worry slightly about locking too, since there's no protection on the
wdev->current_bss pointer here.

johannes

