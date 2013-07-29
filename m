Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45610 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3G2OsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 10:48:16 -0400
Date: Mon, 29 Jul 2013 17:47:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: handle driver initialization error paths
Message-ID: <20130729144754.GA7601@elgon.mountain> (sfid-20130729_164825_453420_4710C250)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Amitkumar Karwar,

The patch 6b41f941d7cd: "mwifiex: handle driver initialization error 
paths" from Jul 22, 2013, leads to the following warning:
"drivers/net/wireless/mwifiex/main.c:533 mwifiex_fw_dpc()
	 warn: 'adapter' was already freed."

drivers/net/wireless/mwifiex/main.c
   529          adapter->surprise_removed = true;
   530          mwifiex_terminate_workqueue(adapter);
   531          mwifiex_free_adapter(adapter);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Free.
   532  done:
   533          if (adapter->cal_data) {
                    ^^^^^^^^^^^^^^^^^
Dereference.
   534                  release_firmware(adapter->cal_data);
   535                  adapter->cal_data = NULL;
   536          }

regards,
dan carpenter

