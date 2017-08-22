Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38021 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdHVToF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 15:44:05 -0400
Received: by mail-wm0-f52.google.com with SMTP id l19so1023422wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2017 12:44:04 -0700 (PDT)
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
 <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
Message-ID: <2e174b5d-b8c2-3303-b66c-cac656478adb@broadcom.com> (sfid-20170822_214408_654488_4FE86CF4)
Date: Tue, 22 Aug 2017 21:44:01 +0200
MIME-Version: 1.0
In-Reply-To: <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 21:38, Arend van Spriel wrote:
> On 22-08-17 14:50, Julian Calaby wrote:
>> Hi Ian,
>>
>> On Tue, Aug 22, 2017 at 9:25 PM, Ian Molton <ian@mnementh.co.uk> wrote:
>>> All functions that might require the window address changing call
>>> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
>>> the window is not required.
>>
>> Wouldn't it be more safe to write these sorts of functions so that
>> they set the window themselves instead of relying on the caller?
> 
> The function brcmf_sdiod_set_backplane_window() is a helper function by 
> which these sorts of functions set the window themselves. It would be 
> duplicating too much code as setting the window involves three register 
> accesses (or so) on the device.

By the way, the driver prefix in the subject is wrong, ie. brcmfamc 
should be brcmfmac. I think it already was wrong in the previous series, 
but I forgot to mention it.

Regards,
Arend
