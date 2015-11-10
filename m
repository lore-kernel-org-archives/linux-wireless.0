Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58850 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJXm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:42:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/20] staging/wilc1000: add struct net_device declaration
Date: Wed, 11 Nov 2015 00:42:21 +0100
Message-Id: <1447198960-2760143-2-git-send-email-arnd@arndb.de> (sfid-20151111_004913_181283_00F3EF95)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent cleanup added a reference to struct net_device, but
that structure is not always visible in the context of the
declaration, so we may get a compile-time error:

In file included from wilc1000/host_interface.c:5:0:
wilc1000/host_interface.h:705:46: warning: 'struct net_device' declared inside parameter list
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);

This adds a forward-declaration for the structure name to avoid
that error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: d5382219138d ("staging: wilc1000: host_int_init: add argument net_device")
---
 drivers/staging/wilc1000/host_interface.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 57e1d424afdc..29a92d690384 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -369,6 +369,7 @@ s32 host_int_scan(struct host_if_drv *hWFIDrv, u8 u8ScanSource,
 s32 hif_set_cfg(struct host_if_drv *hWFIDrv,
 		struct cfg_param_val *pstrCfgParamVal);
 s32 hif_get_cfg(struct host_if_drv *hWFIDrv, u16 u16WID, u16 *pu16WID_Value);
+struct net_device;
 s32 host_int_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 host_int_deinit(struct host_if_drv *hWFIDrv);
 s32 host_int_add_beacon(struct host_if_drv *hWFIDrv, u32 u32Interval,
-- 
2.1.0.rc2

