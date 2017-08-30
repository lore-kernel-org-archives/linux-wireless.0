Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36529 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdH3Tcq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:32:46 -0400
Received: by mail-wm0-f52.google.com with SMTP id u126so15929883wmg.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:32:46 -0700 (PDT)
Subject: Re: [PATCH 07/34] brcmfmac: Remove brcmf_sdiod_request_data()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-8-ian@mnementh.co.uk> <59884E46.5090000@broadcom.com>
 <62cd90bd-718d-e7a7-d73e-e868b5499ed5@mnementh.co.uk>
 <1cad185b-a720-9c13-0c45-43240803162f@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fd3f46d5-82e8-be94-919f-a864be20495e@broadcom.com> (sfid-20170830_213251_204748_D58A16E1)
Date: Wed, 30 Aug 2017 21:32:44 +0200
MIME-Version: 1.0
In-Reply-To: <1cad185b-a720-9c13-0c45-43240803162f@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-08-17 22:02, Ian Molton wrote:
> On 07/08/17 18:51, Ian Molton wrote:
>> On 07/08/17 12:25, Arend van Spriel wrote:
>>>> Handling of -ENOMEDIUM is altered, but as that's pretty much broken
>>>> anyway
>>>> we can ignore that.
>>>
>>> Please explain why you think it is broken.
>>
>> Not got the code to hand right now, but from memory, theres a trapdoor
>> case where the state can wind up set to something that prevents it ever
>> being changed again. I'll dig it up when I get back from holiday (this
>> next few days).
> 
> Hi,
> 
> Here is the function I had in mind:
> 
> 
> void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
>                                enum brcmf_sdiod_state state)
> {
>          if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM ||
>              state == sdiodev->state)
>                  return;
> 
>          brcmf_dbg(TRACE, "%d -> %d\n", sdiodev->state, state);
>          switch (sdiodev->state) {
>          case BRCMF_SDIOD_DATA:
>                  /* any other state means bus interface is down */
>                  brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
>                  break;
>          case BRCMF_SDIOD_DOWN:
>                  /* transition from DOWN to DATA means bus interface is up */
>                  if (state == BRCMF_SDIOD_DATA)
>                          brcmf_bus_change_state(sdiodev->bus_if,
> BRCMF_BUS_UP);
>                  break;
>          default:
>                  break;
>          }
>          sdiodev->state = state;
> }
> 
> 
> If it's *ever*  called with state = BRCMF_SDIOD_NOMEDIUM it will
> eventually (last line) set sdiodev->state to the same value.
> 
> If its ever called again, the first if() statement will make it return
> before ever changing sdiodev->state again, no matter what value is
> passed for state.
> 
> This has to be a bug, surely?

I thought I already responded this email. So it is not a bug. It really 
was made like this intentional. It is the end state of this little FSM. 
The thing is that there was no way to recover. Maybe nowadays with the 
MMC stack being able to power sequence the device (provided it is 
properly configured in device tree) we may get lucky using 
mmc_hw_reset(). But now you need to consider how many times to call that 
before giving up and what driver components/states need to be reset as 
well. So I would prefer to keep the current behavior until a more 
graceful approach has been designed and implemented to replace it.

Regards,
Arend
