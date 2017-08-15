Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35914 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbdHOJ6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 05:58:49 -0400
Date: Tue, 15 Aug 2017 10:58:42 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: rosenp@gmail.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: AP mode with Broadcom 4330
Message-ID: <20170815095841.GM20805@n2100.armlinux.org.uk> (sfid-20170815_115854_073705_510D7FEA)
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
 <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
 <20170814233028.GK20805@n2100.armlinux.org.uk>
 <1502778303.2319.2.camel@gmail.com>
 <20170815082219.GL20805@n2100.armlinux.org.uk>
 <f0e75add-c4b9-954b-b37d-2cef447d47dc@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f0e75add-c4b9-954b-b37d-2cef447d47dc@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 15, 2017 at 11:42:12AM +0200, Arend van Spriel wrote:
> On 15-08-17 10:22, Russell King - ARM Linux wrote:
> >On Mon, Aug 14, 2017 at 11:25:03PM -0700, rosenp@gmail.com wrote:
> >>If using rtlwifi, you could try using rtl8xxxu and see if you get
> >>similar results. ¯\_(ツ)_/¯
> >
> >I'm using rtl8xxxu.  I don't think rtlwifi supports the 8192eu - it
> >certainly does not list the device id:
> >Bus 001 Device 002: ID 0bda:818b Realtek Semiconductor Corp.
> >
> >As an extra data point, trying to associate to the 4330 with an Intel
> >client gives:
> >
> >[8821752.691490] wlan0: authenticate with 6c:ad:f8:1d:4c:d9
> >[8821752.693448] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 1/3)
> >[8821752.696230] wlan0: authenticated
> >[8821752.697493] wlan0: associate with 6c:ad:f8:1d:4c:d9 (try 1/3)
> >[8821752.700816] wlan0: RX AssocResp from 6c:ad:f8:1d:4c:d9 (capab=0x411 status=0 aid=1)
> >[8821752.704407] wlan0: associated
> >[8821755.814844] wlan0: deauthenticated from 6c:ad:f8:1d:4c:d9 (Reason: 2=PREV_AUTH_NOT_VALID)
> >
> >which gets slightly further but ultimately still fails.
> 
> Hi Russell,
> 
> On vacation this week, but it is raining over here so have some moments to
> kill. Here a couple of things to try:
> 
> 1) try without encryption.
> 2) does hostapd log show anything interesting.
> 3) can you use the Intel client to make a sniff.
> 
> I can check what could trigger the firmware after 3 sec. to deauth. Just not
> sure if I will get to that this week. Could be failing EAPOL handshake.

Sorry for the confusion - the problem with iwlwifi turned out to be a
lack of /dev/random entropy, causing hostapd to forcefully deauth the
client - that was hidden when running hostapd from systemd and is only
visible if you run hostapd manually.

(I have other problems there - manually starting hostapd works every
time, but when started using systemctl start hostapd, systemctl status
hostapd always reports that it's started but exited and it definitely
isn't running... I'm just hitting one problem after another here with
wireless, I'm quite sure this tech hates me!)

However, I'm still having problems with the Realtek not getting further
than _allegedly_ sending the auth frames - I'm not convinced that the
driver is actually sending anything yet.  I can't see anything suggesting
it is from iwlwifi in monitor mode, and enabling all the debug for the
rtl8xxxu driver doesn't give the slightest hint that this driver is
doing anything remotely useful to transmit these frames.  For instance:

[41742.979480] usb 1-1: rtl8xxxu_read32(0440)  = 0x0000000f, len 4
[41742.985826] usb 1-1: rtl8xxxu_write32(0440) = 0x0000000f
[41742.994470] usb 1-1: rtl8xxxu_write8(0480) = 0x04
[41742.999430] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 1/3)
[41743.206163] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 2/3)
[41743.414148] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 3/3)
[41743.622138] wlan0: authentication with 6c:ad:f8:1d:4c:d9 timed out
[41743.629100] usb 1-1: rtl8xxxu_write8(0618) = 0x00
[41743.636490] usb 1-1: rtl8xxxu_write8(0619) = 0x00
[41743.641573] usb 1-1: rtl8xxxu_write8(061a) = 0x00

How can it send auth packets without writing to any registers (this is
with all debug options set in /sys/module/rtl8xxxu/parameters/debug !)

So, I don't think the 4330 has a problem, I think it's all down to
the Realtek driver being buggy.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
