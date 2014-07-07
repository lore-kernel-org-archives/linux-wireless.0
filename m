Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31598 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaGGP6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 11:58:54 -0400
Date: Mon, 7 Jul 2014 18:58:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: ath6kl: add htc ops
Message-ID: <20140707155851.GA14528@mwanda> (sfid-20140707_175858_099326_AC248174)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle Valo,

This is a semi-automatic email about new static checker warnings.

The patch e76ac2bf637d: "ath6kl: add htc ops" from Mar 25, 2012, 
leads to the following Smatch complaint:

drivers/net/wireless/ath/ath6kl/htc_mbox.c:2886 ath6kl_htc_mbox_create()
	 error: we previously assumed 'target->dev' could be null (see line 2857)

drivers/net/wireless/ath/ath6kl/htc_mbox.c
  2856		target->dev = kzalloc(sizeof(*target->dev), GFP_KERNEL);
  2857		if (!target->dev) {
  2858			ath6kl_err("unable to allocate memory\n");
  2859			status = -ENOMEM;
  2860			goto err_htc_cleanup;

We will hit a NULL dereference in error handling on this path.

  2861		}
  2862	
  2863		spin_lock_init(&target->htc_lock);
  2864		spin_lock_init(&target->rx_lock);
  2865		spin_lock_init(&target->tx_lock);
  2866	
  2867		INIT_LIST_HEAD(&target->free_ctrl_txbuf);
  2868		INIT_LIST_HEAD(&target->free_ctrl_rxbuf);
  2869		INIT_LIST_HEAD(&target->cred_dist_list);
  2870	
  2871		target->dev->ar = ar;
  2872		target->dev->htc_cnxt = target;
  2873		target->ep_waiting = ENDPOINT_MAX;
  2874	
  2875		status = ath6kl_hif_setup(target->dev);
  2876		if (status)
  2877			goto err_htc_cleanup;
  2878	
  2879		status = ath6kl_htc_reset(target);
  2880		if (status)
  2881			goto err_htc_cleanup;
  2882	
  2883		return target;
  2884	
  2885	err_htc_cleanup:
  2886		ath6kl_htc_mbox_cleanup(target);

We can't call ath6kl_htc_mbox_cleanup() with a NULL target->dev pointer.
This is a One Err Bug because there is only one "err" label.

  2887	
  2888		return NULL;

regards,
dan carpenter
