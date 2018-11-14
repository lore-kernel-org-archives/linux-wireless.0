Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C59C43610
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 22:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A6F22419
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 22:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nFwXWlaZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1A6F22419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbeKOJEc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 04:04:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42476 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeKOJEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 04:04:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id 64so4177100pfr.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 14:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=160VrBg1vdyjVL0L8+b58hbfhjigKG+4GGXKgxsn/3g=;
        b=nFwXWlaZeR7dBxONMbcQsDgi0Ityj4eVzbnsvAJk+S2Sy8S2rN7/cA6HW6EWe31lu1
         9kGrgb579ZBUXtH6HF/jKpIlF1nQIx5jt0vyZnD34rPDXkrOiIQoKv3xv8dHi2CHirHI
         ew+JtVJd6WSkJe3CNKq4MPbuWi7vmBLageZZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=160VrBg1vdyjVL0L8+b58hbfhjigKG+4GGXKgxsn/3g=;
        b=mS0WP9wWOhpKSjeO2as+xhJWz4uTgEvNm+WmrQRunhPzZktsdn5a5dqtHQzt426rRG
         GVwp+PKXakosQh5A5eDTpJZjvk3FxuHIoYe18oYExzdPe9hyTDYvvQGrvuU4cS/RIdLA
         MhEZRfaS0Jj8gH/1f8NPtgAKOlCthcp1aHB2FZQhQ0HMYM1VaKpJfGzfKea/4hZTAjuW
         2uY1Ce64QcRLHJb3lf1Ew8NE9MNF+TF+KJbW6HANZ+1rWX2cQVrW8BGOJWb3VNihKTVc
         8SgWE0JwBsp3loLMT9adDWWq8JaxKiZ5gz3FHdTLmKwt708UPz5n3feVoLD3CIkClWQx
         ZwcQ==
X-Gm-Message-State: AGRZ1gIeDuXDKTJ4Qb0TfCYqyJZfulZ0a5WDduC80UFW4creMCNW5Lsj
        BP2TdYlx4FJP5+7LGExSTmG5NQ==
X-Google-Smtp-Source: AJdET5cdA0WPyFkBZdJAGE/ps2smmPjyAUHSO/Hulco/IXcQrM+1aZPKWprqabRf9Mfh28kQyOUO3Q==
X-Received: by 2002:a63:c503:: with SMTP id f3mr3420428pgd.431.1542236355863;
        Wed, 14 Nov 2018 14:59:15 -0800 (PST)
Received: from google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id a10sm7929477pfi.138.2018.11.14.14.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 14:59:14 -0800 (PST)
Date:   Wed, 14 Nov 2018 14:59:11 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
Message-ID: <20181114225910.GA220599@google.com>
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Wen,

You've introduced a regression in 4.20-rc1:

On Thu, Aug 16, 2018 at 02:48:33PM +0800, Wen Gong wrote:
> For WoWLAN support, it expect to support wake up based on discovery of
> one or more known SSIDs. This is the WIPHY_WOWLAN_NET_DETECT feature,
> which shows up as an NL80211 feature flag.
> 
> With an upgrade iw, this shows up in 'iw phy' as:
> WoWLAN support:
> * wake up on network detection, up to 16 match sets
> And it can use command:
> "iw phy0 wowlan enable net-detect interval 5000 delay 30 freqs 2412
> matches ssid foo" to configure the parameters of net detect.
> 
> Firmware will do scan by the configured parameters after suspend and
> wakeup if it found matched SSIDs. Tested with QCA6174 hw3.0 with
> firmware WLAN.RM.4.4.1-00110-QCARMSWPZ-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> ---
> V3:
> -fix the waring of alloc with no test
>  drivers/net/wireless/ath/ath10k/core.h    |   1 +
>  drivers/net/wireless/ath/ath10k/mac.c     |  12 ++
>  drivers/net/wireless/ath/ath10k/wmi-ops.h |  21 +++
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c | 180 +++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/wmi-tlv.h | 226 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h     |  57 ++++++++
>  drivers/net/wireless/ath/ath10k/wow.c     | 174 +++++++++++++++++++++++
>  7 files changed, 670 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 427ee57..7885462 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -904,6 +904,7 @@ struct ath10k {
>  	u32 high_5ghz_chan;
>  	bool ani_enabled;
>  
> +	bool nlo_enabled;
>  	bool p2p;
>  
>  	struct {
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 95243b4..ba9b9af 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -8361,6 +8361,18 @@ int ath10k_mac_register(struct ath10k *ar)
>  	ar->hw->wiphy->max_scan_ssids = WLAN_SCAN_PARAMS_MAX_SSID;
>  	ar->hw->wiphy->max_scan_ie_len = WLAN_SCAN_PARAMS_MAX_IE_LEN;
>  
> +	if (test_bit(WMI_SERVICE_NLO, ar->wmi.svc_map)) {
> +		ar->hw->wiphy->max_sched_scan_reqs = 1;
> +		ar->hw->wiphy->max_sched_scan_ssids = WMI_PNO_MAX_SUPP_NETWORKS;
> +		ar->hw->wiphy->max_match_sets       = WMI_PNO_MAX_SUPP_NETWORKS;
> +		ar->hw->wiphy->max_sched_scan_ie_len = WMI_PNO_MAX_IE_LENGTH;
> +		ar->hw->wiphy->max_sched_scan_plans = WMI_PNO_MAX_SCHED_SCAN_PLANS;
> +		ar->hw->wiphy->max_sched_scan_plan_interval =
> +			WMI_PNO_MAX_SCHED_SCAN_PLAN_INT;
> +		ar->hw->wiphy->max_sched_scan_plan_iterations =
> +			WMI_PNO_MAX_SCHED_SCAN_PLAN_ITRNS;

It seems like youre enabling SCHED_SCAN support? But you're not adding
the NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR feature flag. So it puts
us in a tough place on using randomization -- we either can't trust the
FEATURE flags, or else we can't use both SCHED_SCAN and scan
randomization.

I haven't played with this much at all yet (except to notice that my
tests no longer pass), but maybe you just need to add the FEATURE flag.

Brian

> +	}
> +
>  	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
>  	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
>  	ar->hw->txq_data_size = sizeof(struct ath10k_txq);

...
