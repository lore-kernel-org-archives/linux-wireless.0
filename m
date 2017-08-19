Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:39900 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdHSUCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:02:17 -0400
Subject: Re: [PATCH 07/34] brcmfmac: Remove brcmf_sdiod_request_data()
From: Ian Molton <ian@mnementh.co.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-8-ian@mnementh.co.uk> <59884E46.5090000@broadcom.com>
 <62cd90bd-718d-e7a7-d73e-e868b5499ed5@mnementh.co.uk>
Message-ID: <1cad185b-a720-9c13-0c45-43240803162f@mnementh.co.uk> (sfid-20170819_220220_974550_471528B8)
Date: Sat, 19 Aug 2017 21:02:14 +0100
MIME-Version: 1.0
In-Reply-To: <62cd90bd-718d-e7a7-d73e-e868b5499ed5@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 18:51, Ian Molton wrote:
> On 07/08/17 12:25, Arend van Spriel wrote:
>>> Handling of -ENOMEDIUM is altered, but as that's pretty much broken
>>> anyway
>>> we can ignore that.
>>
>> Please explain why you think it is broken.
> 
> Not got the code to hand right now, but from memory, theres a trapdoor
> case where the state can wind up set to something that prevents it ever
> being changed again. I'll dig it up when I get back from holiday (this
> next few days).

Hi,

Here is the function I had in mind:


void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
                              enum brcmf_sdiod_state state)
{
        if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM ||
            state == sdiodev->state)
                return;

        brcmf_dbg(TRACE, "%d -> %d\n", sdiodev->state, state);
        switch (sdiodev->state) {
        case BRCMF_SDIOD_DATA:
                /* any other state means bus interface is down */
                brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
                break;
        case BRCMF_SDIOD_DOWN:
                /* transition from DOWN to DATA means bus interface is up */
                if (state == BRCMF_SDIOD_DATA)
                        brcmf_bus_change_state(sdiodev->bus_if,
BRCMF_BUS_UP);
                break;
        default:
                break;
        }
        sdiodev->state = state;
}


If it's *ever*  called with state = BRCMF_SDIOD_NOMEDIUM it will
eventually (last line) set sdiodev->state to the same value.

If its ever called again, the first if() statement will make it return
before ever changing sdiodev->state again, no matter what value is
passed for state.

This has to be a bug, surely?

-Ian
