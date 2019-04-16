Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA738C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F0720857
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BGwlVLsH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DHNK+OoW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfDPHDO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:03:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfDPHDO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 03:03:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 840A460FE9; Tue, 16 Apr 2019 07:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555398192;
        bh=hni7nXSUxC7MktN79I+IONJb6P6lggp+Xmt+/gyEE1A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BGwlVLsHT+UFD8OOu/Otrn6kJ0IK07Z+Ip2jLAOgmo6pKZDMspKR/EiUi6rHZnYDH
         8AjH2Df/uDi/fyJP5T/Q9v96EWXjj36M7yyvTfChxeFbLHjXmyQqyZeG1kiiTrBUGO
         wEKd6YjUp9kE9DhktovuGaMyAERp4ATqBvrAOPI8=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0CB360E41;
        Tue, 16 Apr 2019 07:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555398191;
        bh=hni7nXSUxC7MktN79I+IONJb6P6lggp+Xmt+/gyEE1A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DHNK+OoWBU/hfZ16Cee5lMe8ijC70JYRjjzW9U6GqauaIK5RcqJeAGe2nIYIVoF9H
         QlUAm9IaUMvhXXYksfUsK+d4B/ERUcYp/HwavMvyY7uuB+faIo79M+jk7CfbG3aJOf
         j7UAs0qcBuaBSy3X84iZEgN7kLZsogWffH8N2vCs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0CB360E41
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] mwifiex: fix spelling mistake "capabilties" ->
 "capabilities"
To:     Colin King <colin.king@canonical.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415142649.18452-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <9347fb11-1c45-3db5-da6b-593dcdc4c2f9@codeaurora.org>
Date:   Tue, 16 Apr 2019 12:32:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415142649.18452-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/15/2019 7:56 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There various spelling mistakes in function names and in message
> text. Fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>


I am hoping you have done the compilation test.

Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/net/wireless/marvell/mwifiex/sta_event.c | 12 ++++++------
>   drivers/net/wireless/marvell/mwifiex/uap_event.c |  8 ++++----
>   2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> index a327fc5b36e3..8b3123cb84c8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> @@ -27,9 +27,9 @@
>   
>   #define MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE    12
>   
> -static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
> -					       struct mwifiex_sta_node *sta_ptr,
> -					       struct sk_buff *event)
> +static int mwifiex_check_ibss_peer_capabilities(struct mwifiex_private *priv,
> +					        struct mwifiex_sta_node *sta_ptr,
> +					        struct sk_buff *event)
>   {
>   	int evt_len, ele_len;
>   	u8 *curr;
> @@ -42,7 +42,7 @@ static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
>   	evt_len = event->len;
>   	curr = event->data;
>   
> -	mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilties:",
> +	mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilities:",
>   			 event->data, event->len);
>   
>   	skb_push(event, MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE);
> @@ -937,8 +937,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
>   			    ibss_sta_addr);
>   		sta_ptr = mwifiex_add_sta_entry(priv, ibss_sta_addr);
>   		if (sta_ptr && adapter->adhoc_11n_enabled) {
> -			mwifiex_check_ibss_peer_capabilties(priv, sta_ptr,
> -							    adapter->event_skb);
> +			mwifiex_check_ibss_peer_capabilities(priv, sta_ptr,
> +							     adapter->event_skb);
>   			if (sta_ptr->is_11n_enabled)
>   				for (i = 0; i < MAX_NUM_TID; i++)
>   					sta_ptr->ampdu_sta[i] =
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> index ca759d9c0253..86bfa1b9ef9d 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> @@ -23,8 +23,8 @@
>   
>   #define MWIFIEX_BSS_START_EVT_FIX_SIZE    12
>   
> -static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
> -					 struct sk_buff *event)
> +static int mwifiex_check_uap_capabilities(struct mwifiex_private *priv,
> +					  struct sk_buff *event)
>   {
>   	int evt_len;
>   	u8 *curr;
> @@ -38,7 +38,7 @@ static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
>   	evt_len = event->len;
>   	curr = event->data;
>   
> -	mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilties:",
> +	mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilities:",
>   			 event->data, event->len);
>   
>   	skb_push(event, MWIFIEX_BSS_START_EVT_FIX_SIZE);
> @@ -201,7 +201,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
>   		       ETH_ALEN);
>   		if (priv->hist_data)
>   			mwifiex_hist_data_reset(priv);
> -		mwifiex_check_uap_capabilties(priv, adapter->event_skb);
> +		mwifiex_check_uap_capabilities(priv, adapter->event_skb);
>   		break;
>   	case EVENT_UAP_MIC_COUNTERMEASURES:
>   		/* For future development */
