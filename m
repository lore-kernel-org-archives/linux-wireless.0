Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34895 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbdELQmf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:35 -0400
Received: by mail-pf0-f170.google.com with SMTP id n23so27803808pfb.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:30 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 06/11] mwifiex: don't leak stashed beacon buffer on reset
Date: Fri, 12 May 2017 09:42:03 -0700
Message-Id: <20170512164208.38725-6-briannorris@chromium.org> (sfid-20170512_184321_488278_75A6DB4F)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When removing or resetting an mwifiex device, we don't remember to free
the saved beacon buffer. Use the (somewhat misleadingly-named)
mwifiex_free_priv() helper to handle this.

Noticed by kmemleak during tests:

echo 1 > /sys/bus/pci/devices/.../reset

unreferenced object 0xffffffc09d034a00 (size 256):
...
  backtrace:
    [<ffffffc0003cdce4>] create_object+0x228/0x3c4
    [<ffffffc000c0b9d8>] kmemleak_alloc+0x54/0x88
    [<ffffffc0003c0848>] __kmalloc+0x1cc/0x2dc
    [<ffffffbffc1500c4>] mwifiex_save_curr_bcn+0x80/0x308 [mwifiex]
    [<ffffffbffc1516b8>] mwifiex_ret_802_11_associate+0x4ec/0x5fc [mwifiex]
    [<ffffffbffc15da90>] mwifiex_process_sta_cmdresp+0xaf8/0x1fa4 [mwifiex]
    [<ffffffbffc1411e0>] mwifiex_process_cmdresp+0x40c/0x510 [mwifiex]
    [<ffffffbffc13b8f4>] mwifiex_main_process+0x4a4/0xb00 [mwifiex]
    [<ffffffbffc13bf84>] mwifiex_main_work_queue+0x34/0x40 [mwifiex]

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 756948385b60..2ada202c72ec 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -670,8 +670,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 			mwifiex_clean_auto_tdls(priv);
 			mwifiex_abort_cac(priv);
-			mwifiex_clean_txrx(priv);
-			mwifiex_delete_bss_prio_tbl(priv);
+			mwifiex_free_priv(priv);
 		}
 	}
 
-- 
2.13.0.rc2.291.g57267f2277-goog
