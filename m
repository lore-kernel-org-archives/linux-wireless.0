Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:45198 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbeCZShy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 14:37:54 -0400
Received: by mail-ot0-f193.google.com with SMTP id h26-v6so14272815otj.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 11:37:54 -0700 (PDT)
MIME-Version: 1.0
From: David Dean <daviddean166@gmail.com>
Date: Mon, 26 Mar 2018 14:37:53 -0400
Message-ID: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com> (sfid-20180326_203758_018010_BDFC36DB)
Subject: wil6210: low level sector API
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working on wil6210 sector control. Now I think I can successfully
call these 4 functions( set_cfg, get_cfg, set_selected and get
selected index) but it looks like it does not work well because, in
the next Beacon Interval, TXSS will set a new TX sector again. My
question is how I can disable TXSS. One way I found in the wmi.h is
setting the number of sectors of TXSS to 0 or 1 by using
wmi_prio_tx_sectors_num_cmd so that the TXSS will only use 1 sector.
However, when I called this cmd, I got this error:

wil6210 0000:03:00.0 wlp3s0: wil6210_irq_misc: Firmware error
detected, assert codes FW 0x00001038, UCODE 0x00000000
wil6210 0000:03:00.0 wlp3s0: wil_fw_core_dump: fw core dumped, size 823296 bytes
wil6210 0000:03:00.0 wlp3s0: wil_notify_fw_error: Notify about firmware error

So I am wondering whether the firmware does not support these kinds of
wmi commands. Does anyone have any experience on this? Thank you.

Thanks,
David
