Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37731 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbbDITyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 15:54:17 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/2] staging: vt6655: implement IEEE80211_TX_STAT_NOACK_TRANSMITTED
Date: Thu,  9 Apr 2015 20:53:44 +0100
Message-Id: <1428609224-3237-2-git-send-email-tvboxspy@gmail.com> (sfid-20150409_215422_697853_471D6CBA)
In-Reply-To: <1428609224-3237-1-git-send-email-tvboxspy@gmail.com>
References: <1428609224-3237-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of this macro for non ack frames.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v4.0
---
 drivers/staging/vt6655/device_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8f48c84..521d44f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -912,7 +912,11 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 
 	if (!(tsr1 & TSR1_TERR)) {
 		info->status.rates[0].idx = idx;
-		info->flags |= IEEE80211_TX_STAT_ACK;
+
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+		else
+			info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
 	return 0;
-- 
2.1.0

