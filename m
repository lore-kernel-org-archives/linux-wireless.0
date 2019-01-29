Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EBFC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF85220844
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kBLt7Pt6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfA2SxB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:53:01 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44190 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfA2SxB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 13:53:01 -0500
Received: by mail-ed1-f67.google.com with SMTP id y56so16847188edd.11
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 10:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ne3/pZn84TgQpMnCsKdjR/xQBD4QmW9srnZyxCcRvp8=;
        b=kBLt7Pt6h1JdF4e6Uosih3sXSt/p3Rkw6TWiHxknI+gkw2S7neD4LuB72nHYoDbLuZ
         jXrvDxaGt/Q34FehM5dno73j8YzNutS21T1uhepAmAG7gS7+kLcbp+P85IpQv5CANsPW
         dAw2XFYWdH7KAhgzB+906hq4NXiWx5opE5A5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ne3/pZn84TgQpMnCsKdjR/xQBD4QmW9srnZyxCcRvp8=;
        b=Iybtw/c0b71SsUkCZhzO0QsQADNMAL6x++vOOA30fRY9wBz6VOk8lWH5XHqJT3I2/S
         jqYAgZ1njkBAoG/BH9toMH6JdVEsaWWPUAN0bIfuTR7kzLjU5l7Sj0veA6yPPQgrv636
         xE2PvJctF6XB6iAIOasSt9fDS0hLlWb1DUl47N8SppH4wShyMJ2XMppU6cXX3YjbItQN
         0mJcazGhTNy70a71mssVpmVRufcc5h50SFDbJZsl4Cgelnru+YH2rgiV6HZ2Nq8HSdJU
         yx/i6716DMWf1E6KeXJmq+OqOdFeklMw9cIU5oz5P8y4rmx4O2OT9X55jMWWUupSxntU
         IeHw==
X-Gm-Message-State: AJcUukfZ0prU6O8P0g2WBfFOIeSHzJFzBpna5PuMGyg3CdXpDLgFHgFh
        tsJiRSJsIKEQsXDpAZM8YX+EGxfs6fE=
X-Google-Smtp-Source: ALg8bN5mD7JLcfP61Bblt8IGIFy3XFa1/cuHdnwTJhp+dACn2Bu+KVJc+uYOmv2rGPbpalVOCI22NQ==
X-Received: by 2002:a17:906:6a8f:: with SMTP id p15mr8271494ejr.218.1548787978764;
        Tue, 29 Jan 2019 10:52:58 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id q50sm14403822edd.66.2019.01.29.10.52.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:52:56 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id f9so16837613eds.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 10:52:56 -0800 (PST)
X-Received: by 2002:a50:951a:: with SMTP id u26mr26638799eda.4.1548787976141;
 Tue, 29 Jan 2019 10:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20190128154310.17322-1-stefan@agner.ch>
In-Reply-To: <20190128154310.17322-1-stefan@agner.ch>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 29 Jan 2019 10:52:44 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPawX9QnHG-y6HYdhKSZbzzTzYpwt_oMaXPz5+pqC5Ddg@mail.gmail.com>
Message-ID: <CA+ASDXPawX9QnHG-y6HYdhKSZbzzTzYpwt_oMaXPz5+pqC5Ddg@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: don't print error message on coex event
To:     Stefan Agner <stefan@agner.ch>
Cc:     amit karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>, huxinming820@gmail.com,
        Kalle Valo <kvalo@codeaurora.org>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 7:43 AM Stefan Agner <stefan@agner.ch> wrote:
>
> The BT coex event is not an error condition. Don't print an error
> message in this case. The same even in sta_event.c prints a
> message using the debug level already.

For some reason, that one (and a handful of others) uses dev_dbg()
instead of mwifiex_dbg() with an appropriate mask (e.g., EVENT). But
mwifiex_dbg() seems preferable for consistency.

> Signed-off-by: Stefan Agner <stefan@agner.ch>

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/uap_event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> index e86217a6b9ca..ca759d9c0253 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
> @@ -300,7 +300,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
>                 mwifiex_11h_handle_radar_detected(priv, adapter->event_skb);
>                 break;
>         case EVENT_BT_COEX_WLAN_PARA_CHANGE:
> -               dev_err(adapter->dev, "EVENT: BT coex wlan param update\n");
> +               mwifiex_dbg(adapter, EVENT, "event: BT coex wlan param update\n");
>                 mwifiex_bt_coex_wlan_param_update_event(priv,
>                                                         adapter->event_skb);
>                 break;
> --
> 2.20.1
>
