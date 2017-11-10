Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47266 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbdKJAcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 19:32:05 -0500
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        erik.stromdahl@gmail.com, ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: ath10k targaddrs issue
Message-ID: <dc4ef513-d100-39b4-c868-d997675bc059@candelatech.com> (sfid-20171110_013207_986794_58867174)
Date: Thu, 9 Nov 2017 16:32:02 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While poking around in the firmware, I noticed what appears to be
an ath10k driver issue, which came in with this commit below.

commit 01d6fd6965eaf8d4b3aab681d30e77c53a834162
Author: Erik Stromdahl <erik.stromdahl@gmail.com>
Date:   Wed Apr 26 12:17:55 2017 +0300

     ath10k: various sdio related definitions

     Debug masks for SDIO HIF layer.
     Address definitions for SDIO/mbox based chipsets.
     Augmented struct host_interest with more members.

     Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
     Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

...

diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index cbac9e42..8bded5d 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -205,6 +205,24 @@ struct host_interest {
          */
         /* Bit 1 - unused */
         u32 hi_fw_swap;                                 /* 0x104 */
+
+       /* global arenas pointer address, used by host driver debug */
+       u32 hi_dynamic_mem_arenas_addr;                 /* 0x108 */
+
+       /* allocated bytes of DRAM use by allocated */
+       u32 hi_dynamic_mem_allocated;                   /* 0x10C */
+
+       /* remaining bytes of DRAM */
+       u32 hi_dynamic_mem_remaining;                   /* 0x110 */
+
+       /* memory track count, configured by host */
+       u32 hi_dynamic_mem_track_max;                   /* 0x114 */
+
+       /* minidump buffer */
+       u32 hi_minidump;                                /* 0x118 */
+
+       /* bdata's sig and key addr */
+       u32 hi_bd_sig_key;                              /* 0x11c */
  } __packed;


Those variables above may be correct for some firmware, but they are not
correct for at least some versions of 10.4, which have this instead:

...
     A_UINT32               hi_fw_swap;                               /* 0x104 */

     /* host side need to support tx/rx data packet swap */
     A_UINT32			   hi_txrx_dataswap;	           /* 0x108 */	

     /* enable allocram statistics gathering (set to an integer, which
      * is the number of tracking records that allocram will allocate).
      */
     A_UINT32               hi_allocram_track_max;                     /* 0x108 */
}

I guess this may not be an issue as long as zero'd values are sent to the
10.4 nics, but it is confusing at best.

Eric, where did you get these values from?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
