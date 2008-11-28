Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:59495 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYK1GrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 01:47:19 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1320715wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 22:47:18 -0800 (PST)
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
In-Reply-To: <492F856D.9020200@hotmail.com>
References: <4902DEBB.3050205@hotmail.com>
	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
	 <200810251325.07916.mb@bu3sch.de>
	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
	 <492F856D.9020200@hotmail.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 22:47:16 -0800
Message-Id: <1227854836.5880.8.camel@brick> (sfid-20081128_074725_535120_B1E69350)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-28 at 16:45 +1100, Shaddy Baddah wrote:
> On 25/10/08 22:28, Sebastian Andrzej Siewior wrote:
> > Subject: [PATCH] wireless/zd1211rw: use  get_unaligned_le16 helper (v2)
> 
> I'm not too sure about the protocol for updating a patch to claim that 
> you've verified it, but I hope to get this patch applied to git by 
> verifying it worked for me on an sparc64 machine.
> 
> Subject: [PATCH] wireless/zd1211rw: use  get_unaligned_le16 helper (v2)
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Tested-by: Shaddy Baddah <shaddy_badddah@hotmail.com>
> ---
>   drivers/net/wireless/zd1211rw/zd_mac.c |    5 +++--
>   drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c 
> b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 4d7b98b..bf4b4a4 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -25,6 +25,7 @@
>   #include <linux/usb.h>
>   #include <linux/jiffies.h>
>   #include <net/ieee80211_radiotap.h>
> +#include <asm/unaligned.h>
> 
>   #include "zd_def.h"
>   #include "zd_chip.h"
> @@ -662,7 +663,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 
> *buffer, unsigned int length)
>   			&& !mac->pass_ctrl)
>   		return 0;
> 
> -	fc = *(__le16 *)buffer;
> +	fc = get_unaligned_le16(buffer);
>   	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
> 

I think this should be:

	fc = get_unaligned((__le16 *)buffer);

As ieee8011_is_data_qos wants a le16 and your use above will swap to cpu-order.

> 
>   	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
> @@ -758,7 +759,7 @@ void zd_process_intr(struct work_struct *work)
>   	u16 int_status;
>   	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
> 
> -	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
> +	int_status = get_unaligned_le16(mac->intr_buffer+4);

OK.

>   	if (int_status & INT_CFG_NEXT_BCN) {
>   		if (net_ratelimit())
>   			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
> diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c 
> b/drivers/net/wireless/zd1211rw/zd_usb.c
> index a60ae86..0b27778 100644
> --- a/drivers/net/wireless/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
> @@ -355,7 +355,7 @@ static inline void handle_regs_int(struct urb *urb)
>   	ZD_ASSERT(in_interrupt());
>   	spin_lock(&intr->lock);
> 
> -	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
> +	int_num = get_unaligned_le16(urb->transfer_buffer+2);
>   	if (int_num == CR_INTERRUPT) {
>   		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
>   		memcpy(&mac->intr_buffer, urb->transfer_buffer,

OK.

So the first hunk needs changing, but other than that, looks OK.

Harvey

