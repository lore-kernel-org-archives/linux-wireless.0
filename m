Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED29CC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 19:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC0520831
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 19:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="etQLTtPu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DC0520831
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbeKCFAh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:00:37 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38277 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbeKCFAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:00:36 -0400
Received: by mail-yb1-f196.google.com with SMTP id v92-v6so1266464ybi.5
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FrN68734FN5x0R5zki5yFhYrtz48g7IKRzfObGaoGeA=;
        b=etQLTtPu+qZRoYYWFVDWaN3I+XIOmJg+U/EUiedu3kj/gv80JlGc7JJh0IfmP74eqR
         +hGrojM4VNy4S2DkTxTR3VNt0HtuVA9aQJPnGHvsN030DZXDFg2G/rG38AJgAYool1LV
         bkoE0HUxkE5M8wpG31oEW4yR4U95ARPlTyseE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FrN68734FN5x0R5zki5yFhYrtz48g7IKRzfObGaoGeA=;
        b=njc8eNtid4FTDvY2w/M4Uxp+oa/KGyfz9pDnKR4Wfc5roOd6ga7ZZ+r3yb3LO7tyuu
         eLRRy4KlL+NS0E+ovdLKsnxz879hPQA2ejacZBVH6yc1zB1Yaym3sZR65R82ZEgIqfxD
         6LT8Zj9TiVLE2Ic9sZa8X50i15lKLLpU3GmK11xMrHFVtJ4eSdQI4gJmI1iqvbocvIk+
         da51W1CzPOCfk0qgCjwWwOlWoV/9LSd+jtZR8jVz60bVinmoAS8WCOG8PXv/LzL8+eAl
         carH1cJvL5pvQ31xBxqpqx2VYHNHYFZ0a8UZZqxlqNoCipPxcG/JhCMwubfyq+8BrD6U
         NhGQ==
X-Gm-Message-State: AGRZ1gKT2oANPWocUsktBoOXCPSHJmXhZ5fWDeYifuyAlF6kzXtg8aHL
        dDS0645l8/k6j4j6jjApCA8IWSE9TB18a+cUYDppDg==
X-Google-Smtp-Source: AJdET5fe6XuiI4hvwFl7X859DSOLi8XBR7HS/4KvXImrnagBAimLI5hl2oeHxAeYazdmPx22SdOHLq/6296QmCwZ9aY=
X-Received: by 2002:a25:908:: with SMTP id 8-v6mr13001805ybj.357.1541188326430;
 Fri, 02 Nov 2018 12:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
 <CA+8PC_f-EMCWnn1oBorAZjNY2xJXcJbhbP+8fU9wYJXnnZto5w@mail.gmail.com> <55fc2684-bd07-95ae-9193-0d383787ebf8@cypress.com>
In-Reply-To: <55fc2684-bd07-95ae-9193-0d383787ebf8@cypress.com>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Fri, 2 Nov 2018 12:51:54 -0700
Message-ID: <CA+8PC_fVWy=R1VPH4RVPgdTY6D0cA89B4L990F_Kt0Cevgt4+w@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 1, 2018 at 8:08 PM Wright Feng <Wright.Feng@cypress.com> wrote:
>
>
>
> On 2018/10/30 =E4=B8=8A=E5=8D=88 02:50, Franky Lin wrote:
> > On Mon, Oct 29, 2018 at 3:27 AM Wright Feng <Wright.Feng@cypress.com> w=
rote:
> >>
> >> Linux 3.6 introduces TSQ which has a per socket threshold for TCP Tx
> >> packets to reduce latency. In fcmode 1 and fcmode 2, host driver enque=
ues
> >> skb in hanger and TCP doesn't push new skb until host frees the skb wh=
en
> >> receiving fwstatus event. So using skb_orphan before sending skb to bu=
s
> >> will make the skb removing the ownership of socket. With this patch, w=
e
> >> are able to get better throughput in fcmode 1 and fcmode 2.
> >>
> >> Tested 43455 TCP throughput in 20 MHz bandwidth with / without this pa=
tch.
> >> fcmode 0: 59.5 / 59.6 (mbps)
> >> fcmode 1: 59.3 / 23.4 (mbps)
> >> fcmode 2: 59.6 / 21.5 (mbps)
> >>
> >> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> >> ---
> >>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> >> index b2e1ab5..519b25d 100644
> >> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> >> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> >> @@ -2298,6 +2298,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sd=
io *bus, uint maxframes)
> >>                                                &prec_out);
> >>                          if (pkt =3D=3D NULL)
> >>                                  break;
> >> +                       skb_orphan(pkt);
> >
> > TSQ allows device driver to tweak for a deeper queue now. [1]. We
> > should use that instead of orphaning the packet before handing over to
> > firmware which would remove the bufferbloat protection by TSQ.
> >
> > Thanks,
> > -Franky
> >
> Since the aggregation problem has been fixed by setting sk_pacing_shift,
> I will submit v2 without this one.
> Thanks for the information.

No the problem is not fixed. The patch just provides an interface
sk_pacing_shift_update so the device driver can tweak the scale to
allow more packets being queued. You need to call
sk_pacing_shift_update somewhere in brcmfmac.

Thanks,
-Franky
>
> -Wright
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D3a9b76fd0db9f
> >
> >>                          __skb_queue_tail(&pktq, pkt);
> >>                  }
> >>                  spin_unlock_bh(&bus->txq_lock);
> >> --
> >> 1.9.1
> >>
