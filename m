Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36950 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbYJYL2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 07:28:14 -0400
Date: Sat, 25 Oct 2008 13:28:13 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Message-ID: <20081025112813.GC12252@Chamillionaire.breakpoint.cc> (sfid-20081025_132816_618712_0C295E62)
References: <4902DEBB.3050205@hotmail.com> <20081025112147.GA12252@Chamillionaire.breakpoint.cc> <200810251325.07916.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <200810251325.07916.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Michael Buesch | 2008-10-25 13:25:07 [+0200]:

>On Saturday 25 October 2008 13:21:47 Sebastian Andrzej Siewior wrote:
>> -	fc = *(__le16 *)buffer;
>> +	fc = get_unaligned_le32(buffer);
>
>I'd say this semantically changes the code.
argh,
sorry,

Subject: [PATCH] wireless/zd1211rw: use  get_unaligned_le16 helper (v2)

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    5 +++--
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4d7b98b..bf4b4a4 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -25,6 +25,7 @@
 #include <linux/usb.h>
 #include <linux/jiffies.h>
 #include <net/ieee80211_radiotap.h>
+#include <asm/unaligned.h>
 
 #include "zd_def.h"
 #include "zd_chip.h"
@@ -662,7 +663,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 			&& !mac->pass_ctrl)
 		return 0;
 
-	fc = *(__le16 *)buffer;
+	fc = get_unaligned_le16(buffer);
 	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
 
 	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
@@ -758,7 +759,7 @@ void zd_process_intr(struct work_struct *work)
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
-	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
+	int_status = get_unaligned_le16(mac->intr_buffer+4);
 	if (int_status & INT_CFG_NEXT_BCN) {
 		if (net_ratelimit())
 			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index a60ae86..0b27778 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -355,7 +355,7 @@ static inline void handle_regs_int(struct urb *urb)
 	ZD_ASSERT(in_interrupt());
 	spin_lock(&intr->lock);
 
-	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
+	int_num = get_unaligned_le16(urb->transfer_buffer+2);
 	if (int_num == CR_INTERRUPT) {
 		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
 		memcpy(&mac->intr_buffer, urb->transfer_buffer,
-- 
1.6.0.2

