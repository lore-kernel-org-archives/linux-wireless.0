Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8285 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbJSJ0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:26:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 2/6] staging: wilc1000: move variable clients_count
Date: Mon, 19 Oct 2015 18:26:09 +0900
Message-ID: <1445246773-22253-3-git-send-email-tony.cho@atmel.com> (sfid-20151019_112644_637008_CD80600D)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch moves static variable clients_count to around where the local
variables are togther.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 066123f..c61042e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -254,6 +254,7 @@ static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 inactive_time;
 static u8 del_beacon;
+static u32 clients_count;
 
 static u8 *join_req;
 u8 *info_element;
@@ -4138,8 +4139,6 @@ void host_int_send_network_info_to_host
 {
 }
 
-static u32 clients_count;
-
 s32 host_int_init(struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
-- 
1.9.1

