Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33810 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbdHWKJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 06:09:29 -0400
Received: by mail-yw0-f180.google.com with SMTP id s143so6783735ywg.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2017 03:09:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
References: <20170822112550.60311-1-ian@mnementh.co.uk> <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com> <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 23 Aug 2017 20:09:07 +1000
Message-ID: <CAGRGNgXWg6Gj4ND+BrfziX9Je5=b8Ovv=6fafYmg1CiSh6m9Mw@mail.gmail.com> (sfid-20170823_120933_428443_7563A019)
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to brcmf_sdiod_set_backplane_window()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Wed, Aug 23, 2017 at 5:38 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 22-08-17 14:50, Julian Calaby wrote:
>>
>> Hi Ian,
>>
>> On Tue, Aug 22, 2017 at 9:25 PM, Ian Molton <ian@mnementh.co.uk> wrote:
>>>
>>> All functions that might require the window address changing call
>>> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
>>> the window is not required.
>>
>>
>> Wouldn't it be more safe to write these sorts of functions so that
>> they set the window themselves instead of relying on the caller?
>
>
> The function brcmf_sdiod_set_backplane_window() is a helper function by
> which these sorts of functions set the window themselves. It would be
> duplicating too much code as setting the window involves three register
> accesses (or so) on the device.

I don't think I explained my point well.

The description of this patch implies that this method
brcmf_sdiod_ramrw(), now relies on the window being set elsewhere
before it's called.

I'm asking why we can't move the setting of the window inside this
function and remove any redundant calls to
brcmf_sdiod_set_backplane_window() outside of it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
