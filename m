Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4321C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 20:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E21224E0
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 20:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="clW/d5vh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91E21224E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbeKMGDU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 01:03:20 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41189 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbeKMGDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 01:03:20 -0500
Received: by mail-yw1-f66.google.com with SMTP id c126-v6so4840529ywd.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2018 12:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hNjM4YJfFSRMWhAwWFTPb0w8r4Wo0peqzYZxjo/vNfU=;
        b=clW/d5vhCA5WSCttYcjeggBiuC77e041lHaIxUVMGL/B30oyxPehhClD2u4zQXfcPB
         m/U41oG93z3PcpeR3eCNv4zWj+ZevuldppUpSg4nZqtfmZVXMISY4XfEtVYIhZMan71C
         GquUsdG/ZBd0xxShbNfjzGr3L57Mf4SsJYp/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hNjM4YJfFSRMWhAwWFTPb0w8r4Wo0peqzYZxjo/vNfU=;
        b=b4e1C79ixMcCLxr/rfwgxAOeCuWwgZJf1Pv2I8j9oHM+iRCcvWqX0yjYxr1NyTi4B2
         l7WQJv0yrkpuFSKodjus/bO2BGR3CgL/MrbYx5+WavR5Vgn3MwvvzMS6iiHaXNz2Ix5d
         7knzFUH/JPZJ04pC5f2VgZoJwArisqsgZLx74LLpg0VT+5WhffgAXPTlJJiaFrLzTAKl
         YFWVail5YHoIR9tVsR3yfqr8UhxE1E6lxIVfcK8Er1+Z/ytOtHLDlVmYhpszZfvjZ3Vx
         HvCZ+EYSTCsvdbcbaRw2+NUPJOqjalECvVDYQ8T1l3+BxE8fI8Nm5dCQEtUyig++u8Cd
         I3wg==
X-Gm-Message-State: AGRZ1gKJ2ZabR8TrAa82uqDIEBTRvJm0bi+gXQVp3cIcFfmVK437aEe7
        5EW09LSsGw2hd+KKTJyWkcwGcyo6CyAknz6jrCAfQomH
X-Google-Smtp-Source: AJdET5fXj63+DxKa7IIGFcPHg8FcdRcU5rccxBbVRTKNa1Esd6p4ygC0zIVlwzjU+aD+mw+u1+4AbU8rx2KZlUXf6rQ=
X-Received: by 2002:a81:ae1a:: with SMTP id m26-v6mr2378602ywh.14.1542053312731;
 Mon, 12 Nov 2018 12:08:32 -0800 (PST)
MIME-Version: 1.0
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-3-git-send-email-chi-hsien.lin@cypress.com>
 <CA+8PC_fZ8u+ii_6vdvuLSqszzFcNzhd6dz-AHGR6tByfAgPgcg@mail.gmail.com> <f2024bf8-5a1f-1f68-1f1a-aa300c8ce17f@cypress.com>
In-Reply-To: <f2024bf8-5a1f-1f68-1f1a-aa300c8ce17f@cypress.com>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Mon, 12 Nov 2018 12:08:16 -0800
Message-ID: <CA+8PC_fz5PVacy76mNZeRW=TxyXZJgtsY15SnNkhKhJtyMtdTg@mail.gmail.com>
Subject: Re: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from "brcmf_netdev_stop"
To:     Wright Feng <Wright.Feng@cypress.com>
Cc:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>, brcm80211-dev-list@broadcom.com,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Nov 11, 2018 at 6:10 PM Wright Feng <Wright.Feng@cypress.com> wrote=
:
>
>
>
> On 2018/11/9 =E4=B8=8A=E5=8D=88 03:19, Franky Lin wrote:
> > On Wed, Nov 7, 2018 at 7:48 PM Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com=
> wrote:
> >>
> >> From: Wright Feng <wright.feng@cypress.com>
> >>
> >> The firmware does not respond ARP request and causes ping failure with
> >> following steps:
> >>
> >> 1. Bring up interface
> >>     ifconfig wlan0 up or start wpa_supplicant
> >> 2. Set the IP address
> >>     ifconfig wlan0 192.168.100.10
> >> 3. Bring down interface or
> >>     ifconfig wlan0 down or kill wpa_supplicant
> >> 4. Bring up interface again and set the same IP address
> >> 5. Connect to AP(192.168.100.1) and ping to AP will be failed.
> >>
> >> FMAC clears arp_hostip when bringing down the interface, but not set i=
t
> >> back if setting the same IP address. We are able to see the IP address
> >> in interface info(inconfig wlan0) but the ping still cannot work becau=
se
> >> the firmware ARP offload does not respond the ARP request.
> >> Because of that, we remove "arp_hostip_clear" from function
> >> "brcmf_netdev_stop"
> >
> > Shouldn't brcmf_inetaddr_changed get called when the interface up again=
?
> >
> > Thanks,
> > - Franky
> >
> The brcmf_inetaddr_changed only be called in inet_del_ifa and
> inet_insert_ifa. If the IP address is not changed when the interface up
> again, the brcmf_inetaddr_changed will not be called.

Thanks, looks good to me.

>
> -Wright
> >>
> >> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> >> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Reviewed-by: Franky Lin <franky.lin@broadcom.com>

> >> ---
> >>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 --
> >>   1 file changed, 2 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >> index b1f702faff4f..e1666cf3801c 100644
> >> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >> @@ -533,8 +533,6 @@ static int brcmf_netdev_stop(struct net_device *nd=
ev)
> >>
> >>          brcmf_cfg80211_down(ndev);
> >>
> >> -       brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear", NULL, 0);
> >> -
> >>          brcmf_net_setcarrier(ifp, false);
> >>
> >>          return 0;
> >> --
> >> 2.1.0
> >>
> >
> >
> > ----------
> >
> > You're receiving this message because you're a member of the brcm80211-=
dev-list group.
> >
