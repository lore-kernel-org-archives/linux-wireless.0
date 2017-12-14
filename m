Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdLNIJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 03:09:06 -0500
Date: Thu, 14 Dec 2017 11:02:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76: add driver code for MT76x2e
Message-ID: <20171214080237.x3eiqxafn2kjfwor@mwanda> (sfid-20171214_090914_783636_C55297E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix Fietkau,

This is a semi-automatic email about new static checker warnings.

The patch 7bc04215a66b: "mt76: add driver code for MT76x2e" from Nov 
21, 2017, leads to the following Smatch complaint:

    drivers/net/wireless/mediatek/mt76/mt76x2_main.c:457 mt76x2_ampdu_action()
    warn: variable dereferenced before check 'txq' (see line 453)

drivers/net/wireless/mediatek/mt76/mt76x2_main.c
   452		struct ieee80211_txq *txq = sta->txq[params->tid];
   453		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
                                                            ^^^^^^^^^^^^^
Unchecked dereference.  Also the cast is has a checkpatch a space issue.
No space after the cast, because casting is a high precedence operation.

   454		u16 tid = params->tid;
   455		u16 *ssn = &params->ssn;
   456	
   457		if (!txq)
                     ^^^
Check is too late.

   458			return -EINVAL;
   459	

regards,
dan carpenter
