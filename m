Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C000EECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 19:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 875632081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 19:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g2dVvZ1X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 875632081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeKIE4U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 23:56:20 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36040 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbeKIE4U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 23:56:20 -0500
Received: by mail-yw1-f67.google.com with SMTP id h21-v6so8452144ywa.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 11:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d1mQq6fsydBsnVXfxacDYfY1HmHIATQTUe/HSV8Oi7E=;
        b=g2dVvZ1XqOwXhNxKBtw5Sfdvph+5SzJne6Vl1EvE7qNzpF32YFWjDQEUh3C0iaCco7
         T+OJv0AQgnp64kdgst44cr6+e7xx+lVFDDZm0fb+8Oafb+f6s+t4YSMH0YXG8xY1pSDX
         hzpSDfJ3SE2orgutfaOg2L3dd7VkvlD9s7mCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1mQq6fsydBsnVXfxacDYfY1HmHIATQTUe/HSV8Oi7E=;
        b=o9OFCM+ONDynpNtJh97ogFWz4LaTtQt4K+p8u4bm0CV8OAp6cjh+gQ7vVOCZQ+QIL9
         ElQGh8RrimBVt5RlhPzxYH/RML5B2lymov808J9XEhouWBghtVurFu58pf0db9b9nKNv
         ow5rBOdI1FrN4ek1kkmI5LmpNT4LHPJV3LNtDbHRYT0zir/7b3gQAe5rshKAC55kQTml
         6SXAHJKPLRSGc73IrVIwmd5jzuU914+7nOzBQJDMtLRX7R9fVySkRDAUdhV+EDm2+2UB
         PooHJKcte9XTh5yGlzfVh1tOAqOg8VulV7iwK4cWVmB3LJzfUKgHOSneAdNqNfox+o/z
         4noQ==
X-Gm-Message-State: AGRZ1gIVHnMJTEMbSuHTFkTEKrMeTyFugDSvDlHpk7dKjA0a3HqlEj7P
        3iRhpcaZipP91DdCB23VmBY5w+TYPlqtCGOO1gNuew==
X-Google-Smtp-Source: AJdET5efJErY4pJzSEwSFrgQf3MgolVe0d8iWAD1MaLfv06iQfIDs1uGmDJNHaYtWFvikt4kBi2Y2VmIUIhO+5qmuxI=
X-Received: by 2002:a81:2a83:: with SMTP id q125-v6mr5702921ywq.480.1541704766663;
 Thu, 08 Nov 2018 11:19:26 -0800 (PST)
MIME-Version: 1.0
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com> <1541648845-194984-3-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541648845-194984-3-git-send-email-chi-hsien.lin@cypress.com>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Thu, 8 Nov 2018 11:19:15 -0800
Message-ID: <CA+8PC_fZ8u+ii_6vdvuLSqszzFcNzhd6dz-AHGR6tByfAgPgcg@mail.gmail.com>
Subject: Re: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from "brcmf_netdev_stop"
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>, brcm80211-dev-list@broadcom.com,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 7, 2018 at 7:48 PM Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:
>
> From: Wright Feng <wright.feng@cypress.com>
>
> The firmware does not respond ARP request and causes ping failure with
> following steps:
>
> 1. Bring up interface
>    ifconfig wlan0 up or start wpa_supplicant
> 2. Set the IP address
>    ifconfig wlan0 192.168.100.10
> 3. Bring down interface or
>    ifconfig wlan0 down or kill wpa_supplicant
> 4. Bring up interface again and set the same IP address
> 5. Connect to AP(192.168.100.1) and ping to AP will be failed.
>
> FMAC clears arp_hostip when bringing down the interface, but not set it
> back if setting the same IP address. We are able to see the IP address
> in interface info(inconfig wlan0) but the ping still cannot work because
> the firmware ARP offload does not respond the ARP request.
> Because of that, we remove "arp_hostip_clear" from function
> "brcmf_netdev_stop"

Shouldn't brcmf_inetaddr_changed get called when the interface up again?

Thanks,
- Franky

>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index b1f702faff4f..e1666cf3801c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -533,8 +533,6 @@ static int brcmf_netdev_stop(struct net_device *ndev)
>
>         brcmf_cfg80211_down(ndev);
>
> -       brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear", NULL, 0);
> -
>         brcmf_net_setcarrier(ifp, false);
>
>         return 0;
> --
> 2.1.0
>
