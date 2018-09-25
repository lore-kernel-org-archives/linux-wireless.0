Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC6AC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C01421480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C01421480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbeIYMaV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:21 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbeIYMaU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:20 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543182"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:21 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:21 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 08/29] staging: wilc1000: change return type to 'void' tcp ack filter functions
Date:   Tue, 25 Sep 2018 11:53:23 +0530
Message-ID: <1537856624-22157-9-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use 'void' return type for below functions as they always return '0' and
their return value is not used by caller.
add_tcp_pending_ack()
update_tcp_session()
add_tcp_pending_ack()

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8057db9..66ce29d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -91,8 +91,8 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 
 #define NOT_TCP_ACK			(-1)
 
-static inline int add_tcp_session(struct wilc_vif *vif, u32 src_prt,
-				  u32 dst_prt, u32 seq)
+static inline void add_tcp_session(struct wilc_vif *vif, u32 src_prt,
+				   u32 dst_prt, u32 seq)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 
@@ -103,22 +103,20 @@ static inline int add_tcp_session(struct wilc_vif *vif, u32 src_prt,
 		f->ack_session_info[f->tcp_session].dst_port = dst_prt;
 		f->tcp_session++;
 	}
-	return 0;
 }
 
-static inline int update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
+static inline void update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 
 	if (index < 2 * MAX_TCP_SESSION &&
 	    ack > f->ack_session_info[index].bigger_ack_num)
 		f->ack_session_info[index].bigger_ack_num = ack;
-	return 0;
 }
 
-static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
-				      u32 session_index,
-				      struct txq_entry_t *txqe)
+static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
+				       u32 session_index,
+				       struct txq_entry_t *txqe)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = f->pending_base + f->pending_acks_idx;
@@ -130,7 +128,6 @@ static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 		txqe->ack_idx = i;
 		f->pending_acks_idx++;
 	}
-	return 0;
 }
 
 static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
-- 
2.7.4

