Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34512 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbIPLLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:51 -0400
Received: by padhy16 with SMTP id hy16so206852202pad.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/10] staging: wilc1000: replace __inline with inline
Date: Wed, 16 Sep 2015 20:11:29 +0900
Message-Id: <1442401895-7463-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131154_365497_6CB967A1)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces __inline with inline. plain inline is more
preferred than __inline.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a3e6973..d27ef47 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -317,13 +317,13 @@ u32 Pending_Acks;
 
 
 
-static __inline int Init_TCP_tracking(void)
+static inline int Init_TCP_tracking(void)
 {
 
 	return 0;
 
 }
-static __inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
+static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	Acks_keep_track_info[Opened_TCP_session].Ack_seq_num = seq;
 	Acks_keep_track_info[Opened_TCP_session].Bigger_Ack_num = 0;
@@ -335,7 +335,7 @@ static __inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 	return 0;
 }
 
-static __inline int Update_TCP_track_session(u32 index, u32 Ack)
+static inline int Update_TCP_track_session(u32 index, u32 Ack)
 {
 
 	if (Ack > Acks_keep_track_info[index].Bigger_Ack_num) {
@@ -344,7 +344,7 @@ static __inline int Update_TCP_track_session(u32 index, u32 Ack)
 	return 0;
 
 }
-static __inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
+static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
 	Statisitcs_totalAcks++;
 	if (Pending_Acks < MAX_PENDING_ACKS) {
@@ -359,7 +359,7 @@ static __inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_e
 	}
 	return 0;
 }
-static __inline int remove_TCP_related(void)
+static inline int remove_TCP_related(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
@@ -370,7 +370,7 @@ static __inline int remove_TCP_related(void)
 	return 0;
 }
 
-static __inline int tcp_process(struct txq_entry_t *tqe)
+static inline int tcp_process(struct txq_entry_t *tqe)
 {
 	int ret;
 	u8 *eth_hdr_ptr;
-- 
2.5.1

