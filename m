Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbcIQN3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 09:29:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vidar Haarr <vidar@heidrunbryggeri.no>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [athk9] beacon.c:642 ath9k_calculate_summary_state dump
References: <CAJiC63F-O5KeCP+JZjW38uNDc=umXcOZVGma_SyiaTm70fGQ3A@mail.gmail.com>
Date: Sat, 17 Sep 2016 16:29:13 +0300
In-Reply-To: <CAJiC63F-O5KeCP+JZjW38uNDc=umXcOZVGma_SyiaTm70fGQ3A@mail.gmail.com>
        (Vidar Haarr's message of "Sat, 17 Sep 2016 11:49:05 +0200")
Message-ID: <87mvj63b9y.fsf@purkki.adurom.net> (sfid-20160917_152923_219391_BAA3F2E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vidar Haarr <vidar@heidrunbryggeri.no> writes:

> I'm seeing the message below spammed continously in journald, even
> with 4.8-rc6. It's so bad that it throttles the CPU performance every
> few seconds.
>
> I found https://patchwork.kernel.org/patch/9247699/ which seems related.

[...]

> sep. 17 11:38:36 edbpc kernel: WARNING: CPU: 0 PID: 1684 at
> /home/kernel/COD/linux/drivers/net/wireless/ath/ath9k/beacon.c:642
> ath9k_calculate_summary_state+0x135/0x390 [ath9k]

Looks like exactly the same problem, but the fix (below) is not in
v4.8-rc6. Should be in -rc7 which Linus hopefully releases on Sunday.
Please test that and report if the problem continues.

05860bed491b ath9k: fix client mode beacon configuration

-- 
Kalle Valo
