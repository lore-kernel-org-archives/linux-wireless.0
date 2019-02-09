Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A7FC169C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 03:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2EE20869
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 03:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fRahoFhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBIDIH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 22:08:07 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38170 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfBIDIH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 22:08:07 -0500
Received: by mail-pl1-f194.google.com with SMTP id e5so2584269plb.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 19:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wqWVQT4rbv9tmvB5Gam1VVHkKawi7LSfY69+JrkY/no=;
        b=fRahoFhRp4SvMgsQZIJblXtx5QORum/vtX0EuRPkBHQqR5d/aZfoD+gLsEaRlYGdIF
         oYD/bpik1V8bdnS5xHsezth+QPEHpNpbar1uLqfnRZP9kktJ/cuSdbBMs1mkVw23L+Ty
         bhKW7pHK2ZqLvkvknUep1csIsKkArOBGQwRbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wqWVQT4rbv9tmvB5Gam1VVHkKawi7LSfY69+JrkY/no=;
        b=W2o/zRCOQ9C9AA/6ogh+J9/Jgv+6yqpTxkhSL0207SKJy2+lEa3/X4ixJV2WwL4DHC
         Q8e7xRM6HdEhutN24rF7lmVYslxwPXW8M73ZDoMW1w2dunho+qLvWEmAlyggcgvIhJxf
         6dszFEkigCMTccIOJ15X5RRt2/1BWi0godaYdeCHDZbd5STD1PzRkTv3j2UjzJFhttIP
         R1fq/ZmVpsVuNjIVER6LfJBlZMSjFn5Dzxj6PzVXWbVGBg1zTMgd1x6DqWj8ULrlv9wK
         bRujh+Bv4hqh4DehWEB+4CiBGzVDPcTQ9DkhbYYVx82oPlKlS+Ls9N2lo0YkDJv/TEuC
         /xJw==
X-Gm-Message-State: AHQUAubUsliFvbAUN3MMZEDYuiBSejPfMzybsOyGZUgsLCkV40DCoTcK
        8shapyM6n8ofk53ANRJgAz10QQ==
X-Google-Smtp-Source: AHgI3IYFsLRrZGsCr5f24fEpNCFR7wpV9646EKkaQDjjXsrnHxxa9R2nogRP774jbc1zsPFNTr1tUg==
X-Received: by 2002:a17:902:780a:: with SMTP id p10mr26906628pll.54.1549681686679;
        Fri, 08 Feb 2019 19:08:06 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id b13sm7147277pfj.66.2019.02.08.19.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 19:08:05 -0800 (PST)
Date:   Fri, 8 Feb 2019 19:08:03 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/24] rtw88: report correct tx status if mac80211
 requested one
Message-ID: <20190209030756.GB163159@google.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-2-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548937297-14660-2-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 31, 2019 at 08:21:14PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Before this commit, driver always reports IEEE80211_TX_STAT_ACK for
> every tx packet, but it will confuse the mac80211 stack for connection
> monitor system. mac80211 stack needs correct ack information about some
> specific packets such as prop_req, null, auth, assoc, in order to know
> if AP is alive. And for such packets, mac80211 will pass a tx flag
> IEEE80211_TX_CTL_REQ_TX_STATUS to driver. Driver then need to request a
> tx report from hardware.

I think you're misinterpreting the mac80211 semantics here. This flag
isn't for the driver to determine whether or not it should report ACKs
-- it's to help ensure that status reports *really* make it back up to
the upper layers (and don't get dropped).

On the contrary, if you look at __ieee80211_tx_status(), it's expecting
that everything that has IEEE80211_HW_REPORTS_TX_ACK_STATUS will report
an appropriate IEEE80211_TX_STAT_ACK status. The logic is basically:

	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
		if (!(info->flags & IEEE80211_TX_STAT_ACK))
			ieee80211_lost_packet(sta, info);

That explains why I see almost every packet get reported as lost in `iw
wlan0 station dump`.

> The tx report is not passed by hardware with the tx'ed packet, it is
> passed through C2H. So driver need to queue the packets that require
> correct tx report and upon the tx report is received, report to mac80211
> stack, with the frame is acked or not.
> 
> In case of driver missed the C2H report, setup a 500ms timer to purge
> the tx report skb queue (500ms is time mac80211 used as probe_time).
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c   | 21 ++++++-
>  drivers/net/wireless/realtek/rtw88/fw.h   |  8 +++
>  drivers/net/wireless/realtek/rtw88/main.c | 10 ++++
>  drivers/net/wireless/realtek/rtw88/main.h | 13 +++++
>  drivers/net/wireless/realtek/rtw88/pci.c  |  8 ++-
>  drivers/net/wireless/realtek/rtw88/pci.h  |  1 +
>  drivers/net/wireless/realtek/rtw88/tx.c   | 96 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/tx.h   |  8 +++
>  8 files changed, 163 insertions(+), 2 deletions(-)

...

> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index ef3c9bb..7de4638 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -585,6 +585,7 @@ static int rtw_pci_xmit(struct rtw_dev *rtwdev,
>  
>  	tx_data = rtw_pci_get_tx_data(skb);
>  	tx_data->dma = dma;
> +	tx_data->sn = pkt_info->sn;
>  	skb_queue_tail(&ring->queue, skb);
>  
>  	/* kick off tx queue */
> @@ -716,8 +717,13 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
>  		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
>  
>  		info = IEEE80211_SKB_CB(skb);
> +
> +		/* enqueue to wait for tx report */
> +		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> +			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);

This reporting code appears to be very buggy. At least, it's extremely
easy to hit the WARN() you've inserted ("purge skb(s) not reported by
firmware"), which means that the TX reporting queue is not getting
responses for a lot of packets.

So it's not clear if you should be trying to accurately report
everything (even if your firmware status reports are unreliable), or if
you should just drop the REPORTS_TX_ACK_STATUS feature.

> +			continue;
> +		}
>  		ieee80211_tx_info_clear_status(info);
> -		info->flags |= IEEE80211_TX_STAT_ACK;
>  		ieee80211_tx_status_irqsafe(hw, skb);

One other problem with your code is that it doesn't check for
IEEE80211_TX_CTL_NO_ACK anywhere. With that flag, you should be
reporting IEEE80211_TX_STAT_NOACK_TRANSMITTED instead of
IEEE80211_TX_STAT_ACK.

>  	}
>  

Brian
