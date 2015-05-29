Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbbE2PAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 11:00:43 -0400
Date: Fri, 29 May 2015 18:00:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: liuzy@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: add dump data debug support
Message-ID: <20150529150025.GB10313@mwanda> (sfid-20150529_170054_423103_E264E3DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Zhaoyang Liu,

This is a semi-automatic email about new static checker warnings.

The patch 868093a9df75: "mwifiex: add dump data debug support" from 
May 12, 2015, leads to the following Smatch complaint:

drivers/net/wireless/mwifiex/cmdevt.c:475 mwifiex_process_event()
	 error: we previously assumed 'skb' could be null (see line 467)

drivers/net/wireless/mwifiex/cmdevt.c
   466	
   467		if (skb) {
                    ^^^
Old check for NULL.

   468			rx_info = MWIFIEX_SKB_RXCB(skb);
   469			memset(rx_info, 0, sizeof(*rx_info));
   470			rx_info->bss_num = priv->bss_num;
   471			rx_info->bss_type = priv->bss_type;
   472		}
   473	
   474		mwifiex_dbg(adapter, EVENT, "EVENT: cause: %#x\n", eventcause);
   475		mwifiex_dbg_dump(adapter, EVT_D, "Event Buf:", skb->data, skb->len);
                                                               ^^^^^
Patch introduces unchecked dereference.

   476	
   477		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)

regards,
dan carpenter
