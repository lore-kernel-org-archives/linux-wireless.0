Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcF0QcQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:16 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 04/12] rtl8xxxu: Correct rxdesc16 definition
Date: Mon, 27 Jun 2016 12:32:02 -0400
Message-Id: <1467045130-18874-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183231_757378_5B4D1918)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This corrects the definition of rxdesc16 to correctly specify pkt_cnt
for aggregated packets. This is based on the code of the vendor
rtl8723au driver, as opposed to the struct definitions they use.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d0ccda8..e8158c0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -135,7 +135,8 @@ struct rtl8xxxu_rxdesc16 {
 
 	u32 seq:12;
 	u32 frag:4;
-	u32 nextpktlen:14;
+	u32 pkt_cnt:8;
+	u32 reserved:6;
 	u32 nextind:1;
 	u32 reserved0:1;
 
@@ -198,7 +199,8 @@ struct rtl8xxxu_rxdesc16 {
 
 	u32 reserved0:1;
 	u32 nextind:1;
-	u32 nextpktlen:14;
+	u32 reserved:6;
+	u32 pkt_cnt:8;
 	u32 frag:4;
 	u32 seq:12;
 
-- 
2.7.4

