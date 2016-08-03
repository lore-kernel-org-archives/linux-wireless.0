Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37996 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbcHCLki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 07:40:38 -0400
Date: Wed, 3 Aug 2016 14:40:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: thierry.escande@collabora.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC: nfcsim: Make use of the Digital layer
Message-ID: <20160803114023.GA23064@mwanda> (sfid-20160803_134045_273689_4C535F24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Thierry Escande,

The patch 204bddcb508f: "NFC: nfcsim: Make use of the Digital layer"
from Jun 23, 2016, leads to the following static checker warning:

	drivers/nfc/nfcsim.c:485 nfcsim_init()
	error: we previously assumed 'link0' could be null (see line 457)

drivers/nfc/nfcsim.c
   450  static int __init nfcsim_init(void)
   451  {
   452          struct nfcsim_link *link0, *link1;
   453          int rc;
   454  
   455          link0 = nfcsim_link_new();
   456          link1 = nfcsim_link_new();
   457          if (!link0 || !link1) {

Say link0 is NULL here.

   458                  rc = -ENOMEM;
   459                  goto exit_err;
   460          }
   461  
   462          nfcsim_debugfs_init();
   463  
   464          dev0 = nfcsim_device_new(link0, link1);
   465          if (IS_ERR(dev0)) {
   466                  rc = PTR_ERR(dev0);
   467                  goto exit_err;
   468          }
   469  
   470          dev1 = nfcsim_device_new(link1, link0);
   471          if (IS_ERR(dev1)) {
   472                  nfcsim_device_free(dev0);
   473  
   474                  rc = PTR_ERR(dev1);
   475                  goto exit_err;
   476          }
   477  
   478          pr_info("nfcsim " NFCSIM_VERSION " initialized\n");
   479  
   480          return 0;
   481  
   482  exit_err:
   483          pr_err("Failed to initialize nfcsim driver (%d)\n", rc);
   484  
   485          nfcsim_link_free(link0);

We oops inside the call to nfcsim_link_free().

   486          nfcsim_link_free(link1);
   487  
   488          return rc;
   489  }


regards,
dan carpenter
