Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46803 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeCOHei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <20180315072909.1512-1-zajec5@gmail.com>
References: <20180315072909.1512-1-zajec5@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 15 Mar 2018 08:34:36 +0100
Message-ID: <CACna6ryQjhzXTbB0SBC_e_sJibhYyDjctOowhiVv_FMF6jEh3A@mail.gmail.com> (sfid-20180315_083502_317060_5524181E)
Subject: Re: [PATCH V2] brcmfmac: drop Inter-Access Point Protocol packets by default
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        bridge@lists.linux-foundation.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 March 2018 at 08:29, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote=
:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Testing brcmfmac with more recent firmwares resulted in AP interfaces
> not working in some specific setups. Debugging resulted in discovering
> support for IAPP in Broadcom's firmwares.
>
> Older firmwares were only generating 802.11f frames. Newer ones like:
> 1) 10.10 (TOB) (r663589)
> 2) 10.10.122.20 (r683106)
> for 4366b1 and 4366c0 respectively seem to also /respect/ 802.11f frames
> in the Tx path by performing a STA disassociation.
>
> This obsoleted standard and its implementation is something that:
> 1) Most people don't need / want to use
> 2) Can allow local DoS attacks
> 3) Breaks AP interfaces in some specific bridge setups
>
> To solve issues it can cause this commit modifies brcmfmac to drop IAPP
> packets. If affects:
> 1) Rx path: driver won't be sending these unwanted packets up.
> 2) Tx path: driver will reject packets that would trigger STA
>    disassociation perfromed by a firmware (possible local DoS attack).
>
> It appears there are some Broadcom's clients/users who care about this
> feature despite the drawbacks. They can switch it on using a new module
> param.
>
> This change results in only two more comparisons (check for module param
> and check for Ethernet packet length) for 99.9% of packets. Its overhead
> should be very minimal.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---

I forgot to include the changelog, sorry.

V2: Use module param to don't /abuse/ Kconfig
    Slightly optimize brcmf_skb_is_iapp
    Move some description from Kconfig to the code
    Update commit description: specify affected fws & mention impact
