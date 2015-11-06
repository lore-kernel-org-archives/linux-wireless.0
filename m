Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36634 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/73] staging: wilc1000: rename Ack_session_info struct variable
Date: Fri, 6 Nov 2015 11:12:34 +0900
Message-ID: <1446776014-28094-13-git-send-email-glen.lee@atmel.com> (sfid-20151106_033758_171097_264C80ED)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Ack_session_info struct variable to ack_session_info
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9b1ca17..f3968fd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -193,8 +193,8 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 u32 total_acks = 0, dropped_acks = 0;
 
 #ifdef	TCP_ACK_FILTER
-struct Ack_session_info;
-struct Ack_session_info {
+struct ack_session_info;
+struct ack_session_info {
 	u32 Ack_seq_num;
 	u32 Bigger_Ack_num;
 	u16 src_port;
@@ -208,14 +208,14 @@ typedef struct {
 	struct txq_entry_t  *txqe;
 } Pending_Acks_info_t;
 
-struct Ack_session_info *Free_head;
-struct Ack_session_info *Alloc_head;
+struct ack_session_info *Free_head;
+struct ack_session_info *Alloc_head;
 
 #define NOT_TCP_ACK			(-1)
 
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
-struct Ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
+struct ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
 Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
 
 u32 PendingAcks_arrBase;
-- 
1.9.1

