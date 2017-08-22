Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33197 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbdHVTid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 15:38:33 -0400
Received: by mail-wr0-f177.google.com with SMTP id a47so16336755wra.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2017 12:38:32 -0700 (PDT)
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Julian Calaby <julian.calaby@gmail.com>,
        Ian Molton <ian@mnementh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-18-ian@mnementh.co.uk>
 <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <71fdb0e7-f31d-fa98-c3c6-92ebe2f1a047@broadcom.com> (sfid-20170822_213837_268563_6CF29C14)
Date: Tue, 22 Aug 2017 21:38:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 14:50, Julian Calaby wrote:
> Hi Ian,
> 
> On Tue, Aug 22, 2017 at 9:25 PM, Ian Molton <ian@mnementh.co.uk> wrote:
>> All functions that might require the window address changing call
>> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
>> the window is not required.
> 
> Wouldn't it be more safe to write these sorts of functions so that
> they set the window themselves instead of relying on the caller?

The function brcmf_sdiod_set_backplane_window() is a helper function by 
which these sorts of functions set the window themselves. It would be 
duplicating too much code as setting the window involves three register 
accesses (or so) on the device.

Regards,
Arend
