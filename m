Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46932 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbdG1Rth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 13:49:37 -0400
Date: Fri, 28 Jul 2017 18:49:30 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: AP mode with Broadcom 4330
Message-ID: <20170728174930.GA3313@n2100.armlinux.org.uk> (sfid-20170728_194941_516850_11395071)
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170728141503.GU31807@n2100.armlinux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 28, 2017 at 03:15:03PM +0100, Russell King - ARM Linux wrote:
> Hi,
> 
> I've been struggling yesterday and today trying to configure AP mode
> with the Broadcom 4330 on a SolidRun Hummingboard2, using the 2013
> firmware:
> 
> Firmware version = wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464
> 
> People tell me that this works with SR's 3.14 kernel, but I'd prefer
> to use mainline (4.13-rc2).  Whenever I try to configure AP mode via
> Network Manager or hostapd (on Debian Jessie), the SSID I ask for and
> the MAC address does not appear on other wifi clients.  wlan0's
> MAC is 6c:ad:f8:1d:4c:d9.

I've just found the cause of this.  What it comes down to is this commit:

commit a44aa4001a86d46f936ca449e5d6c268446bfae2
Author: Hante Meuleman <meuleman@broadcom.com>
Date:   Wed Dec 3 21:05:33 2014 +0100

    brcmfmac: add multiple BSS support.

    This patch adds support for multiple BSS interfaces (AP). In
    total three AP configurations can be created. In order to use
    multiple BSS firmware needs to support it.

    Reviewed-by: Arend Van Spriel <arend@broadcom.com>
    Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
    Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
    Signed-off-by: Arend van Spriel <arend@broadcom.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

which adds this hunk to brcmf_cfg80211_start_ap()

        if (dev_role == NL80211_IFTYPE_AP) {
+               if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss))
+                       brcmf_fil_iovar_int_set(ifp, "mbss", 1);
+

What this is saying is: "if the device supports MBSS, and MBSS was not
requested (from ifp->vif->mbss), then *ENABLE* MBSS."  That's clearly
nonsense.

Replacing that "(!mbss)" with "mbss" results in AP mode working on the
4330.  However, I suspect:

		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
			brcmf_fil_iovar_int_set(ifp, "mbss", mbss);

actually makes much more sense.

Given that this is direct firmware interaction, I can't say which is
correct - all I can say is that mainline kernels are currently broken.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
