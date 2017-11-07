Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35090 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdKGCST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 21:18:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Simon Shields <simon@lineageos.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
References: <20171104132421.GA1541@archbox.home>
        <1925563700.5172.1509993297900@email.1und1.de>
Date: Tue, 07 Nov 2017 04:18:14 +0200
In-Reply-To: <1925563700.5172.1509993297900@email.1und1.de> (Stefan Wahren's
        message of "Mon, 6 Nov 2017 19:34:57 +0100 (CET)")
Message-ID: <871slarfvd.fsf@purkki.adurom.net> (sfid-20171107_031828_966455_2DDA1B53)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Wahren <stefan.wahren@i2se.com> writes:

>> Simon Shields <simon@lineageos.org> hat am 4. November 2017 um 14:24 geschrieben:
>> 
>> 
>> Some boards use an external 32khz clock for low-power
>> mode timing. Make sure the clock is powered on while the chipset
>> is active.
>> 
>> Signed-off-by: Simon Shields <simon@lineageos.org>
>> ---
>>  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt     |  2 ++
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h      |  2 ++
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c          |  5 +++++
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c        | 10 ++++++++++
>>  4 files changed, 19 insertions(+)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> index b2bd4704f859..37add5e29272 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> @@ -17,6 +17,8 @@ Optional properties:
>>  	When not specified the device will use in-band SDIO interrupts.
>>   - interrupt-names : name of the out-of-band interrupt, which must be set
>>  	to "host-wake".
>> + - clocks : external 32khz clock
>> + - clock-names : name of the external 32khz clock, must be "32khz"
>
> sorry for the nitpicking, but according to the datasheet [1] it's
> 32768 Hz. Apart from that i suggest to use a functional name for the
> clock like "low_power" or something else, which is more flexible and
> future-proof.
>
> Btw this binding needs to be a separate patch, which should go to the
> devicetree guys.

Previously I have applied binding documentation changes which the DT
maintainers have acked, that's why I specifically asked to Cc device
tree list. Has something changed?

-- 
Kalle Valo
