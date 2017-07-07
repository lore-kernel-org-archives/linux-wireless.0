Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31726 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdGGJdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 05:33:44 -0400
Date: Fri, 7 Jul 2017 12:33:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johan@kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC: fix broken device allocation
Message-ID: <20170707093334.zhnn3jrtqosbqdib@mwanda> (sfid-20170707_113353_036601_697FCBE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johan Hovold,

The patch 20777bc57c34: "NFC: fix broken device allocation" from Mar
30, 2017, leads to the following static checker warning:

	drivers/nfc/pn533/pn533.c:2653 pn533_register_device()
	error: 'priv->nfc_dev' dereferencing possible ERR_PTR()

drivers/nfc/pn533/pn533.c
  2639          skb_queue_head_init(&priv->resp_q);
  2640          skb_queue_head_init(&priv->fragment_skb);
  2641  
  2642          INIT_LIST_HEAD(&priv->cmd_queue);
  2643  
  2644          priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
  2645                                             priv->ops->tx_header_len +
  2646                                             PN533_CMD_DATAEXCH_HEAD_LEN,
  2647                                             priv->ops->tx_tail_len);

We changed this to return error pointers as well as NULL.  When
functions return a NULL as well as error pointers, then NULL is supposed
to be a special case of success but here it's just a failure.  That's
messy and bug prone.

  2648          if (!priv->nfc_dev) {
  2649                  rc = -ENOMEM;
  2650                  goto destroy_wq;
  2651          }
  2652  
  2653          nfc_set_parent_dev(priv->nfc_dev, parent);
                                   ^^^^^^^^^^^^^
Oops.

  2654          nfc_set_drvdata(priv->nfc_dev, priv);
  2655  
  2656          rc = nfc_register_device(priv->nfc_dev);
  2657          if (rc)
  2658                  goto free_nfc_dev;

regards,
dan carpenter
