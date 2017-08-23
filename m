Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:35184 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753919AbdHWMg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 08:36:59 -0400
Received: by mail-yw0-f181.google.com with SMTP id s187so8613966ywf.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2017 05:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2ef60e61-1a55-21c9-744e-39bb5dadfa66@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk> <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
 <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com> <CAGRGNgXWg6Gj4ND+BrfziX9Je5=b8Ovv=6fafYmg1CiSh6m9Mw@mail.gmail.com>
 <2ef60e61-1a55-21c9-744e-39bb5dadfa66@mnementh.co.uk>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 23 Aug 2017 22:36:38 +1000
Message-ID: <CAGRGNgW4a5Ld0=HZ4AfBMzKoD2PvCJR=wfuAz3pxXupfbBw7YA@mail.gmail.com> (sfid-20170823_143702_336611_F1C96CE2)
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to brcmf_sdiod_set_backplane_window()
To: Ian Molton <ian@mnementh.co.uk>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

On Wed, Aug 23, 2017 at 10:27 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> On 23/08/17 11:09, Julian Calaby wrote:
>> I don't think I explained my point well.
>>
>> The description of this patch implies that this method
>> brcmf_sdiod_ramrw(), now relies on the window being set elsewhere
>> before it's called.
>
> I don't think it does.

"Resetting" can mean both changing it back after setting it to
something or changing it from some other state to a known one. I read
it as the latter.

>> I'm asking why we can't move the setting of the window inside this
>> function and remove any redundant calls to
>> brcmf_sdiod_set_backplane_window() outside of it.
>
> We do call brcmf_sdiod_set_backplane_window() in this function. We just
> dont need to call it a second time to restore the original window.

Ah, I do not have the full code in front of me, so I couldn't see
that, therefore my point is invalid.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
