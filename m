Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCPNB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 09:01:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] brcmfmac: drop Inter-Access Point Protocol packets by default
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180315072909.1512-1-zajec5@gmail.com>
References: <20180315072909.1512-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        bridge@lists.linux-foundation.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180316130125.C69D860C4F@smtp.codeaurora.org> (sfid-20180316_140135_627036_D4979556)
Date: Fri, 16 Mar 2018 13:01:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

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
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

125905517028 brcmfmac: drop Inter-Access Point Protocol packets by default

-- 
https://patchwork.kernel.org/patch/10283971/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
