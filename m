Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33306 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaC1I2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:28:23 -0400
Date: Fri, 28 Mar 2014 11:28:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: fariyaf@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: rsi: Add RS9113 wireless driver
Message-ID: <20140328082811.GL25192@mwanda> (sfid-20140328_092829_821291_8D328B07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Fariya Fatima,

The patch dad0d04fa7ba: "rsi: Add RS9113 wireless driver" from Mar
16, 2014, leads to the following static checker warning:

	drivers/net/wireless/rsi/rsi_91x_core.c:121 rsi_core_determine_hal_queue()
	error: buffer overflow 'common->tx_qinfo' 4 <= 4

This is probably a false positive.

drivers/net/wireless/rsi/rsi_91x_core.c
   104  get_queue_num:
   105          q_num = 0;
                ^^^^^^^^^
Unneeded assignment.

   106          recontend_queue = false;
   107  
   108          q_num = rsi_determine_min_weight_queue(common);
                ^^^^^
q_num = 0-4.

   109          q_len = skb_queue_len(&common->tx_queue[ii]);
   110          ii = q_num;
   111  
   112          /* Selecting the queue with least back off */
   113          for (; ii < NUM_EDCA_QUEUES; ii++) {
   114                  if (((common->tx_qinfo[ii].pkt_contended) &&
   115                       (common->tx_qinfo[ii].weight < min)) && q_len) {
   116                          min = common->tx_qinfo[ii].weight;
   117                          q_num = ii;
   118                  }
   119          }
   120  
   121          common->tx_qinfo[q_num].pkt_contended = 0;
                                 ^^^^^
4 is too high.

   122          /* Adjust the back off values for all queues again */
   123          recontend_queue = rsi_recalculate_weights(common);

regards,
dan carpenter
