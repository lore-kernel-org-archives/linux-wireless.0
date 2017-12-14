Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdLNIJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 03:09:06 -0500
Date: Thu, 14 Dec 2017 11:02:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mt76: add driver code for MT76x2e
Message-ID: <20171214080158.azjhsjlwluw4iysl@mwanda> (sfid-20171214_090911_863616_60BA6439)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix Fietkau,

This is a semi-automatic email about new static checker warnings.

The patch 7bc04215a66b: "mt76: add driver code for MT76x2e" from Nov 
21, 2017, leads to the following Smatch complaint:

    drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:189 mt76x2_mac_write_txwi()
    error: we previously assumed 'wcid' could be null (see line 180)

drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
   179	
   180		if (wcid)
                    ^^^^
Check for NULL

   181			txwi->wcid = wcid->idx;
   182		else
   183			txwi->wcid = 0xff;
   184	
   185		txwi->pktid = 1;
   186	
   187		spin_lock_bh(&dev->mt76.lock);
   188		if (rate->idx < 0 || !rate->count) {
   189			txwi->rate = wcid->tx_rate;
                                     ^^^^^^^^^^^^^
Unchecked dereference

   190			max_txpwr_adj = wcid->max_txpwr_adj;
   191			nss = wcid->tx_rate_nss;

regards,
dan carpenter
