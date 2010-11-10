Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25299 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0KJMYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:24:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:23:54 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 3/5] ath9k_common: Add HTC field length if order bit is set.
Date: Wed, 10 Nov 2010 17:53:47 +0530
Message-ID: <1289391829-8577-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 48b07c3..2e56200 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -36,6 +36,8 @@ int ath9k_cmn_padpos(__le16 frame_control)
 	if (ieee80211_is_data_qos(frame_control)) {
 		padpos += IEEE80211_QOS_CTL_LEN;
 	}
+	if (ieee80211_has_order(frame_control))
+		padpos += IEEE80211_QOS_HTC_LEN;
 
 	return padpos;
 }
-- 
1.6.3.3

