Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36695 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/73] staging: wilc1000: remove typedef of struct Pending_Acks_info_t
Date: Fri, 6 Nov 2015 11:12:37 +0900
Message-ID: <1446776014-28094-16-git-send-email-glen.lee@atmel.com> (sfid-20151106_033759_081499_0BD90CAE)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef of struct Pending_Acks_info_t.
And, rename the Pending_Acks_info_t to pending_acks_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4aec892..fb0e635 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -202,11 +202,11 @@ struct ack_session_info {
 	u16 status;
 };
 
-typedef struct {
+struct pending_acks_info {
 	u32 ack_num;
 	u32 Session_index;
 	struct txq_entry_t  *txqe;
-} Pending_Acks_info_t;
+};
 
 struct ack_session_info *Free_head;
 struct ack_session_info *Alloc_head;
@@ -216,7 +216,7 @@ struct ack_session_info *Alloc_head;
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
 struct ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
-Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
+struct pending_acks_info Pending_Acks_info[MAX_PENDING_ACKS];
 
 u32 PendingAcks_arrBase;
 u32 Opened_TCP_session;
-- 
1.9.1

