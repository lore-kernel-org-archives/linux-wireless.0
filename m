Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39550 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1JJTQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:16:19 -0400
Received: by yxl31 with SMTP id 31so5685999yxl.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:16:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318269135.9690.369.camel@cumari>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-3-git-send-email-eliad@wizery.com>
	<1318269135.9690.369.camel@cumari>
Date: Mon, 10 Oct 2011 21:16:18 +0200
Message-ID: <CAB3XZEf0=132jQ2HrsbbFXrCd9A6AXqFYkKSJU4SdbMsG5C=hw@mail.gmail.com> (sfid-20111010_211622_854286_DF25B6AD)
Subject: Re: [PATCH 02/29] wl12xx: move last_tx_hlid into wlvif
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 7:52 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
>> move last_tx_hlid into the per-interface data, rather than
>> being global.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/debugfs.c |    1 -
>>  drivers/net/wireless/wl12xx/main.c    |    1 -
>>  drivers/net/wireless/wl12xx/tx.c      |   10 +++++-----
>>  drivers/net/wireless/wl12xx/wl12xx.h  |    6 +++---
>>  4 files changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
>> index f0398d0..bbc8004 100644
>> --- a/drivers/net/wireless/wl12xx/debugfs.c
>> +++ b/drivers/net/wireless/wl12xx/debugfs.c
>> @@ -355,7 +355,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
>>       DRIVER_STATE_PRINT_INT(sg_enabled);
>>       DRIVER_STATE_PRINT_INT(enable_11a);
>>       DRIVER_STATE_PRINT_INT(noise);
>> -     DRIVER_STATE_PRINT_INT(last_tx_hlid);
>>       DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
>>       DRIVER_STATE_PRINT_LHEX(ap_ps_map);
>>       DRIVER_STATE_PRINT_HEX(quirks);
>
> No big deal at this point, so I'll apply this, but maybe we should print
> the last_tx_hlid from inside all the vifs as well?
>
yes.
i plan to add a new vif_state debugfs key that will print all the relevant info.

Eliad.
