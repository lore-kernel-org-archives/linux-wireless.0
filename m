Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA43C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 10:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979152080D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 10:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=globallogic.com header.i=@globallogic.com header.b="Af3F+MMD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 979152080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=globallogic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbeKOUQO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 15:16:14 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36843 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbeKOUQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 15:16:14 -0500
Received: by mail-qk1-f196.google.com with SMTP id o125so30913126qkf.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2018 02:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=globallogic.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=gzKiM0B9s5x2tWFQ6uMFojXs688O4xfkjpyJkb9IlGY=;
        b=Af3F+MMDYmD/HEaRX5/2BAPeDxlZeLlQwk4K7pkPqocTJa04v6Uq20ooE3XrW7Gp9y
         eR2GMgTdgQ1gdL9S+vSkw4KL4XmKwm9wYOU05I3wdlnl6eRDBrL98zWkDi1keASUgqb/
         jRjgt736ghfNGT6eXeFYDaRLk0F9oDpqO6Pys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=gzKiM0B9s5x2tWFQ6uMFojXs688O4xfkjpyJkb9IlGY=;
        b=mi6mz8RAhrOKAOtOCr2GQ0yedIEOj6PG9d0Gwm7nf/jFK6mYbqz7wQ06q0TJERNDzm
         eI/XTTYFNHR9v0/jvg/L8N/28OQ22TzxqNfLwT+3EPE81pW20/YNC8qrs3HpccYcXruR
         ftnsReIA5v7L8kZg4uTDwQ0EL/BHjsULU7ISF4v4sVXkCrG52qA+YBeMVfFLtB4q5Z0W
         M64/JhUFJFHSj6NgkR8lst1vWcowv6URmdIYlTBOu18kiZLRkicd6r6Oh9U5Z0/va5zE
         JkaRGzCXURIMOUtWoLLqoH42PJ0RcjfmCP6x7sepHlUaGGxoL/HF/4Oke5wnB8LsbVoM
         iiMw==
X-Gm-Message-State: AGRZ1gJAkvR3uAM7FgkkXyEDWOOsXfh/TyS1z9AUnK8KaoUTmI1w485C
        E8RX8Y3sfd0US593FYcdtlOXbMctq2l2zNkOm1WAQg==
X-Google-Smtp-Source: AJdET5dthGL3FfNEDOMWlnQzFr9IKEGUL3b+E5TwEjZy8xTvfRlTFPTigQNoh3UVM6/R0jkA2hm6tHtUeobc/Kiz85c=
X-Received: by 2002:a0c:8a54:: with SMTP id 20mr5445010qvu.94.1542276543432;
 Thu, 15 Nov 2018 02:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20181017220212.15240-1-vvavrychuk@gmail.com>
In-Reply-To: <20181017220212.15240-1-vvavrychuk@gmail.com>
From:   Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
Date:   Thu, 15 Nov 2018 12:08:52 +0200
Message-ID: <CAMqC21BvHZeFRv1rkBrRejzytGORtCuBKo6q5FMhQZPHoOcfmg@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: Timer should be initialized before device registered
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Does anyone have some feedback about this?

On Thu, Oct 18, 2018 at 1:02 AM Vasyl Vavrychuk
<vasyl.vavrychuk@globallogic.com> wrote:
>
> From: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
>
> Otherwise if network manager starts configuring Wi-Fi interface
> immidiatelly after getting notification of its creation, we will get
> NULL pointer dereference:
>
>   BUG: unable to handle kernel NULL pointer dereference at           (null)
>   IP: [<ffffffff95ae94c8>] hrtimer_active+0x28/0x50
>   ...
>   Call Trace:
>    [<ffffffff95ae9997>] ? hrtimer_try_to_cancel+0x27/0x110
>    [<ffffffff95ae9a95>] ? hrtimer_cancel+0x15/0x20
>    [<ffffffffc0803bf0>] ? mac80211_hwsim_config+0x140/0x1c0 [mac80211_hwsim]
>
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 1068757ec42e..d0e0a9f5bf98 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2890,6 +2890,10 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>
>         wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
>
> +       tasklet_hrtimer_init(&data->beacon_timer,
> +                            mac80211_hwsim_beacon,
> +                            CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> +
>         err = ieee80211_register_hw(hw);
>         if (err < 0) {
>                 pr_debug("mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
> @@ -2914,10 +2918,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>                                     data->debugfs,
>                                     data, &hwsim_simulate_radar);
>
> -       tasklet_hrtimer_init(&data->beacon_timer,
> -                            mac80211_hwsim_beacon,
> -                            CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> -
>         spin_lock_bh(&hwsim_radio_lock);
>         err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
>                                      hwsim_rht_params);
> --
> 2.19.1
>


-- 
Vasyl Vavrychuk  | Software Engineer
GlobalLogic L'viv
Skype: vasyl.vavrychuk
www.globallogic.com

http://www.globallogic.com/email_disclaimer.txt
