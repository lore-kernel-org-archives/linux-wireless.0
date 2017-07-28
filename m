Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37611 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbdG1TuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 15:50:24 -0400
Received: by mail-wm0-f44.google.com with SMTP id t201so4545506wmt.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jul 2017 12:50:23 -0700 (PDT)
Subject: Re: AP mode with Broadcom 4330
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com> (sfid-20170728_215030_031962_4BD41F29)
Date: Fri, 28 Jul 2017 21:50:21 +0200
MIME-Version: 1.0
In-Reply-To: <20170728174930.GA3313@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-07-17 19:49, Russell King - ARM Linux wrote:
> On Fri, Jul 28, 2017 at 03:15:03PM +0100, Russell King - ARM Linux wrote:
>> Hi,
>>
>> I've been struggling yesterday and today trying to configure AP mode
>> with the Broadcom 4330 on a SolidRun Hummingboard2, using the 2013
>> firmware:
>>
>> Firmware version = wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464
>>
>> People tell me that this works with SR's 3.14 kernel, but I'd prefer
>> to use mainline (4.13-rc2).  Whenever I try to configure AP mode via
>> Network Manager or hostapd (on Debian Jessie), the SSID I ask for and
>> the MAC address does not appear on other wifi clients.  wlan0's
>> MAC is 6c:ad:f8:1d:4c:d9.
> 
> I've just found the cause of this.  What it comes down to is this commit:

Hi Russell,

I noticed in your log that mbss was set to 1 so I was going to look at
that, but you clearly beat me to it ;-)

> commit a44aa4001a86d46f936ca449e5d6c268446bfae2
> Author: Hante Meuleman <meuleman@broadcom.com>
> Date:   Wed Dec 3 21:05:33 2014 +0100
> 
>     brcmfmac: add multiple BSS support.
> 
>     This patch adds support for multiple BSS interfaces (AP). In
>     total three AP configurations can be created. In order to use
>     multiple BSS firmware needs to support it.
> 
>     Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>     Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>     Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>     Signed-off-by: Arend van Spriel <arend@broadcom.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> which adds this hunk to brcmf_cfg80211_start_ap()
> 
>         if (dev_role == NL80211_IFTYPE_AP) {
> +               if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss))
> +                       brcmf_fil_iovar_int_set(ifp, "mbss", 1);
> +
> 
> What this is saying is: "if the device supports MBSS, and MBSS was not
> requested (from ifp->vif->mbss), then *ENABLE* MBSS."  That's clearly
> nonsense.

I was going to agree with you, but having second thoughts. There are
actually two use-cases that need to be handled properly. The regular AP
case and the MBSS case. In case of MBSS the initial AP interface will
have mbss set to false and subsequent AP interfaces will have mbss set
to true, but in firmware this has to be configured inverted. That is
what the code above is doing. However, this indeed breaks the regular AP
case for firmwares that abuse that setting for testing purposes (no idea
why that is in a released firmware).

> Replacing that "(!mbss)" with "mbss" results in AP mode working on the
> 4330.  However, I suspect:
> 
> 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
> 			brcmf_fil_iovar_int_set(ifp, "mbss", mbss);
> 
> actually makes much more sense.
> 
> Given that this is direct firmware interaction, I can't say which is
> correct - all I can say is that mainline kernels are currently broken.

Indeed. I have to come up with a proper fix for both scenarios. Thanks
for the report.

Regards,
Arend
