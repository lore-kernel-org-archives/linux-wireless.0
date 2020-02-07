Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D36C35247
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 02:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD0520838
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 02:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="T4wIiwcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBGCVu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Feb 2020 21:21:50 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33096 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgBGCVu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Feb 2020 21:21:50 -0500
Received: by mail-ot1-f67.google.com with SMTP id b18so747695otp.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2020 18:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NxLizjA/LdZHlqTKcHf2NNbjaoo7PWjl574Z7alvCIs=;
        b=T4wIiwcb3x59GgiPJxBANLn+pX2xC2q8PMd2QVj0Y3NDTegrenzOcRdWfhM3EwM21f
         5p5ve3pdIWt2wp2yXn6rxx1CqckUY0ZWogrQ61nJroYSyMpZMm9GReI5jY/p74A87HO7
         MoQJbophxrQdHrBGGnBeZjI3Hkj8v7tx3Q3ktszR7cFQL7nnUB7gC0EWI3P75vp/a5i1
         202P93tLPGZsY1ld2d8FaOcA6fplSWvCZi2/klOzkshSAjNdTGz9FgxwBKe/HBeLP4Kf
         vhWNMaZTx7nQ0pPA2SnGXYTWyuV+QJrGaQkKg891pOqDTdO1oOhputyXAuGt+A6TV8im
         MZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NxLizjA/LdZHlqTKcHf2NNbjaoo7PWjl574Z7alvCIs=;
        b=U7VXzMnODCFmZgPwJr5XupEThF6PYat5k2frkPW67GEcsHaRZu8Je3ibue7l3gqOX6
         orpChpsH5rZsh74H6smRBM//nao+a7ADIR7lheluhhopbUiFNgKrp9URzfcenRTw1UuG
         Y7Em9hl6zWrVPJ6KMJfXFE3lrnFFpnCu+vz0x6fq8hZ43FZAnLIZDXg5ET8fKiuSUo8P
         XC1+FoJ5a/3SbAiCfqMBe3BHiJQwxK6S6SAnkatJAF0M4gcFaRIWRfNNOTcY2ywtt65Z
         EdoiQTplSksq/OSLJ8uBINVHDAg4hBz42n7neIUEz7NEyAH77jy+f8s+y6WLHtM2MnhB
         rXDg==
X-Gm-Message-State: APjAAAWSHPPyPuUx/9Zj550XWys/ngOZw03LdrIVYDCKDqBkXNZIv2N5
        sCF8U86EaPkrtuP1AtwO2MZi3275yrxOE0EzV9KrWQ==
X-Google-Smtp-Source: APXvYqzMN8QaKAN632TCjxCPMPTtotGucjk/VeSdDvq/62ACuo0eFVhLgHFv3zYf3BO2TqLRHIMf8yeSvpTpbcQFidw=
X-Received: by 2002:a9d:774e:: with SMTP id t14mr921611otl.358.1581042108832;
 Thu, 06 Feb 2020 18:21:48 -0800 (PST)
MIME-Version: 1.0
References: <20200204120614.28861-1-yhchuang@realtek.com>
In-Reply-To: <20200204120614.28861-1-yhchuang@realtek.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 7 Feb 2020 10:21:38 +0800
Message-ID: <CAB4CAwdFez_WbRQb2jZQtqspSkO5ujL31ZLt4XshNcWiSqHByA@mail.gmail.com>
Subject: Re: [PATCH] rtw88: disable TX-AMSDU on 2.4G band
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 4, 2020 at 8:06 PM <yhchuang@realtek.com> wrote:
>
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> Some tests shows that using AMSDU to aggregate TCP ACKs to specific
> APs will degrade the throughput on 2.4G band in 20MHz bandwidth
> (< 10 Mbps, should be ~100 Mbps for 2x2). Also found that there's
> barely no negative impact if we disable TX AMSDU on 2.4G to connect
> to other APs. So it seems like we can just tell mac80211 to not to
> aggregate MSDUs when transmitting on 2.4G band.
>
> Note that we still can TX AMSDU on 5G band and benefit from it by
> having 50 ~ 70 Mbps throughput improvement.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
Reviewed-by: Chris Chiu <chiu@endlessm.com>


>  drivers/net/wireless/realtek/rtw88/mac80211.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 6fc33e11d08c..21b56db16916 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -592,6 +592,20 @@ static int rtw_ops_ampdu_action(struct ieee80211_hw *hw,
>         return 0;
>  }
>
> +static bool rtw_ops_can_aggregate_in_amsdu(struct ieee80211_hw *hw,
> +                                          struct sk_buff *head,
> +                                          struct sk_buff *skb)
> +{
> +       struct rtw_dev *rtwdev = hw->priv;
> +       struct rtw_hal *hal = &rtwdev->hal;
> +
> +       /* we don't want to enable TX AMSDU on 2.4G */
> +       if (hal->current_band_type == RTW_BAND_2G)
> +               return false;
> +
> +       return true;
> +}
> +
>  static void rtw_ops_sw_scan_start(struct ieee80211_hw *hw,
>                                   struct ieee80211_vif *vif,
>                                   const u8 *mac_addr)
> @@ -787,6 +801,7 @@ const struct ieee80211_ops rtw_ops = {
>         .sta_remove             = rtw_ops_sta_remove,
>         .set_key                = rtw_ops_set_key,
>         .ampdu_action           = rtw_ops_ampdu_action,
> +       .can_aggregate_in_amsdu = rtw_ops_can_aggregate_in_amsdu,
>         .sw_scan_start          = rtw_ops_sw_scan_start,
>         .sw_scan_complete       = rtw_ops_sw_scan_complete,
>         .mgd_prepare_tx         = rtw_ops_mgd_prepare_tx,
> --
> 2.17.1
>
