Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37823 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdHOGZG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 02:25:06 -0400
Received: by mail-pg0-f53.google.com with SMTP id y129so537436pgy.4
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 23:25:06 -0700 (PDT)
Message-ID: <1502778303.2319.2.camel@gmail.com> (sfid-20170815_082511_518298_7DE1149D)
Subject: Re: AP mode with Broadcom 4330
From: rosenp@gmail.com
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Date: Mon, 14 Aug 2017 23:25:03 -0700
In-Reply-To: <20170814233028.GK20805@n2100.armlinux.org.uk>
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
         <20170728174930.GA3313@n2100.armlinux.org.uk>
         <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
         <20170814233028.GK20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If using rtlwifi, you could try using rtl8xxxu and see if you get
similar results. ¯\_(ツ)_/¯

On Tue, 2017-08-15 at 00:30 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 28, 2017 at 09:50:21PM +0200, Arend van Spriel wrote:
> > On 28-07-17 19:49, Russell King - ARM Linux wrote:
> > > Replacing that "(!mbss)" with "mbss" results in AP mode working
> > > on the
> > > 4330.  However, I suspect:
> > > 
> > > 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
> > > 			brcmf_fil_iovar_int_set(ifp, "mbss", mbss);
> > > 
> > > actually makes much more sense.
> > > 
> > > Given that this is direct firmware interaction, I can't say which
> > > is
> > > correct - all I can say is that mainline kernels are currently
> > > broken.
> > 
> > Indeed. I have to come up with a proper fix for both scenarios.
> > Thanks
> > for the report.
> 
> I'm now on 4.13-rc4, and running with my patch.  I've configured AP
> mode:
> 
> Interface wlan0
> 	ifindex 3
> 	wdev 0x1
> 	addr 6c:ad:f8:1d:4c:d9
> 	ssid Time
> 	type AP
> 	wiphy 0
> 	channel 5 (2432 MHz), width: 20 MHz, center1: 2432 MHz
> 
> using NetworkManager with a WPA2 key.  However, a Realtek RTL8192EU
> client is trying to connect to it, but is unable:
> 
> [ 1750.497436] wlan0: authenticate with 6c:ad:f8:1d:4c:d9
> [ 1750.530929] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 1/3)
> [ 1750.738795] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 2/3)
> [ 1750.946780] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 3/3)
> [ 1751.154764] wlan0: authentication with 6c:ad:f8:1d:4c:d9 timed out
> 
> The antennas are definitely within range (finger to thumb distance)
> and the Realtek can definitely see the BCM4330 in AP mode.  I don't
> see the interrupts for the SDIO interface increment while the client
> tries to connect.
> 
> The WPA2 password is definitely the same on both ends.
> 
> Any ideas how to debug this?
> 
> Thanks.
> 
