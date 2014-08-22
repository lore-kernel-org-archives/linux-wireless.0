Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50490 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaHVVfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 17:35:53 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so270045wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 14:35:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/3] staging: vt6655: rxtx.h structure vnt_mic_hdr add IEEE80211_CCMP_PN_LEN macro
Date: Fri, 22 Aug 2014 22:35:10 +0100
Message-Id: <1408743311-13177-2-git-send-email-tvboxspy@gmail.com> (sfid-20140822_233557_271680_5E2ACB40)
In-Reply-To: <1408743311-13177-1-git-send-email-tvboxspy@gmail.com>
References: <1408743311-13177-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ccmp_pn is the size of IEEE80211_CCMP_PN_LEN (6)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 26baf3b..4accb78 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -44,7 +44,7 @@ struct vnt_mic_hdr {
 	u8 id;
 	u8 tx_priority;
 	u8 mic_addr2[ETH_ALEN];
-	u8 ccmp_pn[6];
+	u8 ccmp_pn[IEEE80211_CCMP_PN_LEN];
 	__be16 payload_len;
 	__be16 hlen;
 	__le16 frame_control;
-- 
1.9.1

