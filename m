Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:46950 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeCMJnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 05:43:00 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, vbabu3@visteon.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: destroy initialized mutex object
Date: Tue, 13 Mar 2018 15:12:10 +0530
Message-Id: <20180313094210.10305-1-hariprasath.elango@gmail.com> (sfid-20180313_104312_671628_63008355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

A mutex object that is initialized but not destroyed.This patch destroys
the mutex object

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 205304c..c901108 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2303,6 +2303,7 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	op_ifcs--;
 
+	mutex_destroy(&priv->scan_req_lock);
 	ret = wilc_deinit(vif);
 
 	clear_shadow_scan();
-- 
2.10.0.GIT
