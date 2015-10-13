Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2562 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbJMKv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:29 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/54] staging: wilc1000: rename u8seqlen of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:33 +0900
Message-ID: <1444733419-17679-8-git-send-email-tony.cho@atmel.com> (sfid-20151013_125135_536528_FE332DE1)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8seqlen of struct host_if_wpa_attr to seq_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eb4e03b..5c8af19 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -69,7 +69,7 @@ struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
 	u8 *seq;
-	u8 u8seqlen;
+	u8 seq_len;
 	u8 u8keyidx;
 	u8 u8Keylen;
 	u8 u8Ciphermode;
@@ -3436,7 +3436,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 	msg.body.key_info.attr.wpa.u8keyidx = u8KeyIdx;
 	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
-	msg.body.key_info.attr.wpa.u8seqlen = u32KeyRSClen;
+	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

