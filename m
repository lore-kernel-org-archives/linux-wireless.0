Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48140 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdBWKqa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 05:46:30 -0500
Date: Thu, 23 Feb 2017 13:45:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: thierry.escande@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC Digital: Add target NFC-DEP support
Message-ID: <20170223104509.GB27526@mwanda> (sfid-20170223_114826_747274_167FECF1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Thierry Escande,

The patch 1c7a4c24fbfd: "NFC Digital: Add target NFC-DEP support"
from Sep 19, 2013, leads to the following static checker warning:

	net/nfc/digital_dep.c:1303 digital_tg_recv_dep_req()
	error: double free of 'resp'

net/nfc/digital_dep.c
  1287  
  1288                  goto free_resp;
  1289          }
  1290  
  1291          rc = nfc_tm_data_received(ddev->nfc_dev, resp);

This function does a kfree_skb() on the error path.  I don't know about
the success path.  Other code seems to assume it frees on success so
maybe?

  1292  
  1293  exit:
  1294          kfree_skb(ddev->chaining_skb);
  1295          ddev->chaining_skb = NULL;
  1296  
  1297          ddev->atn_count = 0;
  1298  
  1299          kfree_skb(ddev->saved_skb);
  1300          ddev->saved_skb = NULL;
  1301  
  1302          if (rc)
  1303                  kfree_skb(resp);

Of course kfree_skb() is refcounted but I think this has to be a bug.

  1304  
  1305          return;
  1306  
  1307  free_resp:
  1308          dev_kfree_skb(resp);

But then we do dev_kfree_skb() here.  It's not clear to me why sometimes
we use regular kfree_skb() but not here.

  1309  }

regards,
dan carpenter
