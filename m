Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:44202 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032596AbbKEHJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 02:09:05 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fix kbuild test robot error
Date: Thu, 5 Nov 2015 16:12:08 +0900
Message-ID: <1446707528-9443-1-git-send-email-glen.lee@atmel.com> (sfid-20151105_080932_476116_D8B48389)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes build warning and error reported by kbuild test robot.
It is fixed by including netdevice.h.

>> drivers/staging/wilc1000/wilc_wlan_if.h:940:27: warning: 'struct net_device'
 declared inside parameter list
    int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp);
>> drivers/staging/wilc1000/wilc_wlan_if.h:940:27: warning: its scope is only
 this definition or declaration, which is probably not what you want
>> drivers/staging/wilc1000/wilc_wlan.c:1954:5: error: conflicting types for
 'wilc_wlan_init'
    int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)

Fixes: 30135ce ("staging: wilc1000: wilc_wlan_init: add argument struct net_device")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index f11003d..12cbc4b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -12,6 +12,7 @@
 
 #include <linux/semaphore.h>
 #include "linux_wlan_common.h"
+#include <linux/netdevice.h>
 
 /********************************************
  *
-- 
1.9.1

