Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35289 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGLTf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 07:19:35 -0400
Received: by mail-wr0-f172.google.com with SMTP id k67so42305554wrc.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 04:19:34 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?ZnJlZW5lcmd1byjpg63lpKflhbQp?= <freenerguo@tencent.com>,
        Franky Lin <franky.lin@broadcom.com>,
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
 <d2c78377-5608-b6c3-07d8-17dfc56a5c7e@broadcom.com>
 <CA+55aFxGacqVMDN0pETkd9Ho554wR8ACvTZhxK6p6M6CtUc_DA@mail.gmail.com>
 <20170707084640.cv3igibbhhmgsmta@mwanda>
 <a2496a2e-9258-7cc9-3c04-87886f0029cd@broadcom.com>
 <20170707101939.3mgdgc4pvjg6dyyx@mwanda>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <36f255e3-60e6-3ecc-8a47-90ec7df97ec6@broadcom.com> (sfid-20170707_131938_915865_51A94B9C)
Date: Fri, 7 Jul 2017 13:19:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170707101939.3mgdgc4pvjg6dyyx@mwanda>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-17 12:19, Dan Carpenter wrote:
> Speaking of underflows:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>   4913          if (ieee80211_is_probe_resp(mgmt->frame_control)) {
>   4914                  /* Right now the only reason to get a probe response */
>   4915                  /* is for p2p listen response or for p2p GO from     */
>   4916                  /* wpa_supplicant. Unfortunately the probe is send   */
>   4917                  /* on primary ndev, while dongle wants it on the p2p */
>   4918                  /* vif. Since this is only reason for a probe        */
>   4919                  /* response to be sent, the vif is taken from cfg.   */
>   4920                  /* If ever desired to send proberesp for non p2p     */
>   4921                  /* response then data should be checked for          */
>   4922                  /* "DIRECT-". Note in future supplicant will take    */
>   4923                  /* dedicated p2p wdev to do this and then this 'hack'*/
>   4924                  /* is not needed anymore.                            */
>   4925                  ie_offset =  DOT11_MGMT_HDR_LEN +
>   4926                               DOT11_BCN_PRB_FIXED_LEN;
>   4927                  ie_len = len - ie_offset;
>                                  ^^^^^^^^^^^^^^^
> This can underflow.  It's harmless, but it's annoying for me as a static
> checker person because this is the line where I'd like to print a
> warning but everyone will complain it's a "false positive".

Feel free to provide such a patch.

Regards,
Arend
