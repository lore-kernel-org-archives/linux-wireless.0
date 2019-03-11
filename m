Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A417C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 17:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF0220828
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 17:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="a5K+ndER"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfCKRY0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:24:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44121 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbfCKRY0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 13:24:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id h34so985091pgh.11
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 10:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QhyIzGq/ucgEPNNC7oG+opioeqwiDPtQ6m2FI2GQUDo=;
        b=a5K+ndERE1RPpLMCd07gDADVR/Fl4SBgMkpnJfv+gABtE1iSo3Agg0nYcpF08d2J6x
         x0xVgOkgoy7HJ+oYyy9bFZweYZJflf2Rx/tJZT92O99eHCo/A3GH3bUCJko/tewpG3BF
         ARECqFbaQa/NM7rZBL9NOH73NsfFpWWRfDoog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QhyIzGq/ucgEPNNC7oG+opioeqwiDPtQ6m2FI2GQUDo=;
        b=R28Hy5+F8gIy/F4PymGRp7KyWk08EIjCOGvUI9WAt2bqp2nJt+j437nfzPMGHun8zj
         RHZEN4HT4DqwoIrQwj37VHzfNJ9wCHyzGhdT38Jt8V3y0sRQszLiTDiD5K4MMM7nYokC
         uRfjBuPs2jVQcw/UV06UMPix8iZp1di+yl1wHf/RlKfb5/sbUludMLU+pkxpphrVK46I
         yqazPltBdIySs0sjiZ7VGbWCROR1314p5smEr8qkIbUlxalu4JyMmFOhaLpPSF3/Zmq0
         s6d+uDGUPOpY8esh+RCg1Sfo0QYnjHVIkrBo7c9L1WimL2ANvwhzXE5f4FzAdAOZzwxG
         +hJg==
X-Gm-Message-State: APjAAAXF6L9d0JnRmhYnLdZxXAAmHlR/BulqBhn33+LjDuJM9ya9XKUD
        zHh0IDalKotpBK6cdL+Iqaqv9g==
X-Google-Smtp-Source: APXvYqzpqJ5YcHlNl4s5jmobJWHFfc/L4k0bdNIPOi5LU34woUZhSnE74qd4z7EAD9n/yrG/TZTAEw==
X-Received: by 2002:a17:902:403:: with SMTP id 3mr35194200ple.48.1552325064848;
        Mon, 11 Mar 2019 10:24:24 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id z6sm22766374pgo.31.2019.03.11.10.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 10:24:23 -0700 (PDT)
Date:   Mon, 11 Mar 2019 10:24:21 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mwifiex: fix a NULL pointer dereference
Message-ID: <20190311172419.GA133390@google.com>
References: <20190311074347.32003-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311074347.32003-1-kjlu@umn.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 02:43:47AM -0500, Kangjie Lu wrote:
> In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
> NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 60db2b969e20..5565f18039ab 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -341,6 +341,12 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
>  		sleep_cfm_tmp =
>  			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
>  				      + MWIFIEX_TYPE_LEN);
> +		if (!sleep_cfm_tmp) {
> +			mwifiex_dbg(adapter, ERROR, 

You have trailing whitespace. Please run your patches through
scripts/checkpatch.pl.

> +				    "SLEEP_CFM: dev_alloc_skb failed\n");
> +			return -ENOMEM;

It's not exactly a problem with your patch, but nobody really checks the
return status of this function. I think in most (all?) cases, that's
probably OK, because we also implicitly communicate the success/failure
of this function by modifying the ->ps_state field (basically, a state
machine). So this is probably OK.

Other than the whitespace:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> +		}
> +
>  		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm)
>  			+ MWIFIEX_TYPE_LEN);
>  		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);
> -- 
> 2.17.1
> 
