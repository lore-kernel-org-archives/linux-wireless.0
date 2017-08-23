Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:41188 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdHWVxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 17:53:50 -0400
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
 <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
 <CAGRGNgXWg6Gj4ND+BrfziX9Je5=b8Ovv=6fafYmg1CiSh6m9Mw@mail.gmail.com>
 <2ef60e61-1a55-21c9-744e-39bb5dadfa66@mnementh.co.uk>
 <CAGRGNgW4a5Ld0=HZ4AfBMzKoD2PvCJR=wfuAz3pxXupfbBw7YA@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <3b32ed07-71ee-4267-4ef8-4a09e1164c79@mnementh.co.uk> (sfid-20170823_235353_875769_8558D8AD)
Date: Wed, 23 Aug 2017 22:53:45 +0100
MIME-Version: 1.0
In-Reply-To: <CAGRGNgW4a5Ld0=HZ4AfBMzKoD2PvCJR=wfuAz3pxXupfbBw7YA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/08/17 13:36, Julian Calaby wrote:
> Hi Ian,
> 
> On Wed, Aug 23, 2017 at 10:27 PM, Ian Molton <ian@mnementh.co.uk> wrote:
>> On 23/08/17 11:09, Julian Calaby wrote:
>>> I don't think I explained my point well.
>>>
>>> The description of this patch implies that this method
>>> brcmf_sdiod_ramrw(), now relies on the window being set elsewhere
>>> before it's called.
>>
>> I don't think it does.
> 
> "Resetting" can mean both changing it back after setting it to
> something or changing it from some other state to a known one. I read
> it as the latter.

True

>>> I'm asking why we can't move the setting of the window inside this
>>> function and remove any redundant calls to
>>> brcmf_sdiod_set_backplane_window() outside of it.
>>
>> We do call brcmf_sdiod_set_backplane_window() in this function. We just
>> dont need to call it a second time to restore the original window.
> 
> Ah, I do not have the full code in front of me, so I couldn't see
> that, therefore my point is invalid.

No worries.

-Ian
