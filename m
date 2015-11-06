Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36986 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:36 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/73] staging: wilc1000: rename Data_offset variable
Date: Fri, 6 Nov 2015 11:12:52 +0900
Message-ID: <1446776014-28094-31-git-send-email-glen.lee@atmel.com> (sfid-20151106_033804_001329_664D3E9D)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Data_offset variable to data_offset
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 34a8b47..6d72e09 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -298,14 +298,14 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 		if (protocol == 0x06) {
 			u8 *tcp_hdr_ptr;
-			u32 IHL, total_length, Data_offset;
+			u32 IHL, total_length, data_offset;
 
 			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
 			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
 			total_length = ((u32)ip_hdr_ptr[2] << 8) +
 					(u32)ip_hdr_ptr[3];
-			Data_offset = (((u32)tcp_hdr_ptr[12] & 0xf0) >> 2);
-			if (total_length == (IHL + Data_offset)) {
+			data_offset = ((u32)tcp_hdr_ptr[12] & 0xf0) >> 2;
+			if (total_length == (IHL + data_offset)) {
 				u32 seq_no, Ack_no;
 
 				seq_no	= (((u32)tcp_hdr_ptr[4]) << 24) + (((u32)tcp_hdr_ptr[5]) << 16) + (((u32)tcp_hdr_ptr[6]) << 8) + ((u32)tcp_hdr_ptr[7]);
-- 
1.9.1

