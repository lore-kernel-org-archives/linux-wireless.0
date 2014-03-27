Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaC0PFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 11:05:14 -0400
Date: Thu, 27 Mar 2014 18:05:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: fariyaf@gmail.com
Cc: Fariya Fatima <fariyaf@gmail.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: re: rsi: Add RS9113 wireless driver
Message-ID: <20140327150501.GA1633@mwanda> (sfid-20140327_160519_350649_F217DDF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Fariya Fatima,

The patch dad0d04fa7ba: "rsi: Add RS9113 wireless driver" from Mar
16, 2014, leads to the following static checker warning:

	drivers/net/wireless/rsi/rsi_91x_mgmt.c:751 rsi_load_bootup_params()
	warn: signedness bug returning '(-12)'

drivers/net/wireless/rsi/rsi_91x_mgmt.c
   741  static u8 rsi_load_bootup_params(struct rsi_common *common)
   742  {
   743          struct sk_buff *skb;
   744          struct rsi_boot_params *boot_params;
   745  
   746          rsi_dbg(MGMT_TX_ZONE, "%s: Sending boot params frame\n", __func__);
   747          skb = dev_alloc_skb(sizeof(struct rsi_boot_params));
   748          if (!skb) {
   749                  rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
   750                          __func__);
   751                  return -ENOMEM;
                               ^^^^^^^
This doesn't matter because the caller doesn't progate the error code
anyway.  Please fix that as well.

	ret = rsi_load_bootup_params(...);
	if (ret)
		return ret;

Instead of:
	if (rsi_load_bootup_params(...))
		erturn -ENOMEM;

   752          }

regards,
dan carpenter
