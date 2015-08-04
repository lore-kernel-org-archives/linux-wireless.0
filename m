Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35981 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbHDT7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 15:59:44 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging: wilc1000: Remove typedefs for struct
Date: Wed,  5 Aug 2015 01:29:22 +0530
Message-Id: <1438718362-11269-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150804_220001_056269_B19FC663)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linux kernel coding style guidelines suggest not using typedefs for
structure and enum types. This patch gets rid of the typedefs for
Ack_session_info_t.

The following Coccinelle semantic patch detects the cases for struct type:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index def72fd..1eb13f9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -291,13 +291,13 @@ uint32_t Statisitcs_totalAcks = 0, Statisitcs_DroppedAcks = 0;
 
 #ifdef	TCP_ACK_FILTER
 struct Ack_session_info;
-typedef struct Ack_session_info {
+struct Ack_session_info {
 	uint32_t Ack_seq_num;
 	uint32_t Bigger_Ack_num;
 	uint16_t src_port;
 	uint16_t dst_port;
 	uint16_t status;
-} Ack_session_info_t;
+};
 
 typedef struct {
 	uint32_t ack_num;
@@ -318,7 +318,7 @@ struct Ack_session_info *Alloc_head;
 
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
-Ack_session_info_t Acks_keep_track_info[2 * MAX_TCP_SESSION];
+struct Ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
 Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
 
 uint32_t PendingAcks_arrBase;
-- 
2.1.0

