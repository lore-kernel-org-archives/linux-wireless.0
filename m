Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E43BC004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F59A20651
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acrnQhzb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F59A20651
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbeJWFcq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:32:46 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:54633 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeJWFcq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:32:46 -0400
Received: by mail-it1-f193.google.com with SMTP id l191-v6so13521593ita.4;
        Mon, 22 Oct 2018 14:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+wAsXlOlyFRy4xu/YOI8PMnkRaNf2EY3S+ifEGDujY=;
        b=acrnQhzbcHL/2TnmjMiFCRDyT7wdO7XmiJphg/9ZwYIpTp2Vgege0VaXkOmPA44/gY
         DIG5rJDXhB8NFU25Cf0VCnXRsUucS1wEJggt1U3pSEO6yyOTLCHVlGag4iU96l8+iavY
         qliMIaAvlyrETJAw2omcCcY/B4qLfnXQ8q+7yb4ljXRk8HM7Aqim7YtXVUCeOVfBjQM8
         syNRpLRHrICAdLm+WKKaw84glI3DSWkNOQ7FQO5yxFfyWVvBSK/lC22Hy7+wMlKyfE6F
         PL6lAJ+8o3GhTQh1SBL7tLGayJOYm9OPY/wdnEd+UK95nn63RTlgbWSt/Ugz6aaVB0n/
         65Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+wAsXlOlyFRy4xu/YOI8PMnkRaNf2EY3S+ifEGDujY=;
        b=r4yH6Sr5rjywC/l3qzCPb0ACAusN/HkNpyxtGal/JwoojJZUawLko+lMFIM/0NNd1R
         uqcocJpEX9hFMq2E/ZNP7Hp173Rzu4LU+Jv2MAKCHS62VJIeT6oYqK2bDsOVSjU1bfyt
         xnW66p0eGb8FV+/Uc7jUcQ/m1NsE3VtRFNRcj5PW+W1oqsTNIG9eS3E5jN18dh+UYgNa
         Pc2VXz5lxIdqQtZrf9b2Fm+Pxpy7YekohAFW4/phzuwwRlqzCJ1ZGCMmxe5/PANsdW85
         JmdezhEjkv2LtIDrw8/AInTzpaohM7GZ5vuqHfjtgDnBswrf63F2SS/MX9DFTHsiHMR7
         IYEg==
X-Gm-Message-State: ABuFfogksJy2VdXwJUG6pt+LVLFKbyFdCuH3LB47jVuQie0Tw+sghBag
        I2OEHP/rTEGAHYDbKWxZ6sfT/sXoMVRzJ3uCLnY=
X-Google-Smtp-Source: ACcGV6313Pe6ghpIfRlj1R/TekFTY4aXV1LfWXVpEtQf8jDhKmJ6gw5wpelrjGiTebAdM+edBTHg3+euReYokdsB3N8=
X-Received: by 2002:a24:de83:: with SMTP id d125-v6mr10309475itg.137.1540242754497;
 Mon, 22 Oct 2018 14:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1540239684.git.gustavo@embeddedor.com> <7932c27ae4e53aceacb7a0a1ae26db91432e5014.1540239684.git.gustavo@embeddedor.com>
In-Reply-To: <7932c27ae4e53aceacb7a0a1ae26db91432e5014.1540239684.git.gustavo@embeddedor.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 22 Oct 2018 14:11:57 -0700
Message-ID: <CALLGbRKoTJbMe+7iyjN66rew08_foAjNZSjeoqkMDSszqHDcQA@mail.gmail.com>
Subject: Re: [PATCH 01/20] ath6kl: Mark expected switch fall-through
To:     gustavo@embeddedor.com
Cc:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        davem@davemloft.net, Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 22, 2018 at 1:37 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Addresses-Coverity-ID: 201383 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/ath/ath6kl/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
> index cb59016..5e7ea83 100644
> --- a/drivers/net/wireless/ath/ath6kl/main.c
> +++ b/drivers/net/wireless/ath/ath6kl/main.c
> @@ -389,6 +389,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
>                 if (!ik->valid || ik->key_type != WAPI_CRYPT)
>                         break;
>                 /* for WAPI, we need to set the delayed group key, continue: */
> +               /* fall through */
>         case WPA_PSK_AUTH:
>         case WPA2_PSK_AUTH:
>         case (WPA_PSK_AUTH | WPA2_PSK_AUTH):
> --
> 2.7.4
>

Looks fine to me. Though it's too bad that the compiler can't detect
the fall through as already clearly commented.

Acked-by: Steve deRosier <derosier@cal-sierra.com>

- Steve
