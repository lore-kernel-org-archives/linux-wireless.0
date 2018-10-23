Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837FDC67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FEDA2064C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 03:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FEDA2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbeJWLqU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 07:46:20 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56077 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbeJWLqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 07:46:20 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9N3Omiq022436, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9N3Omiq022436
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 23 Oct 2018 11:24:48 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Tue, 23 Oct 2018 11:24:48 +0800
From:   <yhchuang@realtek.com>
To:     <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix GFP_KERNEL under tasklet context
Date:   Tue, 23 Oct 2018 11:24:44 +0800
Message-ID: <1540265084-13808-1-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

cfg80211_sta_opmode_change_notify needs a gfp_t flag to hint the nl80211
stack when allocating new skb, but it is called under tasklet context
here with GFP_KERNEL and kernel will yield a warning about it.

Fixes: ff84e7bfe176 ("mac80211: Add support to notify ht/vht opmode modification.")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 net/mac80211/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 64742f2..03d3964f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3028,7 +3028,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			cfg80211_sta_opmode_change_notify(sdata->dev,
 							  rx->sta->addr,
 							  &sta_opmode,
-							  GFP_KERNEL);
+							  GFP_ATOMIC);
 			goto handled;
 		}
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
@@ -3065,7 +3065,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			cfg80211_sta_opmode_change_notify(sdata->dev,
 							  rx->sta->addr,
 							  &sta_opmode,
-							  GFP_KERNEL);
+							  GFP_ATOMIC);
 			goto handled;
 		}
 		default:
-- 
2.7.4

