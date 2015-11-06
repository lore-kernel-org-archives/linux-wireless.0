Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36850 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:54 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/73] staging: wilc1000: rename add_TCP_track_session function
Date: Fri, 6 Nov 2015 11:12:45 +0900
Message-ID: <1446776014-28094-24-git-send-email-glen.lee@atmel.com> (sfid-20151106_033758_759412_69AB6001)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the add_TCP_track_session function to add_tcp_session
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index df0f5ce..75b35b8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -227,7 +227,7 @@ static inline int init_tcp_tracking(void)
 	return 0;
 }
 
-static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
+static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	ack_session_info[tcp_session].seq_num = seq;
 	ack_session_info[tcp_session].bigger_ack_num = 0;
@@ -319,7 +319,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 					}
 				}
 				if (i == tcp_session)
-					add_TCP_track_session(0, 0, seq_no);
+					add_tcp_session(0, 0, seq_no);
 
 				add_TCP_Pending_Ack(Ack_no, i, tqe);
 			}
-- 
1.9.1

