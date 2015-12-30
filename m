Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:32927 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:35 -0500
Received: by mail-pf0-f178.google.com with SMTP id q63so105583461pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/20] staging: wilc1000: rename u16ipadd in wilc_setup_ipaddress
Date: Wed, 30 Dec 2015 21:15:39 +0900
Message-Id: <1451477744-11975-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132246_625318_A68AAA5D)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16ipadd to ip_addr to remove u16 prefix.
There is no need to use prefix to show data type of this argument.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dacadc9..0d41657 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4638,7 +4638,7 @@ s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 	return result;
 }
 
-int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
+int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4655,7 +4655,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 
 	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
-	msg.body.ip_info.ip_addr = u16ipadd;
+	msg.body.ip_info.ip_addr = ip_addr;
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d36a9f5..f90a530 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -354,7 +354,7 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
-int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
+int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   u32 u32duration, u16 chan,
-- 
2.6.4

