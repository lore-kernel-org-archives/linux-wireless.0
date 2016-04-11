Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35285 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbcDKRb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 13:31:56 -0400
Received: by mail-lf0-f47.google.com with SMTP id c126so167304762lfb.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 10:31:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570BB012.8060709@j1.co.za>
References: <570BB012.8060709@j1.co.za>
Date: Mon, 11 Apr 2016 20:31:54 +0300
Message-ID: <CANUX_P0+9ALJa4WexPCpW5a3YxKDPL3wZGta-F2VrgOBU6VcXA@mail.gmail.com> (sfid-20160411_193159_912984_CD0D4B6A)
Subject: Re: hardware restart on Intel 7260
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johann Haarhoff <johann@j1.co.za>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 11, 2016 at 5:09 PM, Johann Haarhoff <johann@j1.co.za> wrote:
>
> Hi
>
> (Please CC as I am not subscribed to the list)
>
> I'm seeing the following trace on a Lenovo Yoga 2 Pro with an Intel 7260 (rev 6b).
>
> Kernel is 4.5 on using the latest -16 firmware from wireless.wiki.kernel.org. I tried the -17 firmware from git.kernel.org with a
> very similar result.
>
> module was loaded with:
>
> options iwlwifi power_save=0 bt_coex_active=0 swcrypto=1

Can you try:
options iwlmvm power_scheme=1

>
> The trace is accompanied by a couple seconds where no data transfer can happen (youtube stutters etc.), but other than that it seems
> to resume fine. This happens every 2-15 minutes if I am moving data.
>
> Disabling 11n fixes the problem, but that is not really an viable option.

That can help to know where the problem hides.

>
> Please let me know if there is anything I can add to help with the debugging.
>
> > Apr 11 15:52:30  kernel: [13827.165868] iwlwifi 0000:01:00.0: Queue 2 stuck for 10000 ms.
> > Apr 11 15:52:30  kernel: [13827.165878] iwlwifi 0000:01:00.0: Current SW read_ptr 135 write_ptr 171

Meh... So what happens here is that the firmware is stuck while
transmitting. The driver detects this and as a workaround, resets the
firmware. The detection takes 10 seconds.
The only way to understand what is going on here is to take the
firmware from [1] and to run the steps to collect firmware debug data
from [2]. I recommend you open a bug on bugzilla.
Out of curiosity, did you try to work in DC mode (on battery, not
connected to the power)? A user reported that it helped [3].

[1] https://bugzilla.kernel.org/attachment.cgi?id=208381
[2] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#firmware_debugging
[3] https://bugzilla.kernel.org/show_bug.cgi?id=112931


>
>
> Thanks,
>
> Johann
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
