Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36045 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFRLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 13:11:09 -0400
Received: by mail-wr0-f175.google.com with SMTP id c11so11344981wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 10:11:09 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "security@kernel.org" <security@kernel.org>
References: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com> (sfid-20170706_191113_489030_652C6484)
Date: Thu, 6 Jul 2017 19:11:06 +0200
MIME-Version: 1.0
In-Reply-To: <88f27bfd328f4ccdb0d6b7ff7e710819@MWHPR06MB3230.namprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-07-17 10:41, Dan Carpenter wrote:
> The lower level networking code ensures that "len" is between 25 and
> NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) from
> "len" so thats's max of 2280.  But the action_frame->data[] buffer is
> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
> overflow.
> 
>         memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
>                le16_to_cpu(action_frame->len));

Thanks, Dan

Looks fine to me so ...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reported-by: "freenerguo(郭大兴)" <freenerguo@tencent.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index dcde596c9eb9..bdae7b44a5ec 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4934,6 +4934,11 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>                 cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
>                                         GFP_KERNEL);
>         } else if (ieee80211_is_action(mgmt->frame_control)) {
> +               if (len > sizeof(action_frame->data) + DOT11_MGMT_HDR_LEN) {
> +                       err = -EINVAL;
> +                       goto exit;
> +               }
> +
>                 af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
>                 if (af_params == NULL) {
>                         brcmf_err("unable to allocate frame\n");
> 
> 
> You're receiving this message because you're a member of the brcm80211-dev-list group.
> 
> This message and any attachments may contain confidential information from Cypress or its subsidiaries. If it has been received in error, please advise the sender and immediately delete this message.
> 
