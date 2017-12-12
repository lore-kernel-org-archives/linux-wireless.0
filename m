Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:47044 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbdLLJFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 04:05:06 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] wl3501: a possible sleep-in-atomic bug in wl3501_reset
To: kvalo@codeaurora.org, mhchen@golf.ccl.itri.org.tw,
        acme@conectiva.com.br, niemeyer@conectiva.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <8b0519f9-e5f3-aa73-09be-f399f6a6865a@gmail.com> (sfid-20171212_100531_141567_F21CE0CD)
Date: Tue, 12 Dec 2017 17:04:52 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to drivers/net/wireless/wl3501_cs.c, the driver may sleep 
under a spinlock.
The function call path is:
wl3501_reset (acquire the spinlock)
   free_irq --> may sleep

I do not find a good way to fix it, so I only report.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
