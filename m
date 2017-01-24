Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9.mo69.mail-out.ovh.net ([46.105.56.78]:52046 "EHLO
        9.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdAYAf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 19:35:29 -0500
Received: from player798.ha.ovh.net (b7.ovh.net [213.186.33.57])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 7B219188B1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 23:08:29 +0100 (CET)
Subject: Re: [PATCH 5/6] brcmfmac: modify all brcmf_err calls adding struct
 brcmf_pub
To: kbuild test robot <lkp@intel.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <201701250538.rPc01fGk%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <cf67969f-e4bc-2aee-f0a5-f6f16234f55e@milecki.pl> (sfid-20170125_013533_803424_6A764DFE)
Date: Tue, 24 Jan 2017 23:08:17 +0100
MIME-Version: 1.0
In-Reply-To: <201701250538.rPc01fGk%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2017 11:02 PM, kbuild test robot wrote:
> Hi Rafał,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on next-20170124]
> [cannot apply to v4.10-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-switch-to-C-function-__brcmf_err-for-printing-errors/20170125-033714
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c:25:0:
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c: In function 'brcmf_cfg80211_vndr_cmds_dcmd_handler':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:53:2: warning: 'pub' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      __brcmf_err(pub, __func__, fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c:36:20: note: 'pub' was declared here
>      struct brcmf_pub *pub;
>                        ^~~
> --
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function 'brcmf_sdio_verifymemory':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3212:26: error: 'bus' undeclared (first use in this function)
>      struct brcmf_pub *pub = bus->sdiodev->bus_if->drvr;
>                              ^~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3212:26: note: each undeclared identifier is reported only once for each function it appears in

Oh I really need to do better.

I'll wait a bit with V2 to see if there will be any comments.
