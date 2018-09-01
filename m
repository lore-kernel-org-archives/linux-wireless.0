Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41893 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbeIANUZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 09:20:25 -0400
To: amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: wireless: mwifiex: A possible sleep-in-atomic-context bug
 in mwifiex_wait_queue_complete()
Message-ID: <35980039-f268-2db3-5c7d-19ab0c917d44@gmail.com> (sfid-20180901_110947_422934_A19D0740)
Date: Sat, 1 Sep 2018 17:08:59 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_usb_tx_complete() is a completion handler function for the
USB driver. So it should not sleep, but it is can sleep according to the
function call paths (from bottom to top) in Linux-4.16:

[FUNC] schedule_timeout
drivers/net/wireless/marvell/mwifiex/sta_ioctl.c, 63:
     schedule_timeout in mwifiex_wait_queue_complete
drivers/net/wireless/marvell/mwifiex/cmdevt.c, 673:
     mwifiex_wait_queue_complete in mwifiex_send_cmd
drivers/net/wireless/marvell/mwifiex/main.c, 1046:
     mwifiex_send_cmd in mwifiex_multi_chan_resync
drivers/net/wireless/marvell/mwifiex/usb.c, 288:
     mwifiex_multi_chan_resync in mwifiex_usb_tx_complete

I do not find a good way to fix this bug, so I only report it.

This bug is found by my static analysis tool DSAC.


Best wishes,
Jia-Ju Bai
