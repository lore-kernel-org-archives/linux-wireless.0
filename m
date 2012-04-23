Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55968 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 18:18:00 -0400
Received: by obbta14 with SMTP id ta14so60184obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 15:17:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335210632-19958-4-git-send-email-greearb@candelatech.com>
References: <1335210632-19958-1-git-send-email-greearb@candelatech.com>
	<1335210632-19958-4-git-send-email-greearb@candelatech.com>
Date: Tue, 24 Apr 2012 01:17:59 +0300
Message-ID: <CAB3XZEd8+YORDzCS0ZTVati9E2e05gTP5=7QLirQ=-Kus5DF+A@mail.gmail.com> (sfid-20120424_001805_026763_35DDD6F5)
Subject: Re: [PATCH v4 3/4] mac80211: Framework to get wifi-driver stats via ethtool.
From: Eliad Peller <eliad@wizery.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2012 at 10:50 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This adds hooks to call into the driver to get additional
> stats for the ethtool API.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
[...]

> @@ -463,10 +463,17 @@ static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
>                                       struct net_device *dev,
>                                       int sset)
>  {
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       int rv = 0;
> +
>        if (sset == ETH_SS_STATS)
> -               return STA_STATS_LEN;
> +               rv += STA_STATS_LEN;
>
> -       return -EOPNOTSUPP;
> +       rv += drv_get_et_sset_count(sdata, sset);
> +
this is pretty confusing, because usually negative return value (e.g.
-EINVAL) is valid, and in this case it will corrupt the total sum
instead.

Eliad.
