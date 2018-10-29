Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5953C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 18:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F56D2082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 18:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EIMh1TWw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F56D2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbeJ3DkM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 23:40:12 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38706 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbeJ3DkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 23:40:12 -0400
Received: by mail-yb1-f195.google.com with SMTP id v92-v6so3905821ybi.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qt2JpCU7hyxcma94vNLL2jySJE58SOVquiIMtRS2uL0=;
        b=EIMh1TWwXp2iJQMu7UxfqMj71k58F2VFKWF8D0fo3MwDSQuO+18ajsoqOpgkdiQuju
         LiAAPN85SxQcL1c3Oq2+pbo5ccSotBXvpZHaop9i0PaBA0GNf0KcDcBEJIyzzxnQMKr2
         CRWbDMEubKaatqUKIzaNovDv6pYjAvbLiymnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qt2JpCU7hyxcma94vNLL2jySJE58SOVquiIMtRS2uL0=;
        b=KIkuv6BkRPNefCnnZENZ8vLpp6cw8HVj72rxgznPs5XKDPjh0i6t0L1SZnD8k/Fg1I
         PsbKETxiy/KFQ4wvM727ykk4zVYisYszcjgMp1RsjSPirp3EudRrFOKZV/31DctmInLT
         SuQPFrUjpBQABxVtka+ryyzB50GPdTRgBqi6sFgq7CPzAyJOiUNEb6qIvwEI7LPwY9RD
         dZA/1bfMoRWxCN92jn9VmxbC9IvAvJFnEbHlCkvasqrT56bnn3G5KdGADfyhu1atC7X4
         HJgelMHQTZPrDUQRzNehPUbP4T5t9wUHTQc4bQX3Gryn4UvenmDYKzOMgo0B3yYBNndW
         440Q==
X-Gm-Message-State: AGRZ1gKQ4qHi61ey+8e2Zj7H0sfWJ+UbmkyT0WO9e3n4FgssvOvVYKz2
        mH9Kujv1052o72jYTGOqYjRdQwLp8GQNpzlYcq46pw==
X-Google-Smtp-Source: AJdET5ePvMdXDUkmUuEOfUywGdUc9XGbmnceIR0O+39x3oC+WL/F1tt7e+7qMs2mjMCNlqulWApMEx4kK/tml9ZHLZQ=
X-Received: by 2002:a25:4a02:: with SMTP id x2-v6mr15254531yba.72.1540839016209;
 Mon, 29 Oct 2018 11:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com> <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
In-Reply-To: <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Mon, 29 Oct 2018 11:50:05 -0700
Message-ID: <CA+8PC_f-EMCWnn1oBorAZjNY2xJXcJbhbP+8fU9wYJXnnZto5w@mail.gmail.com>
Subject: Re: [PATCH 1/3] brcmfmac: calling skb_orphan before sending skb to
 SDIO bus
To:     Wright Feng <Wright.Feng@cypress.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 3:27 AM Wright Feng <Wright.Feng@cypress.com> wrote:
>
> Linux 3.6 introduces TSQ which has a per socket threshold for TCP Tx
> packets to reduce latency. In fcmode 1 and fcmode 2, host driver enqueues
> skb in hanger and TCP doesn't push new skb until host frees the skb when
> receiving fwstatus event. So using skb_orphan before sending skb to bus
> will make the skb removing the ownership of socket. With this patch, we
> are able to get better throughput in fcmode 1 and fcmode 2.
>
> Tested 43455 TCP throughput in 20 MHz bandwidth with / without this patch.
> fcmode 0: 59.5 / 59.6 (mbps)
> fcmode 1: 59.3 / 23.4 (mbps)
> fcmode 2: 59.6 / 21.5 (mbps)
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index b2e1ab5..519b25d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -2298,6 +2298,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
>                                               &prec_out);
>                         if (pkt == NULL)
>                                 break;
> +                       skb_orphan(pkt);

TSQ allows device driver to tweak for a deeper queue now. [1]. We
should use that instead of orphaning the packet before handing over to
firmware which would remove the bufferbloat protection by TSQ.

Thanks,
-Franky

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a9b76fd0db9f

>                         __skb_queue_tail(&pktq, pkt);
>                 }
>                 spin_unlock_bh(&bus->txq_lock);
> --
> 1.9.1
>
