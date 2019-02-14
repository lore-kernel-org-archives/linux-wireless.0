Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874C3C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50FDF2229F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EU/yh2h7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbfBNMiJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:38:09 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37581 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfBNMiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:38:09 -0500
Received: by mail-ed1-f65.google.com with SMTP id m12so4884351edv.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 04:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=807NVNM32fus4kYDbrdb18Xe00GdxwcaFmifypo3V1U=;
        b=EU/yh2h7VETHe5JhozWSDyWAIrAwnaB0j40ZvaMnaM4zEeN2KjPdbXMX/AapOTEkOS
         es+TGlQ11bDQqQ2RXmdBl/NzrAP5Ww/cveykSCVpDXDiKuEfpH2rSc/mVP9o/p9uQdPS
         ZaSBFGjI26rrd7s8SY1/f1wWJyR1na0BpbD5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=807NVNM32fus4kYDbrdb18Xe00GdxwcaFmifypo3V1U=;
        b=aZ+1FYnMXMqIWELiXjGSlmW7pfJUPswzc2h0NcQvIIvMOPbWvdjla3Nbceqvg6zcCJ
         H+wjbH6JxQHKOWmw97liiI3fzHbcrfqkWLEQyz30qxKvdCitqA15bjRoUyjCU4n/yUlP
         H65ODiHyEX0MUoMyq+ekoxoWhlGfzoGYOGI3ZYcRLf6GX5bp1B/akQEpRnbiOcRwHNJB
         MfGHDOm5HOUncxpULaxQYg3JryFNLQzBEEKGLmOmwYXPXPXFKKq1+WLa0OMys1xBYgpr
         k+4ZJRWg0BZQ0YHfUduhSxSIaSbsjJaDOeZuIVgI2xahgSElceCGJ0P2j/h28/DQAypt
         X4OQ==
X-Gm-Message-State: AHQUAuZPeZoXRGlDtaNkVsxbN0V/t+PqtQOvWXpFf0j69f2cumh6LrPQ
        8Cz41WJCpzXk+WIx1+QVCm882w==
X-Google-Smtp-Source: AHgI3IaUa9RWd6P7oNRGlMZ4hDNJL6cvHKzxuDpSP6tRuC6kOBWtTVuGoUqecvYMgEMNRaJ7OI6oNQ==
X-Received: by 2002:a50:c946:: with SMTP id p6mr3071296edh.0.1550147886987;
        Thu, 14 Feb 2019 04:38:06 -0800 (PST)
Received: from [10.230.33.15] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id t12sm636109edj.61.2019.02.14.04.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 04:38:06 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190213112619.23899-1-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cc894af8-c61d-076a-d32d-41b566d73017@broadcom.com>
Date:   Thu, 14 Feb 2019 13:38:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190213112619.23899-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/13/2019 12:26 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This recently added macro provides more meaningful error messages thanks
> to identifying a specific wiphy. It's especially important on systems
> with few cards supported by the same (brcmfmac) driver.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> I obviously couldn't hit & test all error cases. To perform some basic
> testing I added:
> bphy_err(wiphy, "test\n");
> for every wiphy variable added by this patch & tested in on BCM4366.
> 
> I got a lot of messages like:
> [ 2842.424524] ieee80211 phy1: brcmf_netdev_start_xmit: test
> [ 2842.434921] ieee80211 phy1: brcmf_msgbuf_txflow: test
> [ 2842.440275] ieee80211 phy1: brcmf_msgbuf_process_msgtype: test
> [ 2842.446141] ieee80211 phy1: brcmf_get_ifp: test
> so it seems to work correctly.

I was thinking about fact that module name is no longer prefixed, but I 
am not sure that is a bad thing here.

> ---
>   .../broadcom/brcm80211/brcmfmac/bcdc.c        | 26 +++---
>   .../broadcom/brcm80211/brcmfmac/common.c      | 38 +++++----
>   .../broadcom/brcm80211/brcmfmac/core.c        | 78 ++++++++++-------
>   .../broadcom/brcm80211/brcmfmac/feature.c     |  6 +-
>   .../broadcom/brcm80211/brcmfmac/fweh.c        | 22 +++--
>   .../broadcom/brcm80211/brcmfmac/fwil.c        | 15 ++--
>   .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 36 +++++---
>   .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 65 ++++++++------
>   .../broadcom/brcm80211/brcmfmac/p2p.c         | 85 +++++++++++--------
>   .../broadcom/brcm80211/brcmfmac/pno.c         | 22 +++--
>   .../broadcom/brcm80211/brcmfmac/proto.c       |  7 +-
>   11 files changed, 240 insertions(+), 160 deletions(-)

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index e772c0845638..2e0e2badfb80 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c

[...]

> @@ -141,7 +142,8 @@ void brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
>   
>   static void _brcmf_set_multicast_list(struct work_struct *work)
>   {
> -	struct brcmf_if *ifp;
> +	struct brcmf_if *ifp = container_of(work, struct brcmf_if, multicast_work);

checkpatch complains about the length here.

> +	struct wiphy *wiphy = ifp->drvr->wiphy;
>   	struct net_device *ndev;
>   	struct netdev_hw_addr *ha;
>   	u32 cmd_value, cnt;
> @@ -150,8 +152,6 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
>   	u32 buflen;
>   	s32 err;
>   
> -	ifp = container_of(work, struct brcmf_if, multicast_work);

So maybe keep this and initialize wiphy here as well.

> -
>   	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
>   
>   	ndev = ifp->ndev;
