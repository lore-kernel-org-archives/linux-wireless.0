Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:32833 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbCZKF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 06:05:58 -0400
Received: by lbcmq2 with SMTP id mq2so37151338lbc.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 03:05:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix insufficient tracing buffer size
Date: Thu, 26 Mar 2015 10:03:22 +0000
Message-Id: <1427364202-25235-1-git-send-email-michal.kazior@tieto.com> (sfid-20150326_110602_679971_25DB224C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some trace messages were truncated and a kernel
splat could be seen in the log:

  WARNING: CPU: 3 PID: 0 at /devel/src/linux/drivers/net/wireless/ath/ath10k/./trace.h:114 ftrace_raw_event_ath10k_log_dbg+0x20e/0x220 [ath10k_core]()
  Modules linked in: ath10k_pci(O) ath10k_core(O) ath iwldvm iwlwifi [last unloaded: iwlwifi]
  CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W  O    4.0.0-rc3-wl-ath+ #703
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
   ffffffffa01d4cb0 ffff88001fd83998 ffffffff8191b86c ffffffff81e3b718
   0000000000000000 ffff88001fd839d8 ffffffff8105573a ffff88001c0a5528
   ffff88001bea9ae0 ffff88001c3dd940 00000000000d0018 ffff88001fd83a80
  Call Trace:
   <IRQ>  [<ffffffff8191b86c>] dump_stack+0x45/0x57
   [<ffffffff8105573a>] warn_slowpath_common+0x8a/0xc0
   [<ffffffff8105582a>] warn_slowpath_null+0x1a/0x20
   [<ffffffffa01c61fe>] ftrace_raw_event_ath10k_log_dbg+0x20e/0x220 [ath10k_core]
   [<ffffffffa01aaa6b>] ath10k_dbg+0xbb/0xd0 [ath10k_core]
   [<ffffffff810eed89>] ? trace_clock_local+0x9/0x10
   [<ffffffffa01bd069>] ath10k_wmi_event_service_ready+0x479/0x520 [ath10k_core]
   [<ffffffff810fdf90>] ? trace_buffer_unlock_commit+0x50/0x60
   [<ffffffffa01c2113>] ath10k_wmi_tlv_op_rx+0x6b3/0x8b0 [ath10k_core]

This could be reproduced with:

  trace-cmd record -e ath10k
  ifconfig wlan0 down
  ifconfig wlan0 up

Fixes: 5c01aa3de918 ("ath10k: deduplicate wmi service ready logic")
Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 5407887380ab..71dfcd96354b 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -46,7 +46,7 @@ static inline void trace_ ## name(proto) {}
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ath10k
 
-#define ATH10K_MSG_MAX 200
+#define ATH10K_MSG_MAX 400
 
 DECLARE_EVENT_CLASS(ath10k_log_event,
 	TP_PROTO(struct ath10k *ar, struct va_format *vaf),
-- 
2.1.4

