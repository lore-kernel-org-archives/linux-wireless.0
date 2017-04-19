Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27709 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762917AbdDSMWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 08:22:17 -0400
Date: Wed, 19 Apr 2017 15:22:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] NFC Digital: Add target NFC-DEP support
Message-ID: <20170419122205.nnzflximmxe22sd5@mwanda> (sfid-20170419_142221_857899_CF2519FE)
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
  1290  
  1291          rc = nfc_tm_data_received(ddev->nfc_dev, resp);
                                                         ^^^^
resp is freed on error here.

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
                        ^^^^^^^^^^^^^^^
Leading to a double free here, I think.

  1304  
  1305          return;
  1306  
  1307  free_resp:
  1308          dev_kfree_skb(resp);
  1309  }

regards,
dan carpenter
