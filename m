Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38480 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdHOJmP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 05:42:15 -0400
Received: by mail-wm0-f50.google.com with SMTP id f15so5899975wmg.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Aug 2017 02:42:14 -0700 (PDT)
Subject: Re: AP mode with Broadcom 4330
To: Russell King - ARM Linux <linux@armlinux.org.uk>, rosenp@gmail.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20170728141503.GU31807@n2100.armlinux.org.uk>
 <20170728174930.GA3313@n2100.armlinux.org.uk>
 <2c5d4ef0-9b87-0084-c032-c5614275dd56@broadcom.com>
 <20170814233028.GK20805@n2100.armlinux.org.uk>
 <1502778303.2319.2.camel@gmail.com>
 <20170815082219.GL20805@n2100.armlinux.org.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f0e75add-c4b9-954b-b37d-2cef447d47dc@broadcom.com> (sfid-20170815_114218_780623_378BC09F)
Date: Tue, 15 Aug 2017 11:42:12 +0200
MIME-Version: 1.0
In-Reply-To: <20170815082219.GL20805@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-08-17 10:22, Russell King - ARM Linux wrote:
> On Mon, Aug 14, 2017 at 11:25:03PM -0700, rosenp@gmail.com wrote:
>> If using rtlwifi, you could try using rtl8xxxu and see if you get
>> similar results. ¯\_(ツ)_/¯
> 
> I'm using rtl8xxxu.  I don't think rtlwifi supports the 8192eu - it
> certainly does not list the device id:
> Bus 001 Device 002: ID 0bda:818b Realtek Semiconductor Corp.
> 
> As an extra data point, trying to associate to the 4330 with an Intel
> client gives:
> 
> [8821752.691490] wlan0: authenticate with 6c:ad:f8:1d:4c:d9
> [8821752.693448] wlan0: send auth to 6c:ad:f8:1d:4c:d9 (try 1/3)
> [8821752.696230] wlan0: authenticated
> [8821752.697493] wlan0: associate with 6c:ad:f8:1d:4c:d9 (try 1/3)
> [8821752.700816] wlan0: RX AssocResp from 6c:ad:f8:1d:4c:d9 (capab=0x411 status=0 aid=1)
> [8821752.704407] wlan0: associated
> [8821755.814844] wlan0: deauthenticated from 6c:ad:f8:1d:4c:d9 (Reason: 2=PREV_AUTH_NOT_VALID)
> 
> which gets slightly further but ultimately still fails.

Hi Russell,

On vacation this week, but it is raining over here so have some moments 
to kill. Here a couple of things to try:

1) try without encryption.
2) does hostapd log show anything interesting.
3) can you use the Intel client to make a sniff.

I can check what could trigger the firmware after 3 sec. to deauth. Just 
not sure if I will get to that this week. Could be failing EAPOL handshake.

Regards,
Arend
