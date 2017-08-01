Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45441 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdHALE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 07:04:59 -0400
Date: Tue, 1 Aug 2017 14:04:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: prameela.j04cs@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rsi: immediate wakeup bit and priority for TX command
 packets
Message-ID: <20170801110449.5pddqqml32qqlvrn@mwanda> (sfid-20170801_130525_267234_D16CD638)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Prameela Rani Garnepudi,

The patch 9a629fafe7d8: "rsi: immediate wakeup bit and priority for
TX command packets" from Jul 10, 2017, leads to the following static
checker warning:

	drivers/net/wireless/rsi/rsi_91x_mgmt.c:277 rsi_send_internal_mgmt_frame()
	error: potentially dereferencing uninitialized 'desc'.

drivers/net/wireless/rsi/rsi_91x_mgmt.c
   267  static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
   268                                          struct sk_buff *skb)
   269  {
   270          struct skb_info *tx_params;
   271          struct rsi_cmd_desc *desc;
                                     ^^^^
   272  
   273          if (skb == NULL) {
   274                  rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
   275                  return -ENOMEM;
   276          }
   277          desc->desc_dword0.len_qno |= cpu_to_le16(DESC_IMMEDIATE_WAKEUP);
                ^^^^^^

   278          skb->priority = MGMT_SOFT_Q;
   279          tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
   280          tx_params->flags |= INTERNAL_MGMT_PKT;
   281          skb_queue_tail(&common->tx_queue[MGMT_SOFT_Q], skb);
   282          rsi_set_event(&common->tx_thread.event);
   283          return 0;
   284  }

regards,
dan carpenter
