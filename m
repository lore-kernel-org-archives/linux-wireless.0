Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A842C282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 16:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB942070D
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 16:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KUnSmQpJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfEWQme (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 12:42:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37116 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731107AbfEWQme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 12:42:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id h19so635264ljj.4
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2019 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omMwdyh9wtTqdxcHIQUMSQldil51FIXUWgVsjyb0s0U=;
        b=KUnSmQpJU2YN62tQE6JYfetN+ZdS1twcY6q48/iMfV30g6wIKl6c8Ssfq7ZiOO88K3
         tYeuZhe7uq5JD94F9pMqxbamfhlyD1Ub+7i16SPX+o9y25B/4lLYDIgH4iQ4+jBTXhqe
         +ePBlAZA+gI3aI2xDAcYYorH6l0LiB+rHj0ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omMwdyh9wtTqdxcHIQUMSQldil51FIXUWgVsjyb0s0U=;
        b=VdRiRJWzqIVp49/QpujDv180j6UK7PY17YYvQBs0o/UqxXxmWtH6W3XqUKc8QDpxyS
         IOiya6177kVUxHmXrMmVNxhPmmHK+9lKRV2GlMUDUHtyJGCVhfeK60iROIgIQsm/gWBM
         +aSpK+lilekxFs1vEV5dLojR829ibfBxWFZdlqEPHQvVz3XL7Zck9DAkQRjzF4BSyeHW
         lcde02rV54CyqMnnpOZvThFXUYViZW3HY67TEk3wSZ1KlzyjiusNF1WZ66DD3OUWmrBn
         lh/Q2Jb8iYG98/siLjfGs02Z1W+GO1eKOHpptmPB9trCo+WyforPa1VpMJKLsdrnPuFS
         g74Q==
X-Gm-Message-State: APjAAAVDa/9E5sBuHeyVlWvrcqr+iK3MqVMzOIwBQocJG9TE3tndYwEG
        U7CZkhCOZ0CatCUjOMVwIswg9m5UPLE=
X-Google-Smtp-Source: APXvYqzC/IHrsv9vaPA61rgIQTp6Aqe3NVhwC5t/7UCz6wZIFMgPL84BCbDJ2P91dL9yEikSb0d9fw==
X-Received: by 2002:a2e:98d5:: with SMTP id s21mr30557724ljj.142.1558629751628;
        Thu, 23 May 2019 09:42:31 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id v16sm5972251lji.88.2019.05.23.09.42.30
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 09:42:30 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id 14so6115075ljj.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2019 09:42:30 -0700 (PDT)
X-Received: by 2002:a2e:9849:: with SMTP id e9mr381999ljj.185.1558629750272;
 Thu, 23 May 2019 09:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190523071534.254611-1-tientzu@chromium.org>
In-Reply-To: <20190523071534.254611-1-tientzu@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 23 May 2019 09:42:18 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMaKpMWnLnKxeft-8eKfpM6qGDsmEzvh290JCCjeRRtxQ@mail.gmail.com>
Message-ID: <CA+ASDXMaKpMWnLnKxeft-8eKfpM6qGDsmEzvh290JCCjeRRtxQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: add missing error handling
To:     Claire Chang <tientzu@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, May 23, 2019 at 12:15 AM Claire Chang <tientzu@chromium.org> wrote:
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -607,6 +607,10 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
>                                                     full_len,
>                                                     last_in_bundle,
>                                                     last_in_bundle);
> +               if (ret) {

IIUC, you have basically the same failure case a few lines up, where
ath10k_sdio_mbox_alloc_pkt_bundle() may fail. Do the same there?

This (including the error label to which it's jumping) looks fine to me though:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> +                       ath10k_warn(ar, "alloc_rx_pkt error %d\n", ret);
> +                       goto err;
> +               }
>         }
>
>         ar_sdio->n_rx_pkts = i;
