Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17881 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbASOwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 09:52:50 -0500
Date: Mon, 19 Jan 2015 17:53:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: qca_vkondrat@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: re: wil6210: ADDBA/DELBA flows
Message-ID: <20150119145332.GA19489@mwanda> (sfid-20150119_155253_563523_A66D0231)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Vladimir Kondratiev,

The patch 3277213feb1b: "wil6210: ADDBA/DELBA flows" from Dec 23,
2014, leads to the following static checker warning:

	drivers/net/wireless/ath/wil6210/rx_reorder.c:205 wil_tid_ampdu_rx_alloc()
	error: scheduling with locks held: 'spin_lock:tid_rx_lock'

drivers/net/wireless/ath/wil6210/rx_reorder.c
   202  struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
   203                                                  int size, u16 ssn)
   204  {
   205          struct wil_tid_ampdu_rx *r = kzalloc(sizeof(*r), GFP_KERNEL);
                                                                 ^^^^^^^^^^
   206  
   207          if (!r)
   208                  return NULL;
   209  
   210          r->reorder_buf =
   211                  kcalloc(size, sizeof(struct sk_buff *), GFP_KERNEL);
                                                                ^^^^^^^^^^^
   212          r->reorder_time =
   213                  kcalloc(size, sizeof(unsigned long), GFP_KERNEL);
                                                             ^^^^^^^^^^^
   214          if (!r->reorder_buf || !r->reorder_time) {
   215                  kfree(r->reorder_buf);
   216                  kfree(r->reorder_time);
   217                  kfree(r);
   218                  return NULL;
   219          }
   220  

[ snip ]

   331          spin_lock_bh(&sta->tid_rx_lock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
spin lock held.

   332  
   333          wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
   334          sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function called with the lock held.

   335  
   336          spin_unlock_bh(&sta->tid_rx_lock);

This looks like it would be pretty easy to re-write so the allocation
was done before we take the lock if someone knew exactly what the lock
was protecting.

regards,
dan carpenter
