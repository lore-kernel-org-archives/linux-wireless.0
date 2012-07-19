Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34784 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2GSLgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:36:36 -0400
Date: Thu, 19 Jul 2012 14:36:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: chunkeey@googlemail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: carl9170: improve unicast PS buffering
Message-ID: <20120719113628.GA32727@elgon.mountain> (sfid-20120719_133640_635709_8B96D558)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian Lamparter,

Sorry this is so old.  I was going through some old Smatch warnings.

This is a semi-automatic email about new static checker warnings.

The patch caf1eae20668: "carl9170: improve unicast PS buffering" from 
Apr 24, 2011, leads to the following Smatch complaint:

drivers/net/wireless/ath/carl9170/tx.c:1488 carl9170_op_tx()
	 error: we previously assumed 'sta' could be null (see line 1482)

drivers/net/wireless/ath/carl9170/tx.c
  1481	
  1482		if (sta) {
                   ^^^^^
New check.

  1483			struct carl9170_sta_info *stai = (void *) sta->drv_priv;
  1484			atomic_inc(&stai->pending_frames);
  1485		}
  1486	
  1487		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
  1488			run = carl9170_tx_ampdu_queue(ar, sta, skb);
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Old dereference of "sta" inside the call to carl9170_tx_ampdu_queue().

  1489			if (run)
  1490				carl9170_tx_ampdu(ar);

Probably we can remove the check?

regards,
dan carpenter

