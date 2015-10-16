Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52835 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbJPElv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:41:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 36/40] staging: wilc1000: move variable clients_count
Date: Fri, 16 Oct 2015 13:38:06 +0900
Message-ID: <1444970290-17609-36-git-send-email-tony.cho@atmel.com> (sfid-20151016_064657_591177_15874B3F)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch move static variable clients_count to local variable position.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e6c4da3..5006f5d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -260,6 +260,7 @@ static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 inactive_time;
 static u8 del_beacon;
+static u32 clients_count;
 
 static u8 *join_req;
 static u8 *info_element;
@@ -4175,8 +4176,6 @@ void host_int_send_network_info_to_host
 {
 }
 
-static u32 clients_count;
-
 s32 host_int_init(struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
-- 
1.9.1

