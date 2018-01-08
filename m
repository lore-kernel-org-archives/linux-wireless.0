Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34149 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755900AbeAHJby (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 04:31:54 -0500
Received: by mail-wm0-f48.google.com with SMTP id y82so14963745wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 01:31:54 -0800 (PST)
Subject: Re: brcmfmac: set p2p_disc error on BCM4350
To: William Dauchy <wdauchy@gmail.com>, linux-wireless@vger.kernel.org
References: <CAJ75kXYLOV8aVZpftBFRbMv=KCaxCoQpJFaL0m0QDjVOytq3Vg@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A533A88.1000804@broadcom.com> (sfid-20180108_103159_360301_9FC2C28F)
Date: Mon, 8 Jan 2018 10:31:52 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ75kXYLOV8aVZpftBFRbMv=KCaxCoQpJFaL0m0QDjVOytq3Vg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/8/2018 12:49 AM, William Dauchy wrote:
> Hello,
>
> Using the last v4.14.x I am getting this error at each boot, on my
> BCM4350 802.11ac Wireless Network Adapter:
>
> brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp58s0 type 10
> failed: err=-16
>
> The firmware used is:
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015
> 06:16:26 version 7.35.180.119 (r594535) FWID 01-e791c176
>
> I was wondering if this error could be fixed?

This has been reported before, but not been able to look into it. Diving 
into firmware it seems that error can only occur if the mac address for 
the p2pdev interface is already used. So if possible can you rebuild the 
driver with the patch below applied and provide dmesg output and output 
of 'ifconfig -a'.

Regards,
Arend
---8<----------------------------------------------------------------

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c 
b/drivers/n
index 2ee5413..f96ad37 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2065,6 +2065,7 @@ static struct wireless_dev 
*brcmf_p2p_create_p2pdev(struc
         int err;
         u32 bsscfgidx;

+       brcmf_err("enter: mac=%pM\n", addr);
         if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
                 return ERR_PTR(-ENOSPC);
