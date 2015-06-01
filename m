Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:32929 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbFAS4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:56:38 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v2 2/4] staging: wilc1000: Change the prototype of WILC_WFI_init_mon_interface
Date: Mon,  1 Jun 2015 21:56:19 +0300
Message-Id: <1433184981-6077-2-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150601_205708_026760_5DEDCC4E)
In-Reply-To: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WILC_WFI_init_mon_interface() should be declared with 'const char *name',
not simply 'char *name', because this 'name' argument is only passed
as is to alloc_netdev(), and alloc_netdev(), in turn,
expects 'const char *'.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a19be45..f0a20a9 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -522,7 +522,7 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
  *  @date	12 JUL 2012
  *  @version	1.0
  */
-struct net_device *WILC_WFI_init_mon_interface(char *name, struct net_device *real_dev)
+struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev)
 {
 
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 9eb8f37..b63c746 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -123,7 +123,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
 void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size);
 int WILC_WFI_deinit_mon_interface(void);
-struct net_device *WILC_WFI_init_mon_interface(char *name, struct net_device *real_dev);
+struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
 #ifdef TCP_ENHANCEMENTS
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH 54
-- 
1.9.1

