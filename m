Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:39054 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753408AbdJIBaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Oct 2017 21:30:14 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
To: gregkh@linuxfoundation.org, m@bues.ch, sudipm.mukherjee@gmail.com,
        akpm@linux-foundation.org, johannes@sipsolutions.net,
        dahinds@users.sourceforge.net
Cc: linux-pcmcia@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: [BUG] ssb: Possible sleep-in-atomic bugs in ssb_pcmcia_read8
Message-ID: <b3252056-573d-2c69-81d6-dde291246748@163.com> (sfid-20171009_033038_343245_8692BA01)
Date: Mon, 9 Oct 2017 09:29:17 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to pcmcia.c, the driver may sleep under a spinlock.
The function call paths are:
ssb_pcmcia_read8 (acquire the spinlock)
   select_core_and_segment
     ssb_pcmcia_switch_segment
       ssb_pcmcia_cfg_write
         pcmcia_write_config_byte
           pcmcia_access_config (drivers/pcmcia/pcmcia_resource.c)
             mutex_lock --> may sleep

ssb_pcmcia_read8 (acquire the spinlock)
   select_core_and_segment
     ssb_pcmcia_switch_segment
       sssb_pcmcia_cfg_read
         pcmcia_read_config_byte
           pcmcia_access_config (drivers/pcmcia/pcmcia_resource.c)
             mutex_lock --> may sleep

A possible fix is to use spinlock instead of mutex lock in 
pcmcia_access_config in drivers/pcmcia/pcmcia_resource.c.

These bugs are found by my static analysis tool and my code review.


Thanks,
Jia-Ju Bai
