Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:32770 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeDRSBQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 14:01:16 -0400
Received: by mail-wr0-f178.google.com with SMTP id z73-v6so7192093wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 11:01:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <001901d3c759$8cd5b970$a6812c50$@codeaurora.org>
References: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com>
 <001901d3c759$8cd5b970$a6812c50$@codeaurora.org>
From: David Dean Zhang <daviddean166@gmail.com>
Date: Wed, 18 Apr 2018 14:01:14 -0400
Message-ID: <CAFnQ7oti-cKJxBXyuCCfJeLgHMcw1U0pE1hkdCH_ukN032f90A@mail.gmail.com> (sfid-20180418_200121_646238_650496DE)
Subject: Re: wil6210: low level sector API
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I updated the firmware and tried to call some low level functions,
like WMI_PRIO_TX_SECTORS_NUMBER_CMDID and WMI_SET_RF_SECTOR_ON_CMDID .
The previous errors have gone but it still has errors:

wil6210 0000:03:00.0 wlp3s0: wmi_event_handle: Unhandled event 0x19a5
wil6210 0000:03:00.0 wlp3s0: wmi_call: wmi_call(0x09a6->0x19a6)
timeout 2000 msec

So I am wondering whether it is because the chipset does not support
these wmi commands. I just want to know how to use these commands and
how to disable TXSS. I appreciate if anyone could provide some
suggestions. Thanks.

Bests,
David

On Thu, Mar 29, 2018 at 8:29 AM, Dedy Lansky <dlansky@codeaurora.org> wrote:
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of David Dean
> Sent: Monday, March 26, 2018 9:38 PM
>
>> My question is how I can disable TXSS. One way I found in the wmi.h is setting the number of sectors of TXSS to 0 or 1 > by using wmi_prio_tx_sectors_num_cmd so that the TXSS will only use 1 sector.
>> However, when I called this cmd, I got this error:
>> wil6210 0000:03:00.0 wlp3s0: wil6210_irq_misc: Firmware error detected, assert codes FW 0x00001038, UCODE 0x00000000
>> wil6210 0000:03:00.0 wlp3s0: wil_fw_core_dump: fw core dumped, size 823296 bytes
>> wil6210 0000:03:00.0 wlp3s0: wil_notify_fw_error: Notify about firmware error
>> So I am wondering whether the firmware does not support these kinds of wmi commands. Does anyone have any experience on this? Thank you.
>
> Indeed this error indicates that FW doesn't support these WMI commands.
> We are working on releasing new FW version with support for these commands.
>
> Thanks,
>  Dedy.
>
