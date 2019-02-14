Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B20C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DAB218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PdcrG8mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406963AbfBNMrD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:47:03 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44518 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfBNMrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:47:03 -0500
Received: by mail-yb1-f193.google.com with SMTP id b15so2305780ybn.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 04:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4gyTzGabvmYvtZ0trvKTxteU2ppHrR2McLgybLK1zKA=;
        b=PdcrG8mvWb9bKYzihCn6iNTYEZs2y3gKJ4PB47WLcVxRHcyFfEqhYTaqnjvXMVrmgl
         xbrh9q2CG6E8QcEefwjazCHtgR9mC9DKRSERlgSEg2gOArJJCadSpOUAAsEzfWxJyWlk
         QDNT2z0Asu5ukN00igFvKGaaR+5Emq9Fjuwo0RzB1eBHTncENiV4c/844bNUAnzMzvrL
         gypuoWTaF0nwMywwffFGyjsD7wquxB17YkUl5kxckvGa3Bsj3KW8ZZZCOkCfnkpMbi46
         lU9yS5JlpMGTN54sZeCprMvks82hILtRSkqJyXJpvPcrZIG552qXIoNfnXEe0MoQ9+w7
         KLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4gyTzGabvmYvtZ0trvKTxteU2ppHrR2McLgybLK1zKA=;
        b=fgNqFMmw9jiy2DDm+hzy6dZ7WRcMlQba8HJkE8wVZo2cxKcQ8+hzupyiLyaTriHCDN
         zu62Dk5TBOqa+/YoT6/epfsVJwFdx9U+xaDDAHjPBpEKSVXuwtS9S4XNaUW86FO8R8T9
         FPRDo1r8FuXRviRUyno2Bujd8G1bvxtXRqc54QyAhdhi85Z4nQwKGnKgUPr5PW/fmQ9c
         W99bwkv/Lcn+p/NLFtVkl4fJCE2l6sz6beYMXLW5mS0chDETGCiavR4J3CLVmbljkQfY
         LB2IDo2pGRTaVqelFXWNCb4OEp5Gb5IZXSdusDKW5/xFUGIkFIqWBOY1qzgoUTYs1pOV
         OTzQ==
X-Gm-Message-State: AHQUAuapPLmKZIg3AFn09Y2FPbDrFMqE1fNDT9lCtml9k0hms4BxCrzy
        BZyHvGBvQEnPGc4iDhAlZq4I/aGfh8dN7RHvU4FYZowmUuU=
X-Google-Smtp-Source: AHgI3IbcvnQ6Ub7wmzGimDhzCxVeodlhCEhMYgDKx63GJIisTRK3G+broioymMtprhnykyNpqeye9GdnO/F6uLK1kw4=
X-Received: by 2002:a25:5582:: with SMTP id j124mr2930332ybb.2.1550148422183;
 Thu, 14 Feb 2019 04:47:02 -0800 (PST)
MIME-Version: 1.0
References: <20190213112619.23899-1-zajec5@gmail.com> <cc894af8-c61d-076a-d32d-41b566d73017@broadcom.com>
In-Reply-To: <cc894af8-c61d-076a-d32d-41b566d73017@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Thu, 14 Feb 2019 13:46:51 +0100
Message-ID: <CACna6rzMNWS4zezkLF1y_ynu-RMbZfmgfAqJa+dijtVoB8qHsQ@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 14 Feb 2019 at 13:38, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/13/2019 12:26 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > This recently added macro provides more meaningful error messages thank=
s
> > to identifying a specific wiphy. It's especially important on systems
> > with few cards supported by the same (brcmfmac) driver.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> > ---
> > I obviously couldn't hit & test all error cases. To perform some basic
> > testing I added:
> > bphy_err(wiphy, "test\n");
> > for every wiphy variable added by this patch & tested in on BCM4366.
> >
> > I got a lot of messages like:
> > [ 2842.424524] ieee80211 phy1: brcmf_netdev_start_xmit: test
> > [ 2842.434921] ieee80211 phy1: brcmf_msgbuf_txflow: test
> > [ 2842.440275] ieee80211 phy1: brcmf_msgbuf_process_msgtype: test
> > [ 2842.446141] ieee80211 phy1: brcmf_get_ifp: test
> > so it seems to work correctly.
>
> I was thinking about fact that module name is no longer prefixed, but I
> am not sure that is a bad thing here.

I think including function name should allow identifying error message
in 99,9% cases. If for some reason we want the "brcmfmac: " prefix, it
should only take a simple change to the bphy_err() macro.


> >   .../broadcom/brcm80211/brcmfmac/bcdc.c        | 26 +++---
> >   .../broadcom/brcm80211/brcmfmac/common.c      | 38 +++++----
> >   .../broadcom/brcm80211/brcmfmac/core.c        | 78 ++++++++++-------
> >   .../broadcom/brcm80211/brcmfmac/feature.c     |  6 +-
> >   .../broadcom/brcm80211/brcmfmac/fweh.c        | 22 +++--
> >   .../broadcom/brcm80211/brcmfmac/fwil.c        | 15 ++--
> >   .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 36 +++++---
> >   .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 65 ++++++++------
> >   .../broadcom/brcm80211/brcmfmac/p2p.c         | 85 +++++++++++-------=
-
> >   .../broadcom/brcm80211/brcmfmac/pno.c         | 22 +++--
> >   .../broadcom/brcm80211/brcmfmac/proto.c       |  7 +-
> >   11 files changed, 240 insertions(+), 160 deletions(-)
>
> [...]
>
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > index e772c0845638..2e0e2badfb80 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>
> [...]
>
> > @@ -141,7 +142,8 @@ void brcmf_configure_arp_nd_offload(struct brcmf_if=
 *ifp, bool enable)
> >
> >   static void _brcmf_set_multicast_list(struct work_struct *work)
> >   {
> > -     struct brcmf_if *ifp;
> > +     struct brcmf_if *ifp =3D container_of(work, struct brcmf_if, mult=
icast_work);
>
> checkpatch complains about the length here.

One little warning. I thought it may pass unnoticed ;) Let me fix that.
