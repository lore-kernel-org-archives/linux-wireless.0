Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:39147 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbeCOIge (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 04:36:34 -0400
Received: by mail-qt0-f196.google.com with SMTP id a26so6359323qtj.6
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 01:36:33 -0700 (PDT)
Subject: Re: [PATCH V2] brcmfmac: drop Inter-Access Point Protocol packets by
 default
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180315072909.1512-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        bridge@lists.linux-foundation.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AAA308D.4090100@broadcom.com> (sfid-20180315_093640_758619_7D079457)
Date: Thu, 15 Mar 2018 09:36:29 +0100
MIME-Version: 1.0
In-Reply-To: <20180315072909.1512-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/15/2018 8:29 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
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
>     disassociation perfromed by a firmware (possible local DoS attack).
>
> It appears there are some Broadcom's clients/users who care about this
> feature despite the drawbacks. They can switch it on using a new module
> param.
>
> This change results in only two more comparisons (check for module param
> and check for Ethernet packet length) for 99.9% of packets. Its overhead
> should be very minimal.

Hi Rafał,

Thanks for this patch.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  5 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  1 +
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 57 ++++++++++++++++++++++
>   3 files changed, 63 insertions(+)
