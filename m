Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21715 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040189AbdDUULQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 16:11:16 -0400
Date: Fri, 21 Apr 2017 23:11:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: tom.leiming@gmail.com,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] ath9k-htc:respect usb buffer cacheline alignment in reg
 in path
Message-ID: <20170421201105.odl7rcm7ltpq2ow3@mwanda> (sfid-20170421_221120_098447_12298DCB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ming Lei,

The patch e6c6d33cb7d1: "ath9k-htc:respect usb buffer cacheline
alignment in reg in path" from Apr 13, 2010, leads to the following
static checker warning:

	drivers/net/wireless/ath/ath9k/hif_usb.c:745 ath9k_hif_usb_reg_in_cb()
	warn: 'skb' was already freed.

drivers/net/wireless/ath/ath9k/hif_usb.c
   712          if (likely(urb->actual_length != 0)) {
   713                  skb_put(skb, urb->actual_length);
   714  
   715                  /* Process the command first */
   716                  ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
   717                                   skb->len, USB_REG_IN_PIPE);
   718  
   719  
   720                  nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
   721                  if (!nskb) {
   722                          dev_err(&hif_dev->udev->dev,
   723                                  "ath9k_htc: REG_IN memory allocation failure\n");
   724                          urb->context = NULL;
   725                          return;
   726                  }
   727  
   728                  usb_fill_int_urb(urb, hif_dev->udev,
   729                                   usb_rcvintpipe(hif_dev->udev,
   730                                                   USB_REG_IN_PIPE),
   731                                   nskb->data, MAX_REG_IN_BUF_SIZE,
   732                                   ath9k_hif_usb_reg_in_cb, nskb, 1);
   733          }
   734  
   735  resubmit:
   736          usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
   737          ret = usb_submit_urb(urb, GFP_ATOMIC);
   738          if (ret) {
   739                  usb_unanchor_urb(urb);
   740                  goto free;
   741          }
   742  
   743          return;
   744  free:
   745          kfree_skb(skb);
   746          urb->context = NULL;
   747  }

regards,
dan carpenter
