Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50020 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaF2Tk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 15:40:29 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so7162092wes.36
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 12:40:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6656: s_nsBulkOutIoCompleteWrite fix bug of 5GHZ a rates idx
Date: Sun, 29 Jun 2014 20:39:55 +0100
Message-Id: <1404070795-3034-2-git-send-email-tvboxspy@gmail.com> (sfid-20140629_214033_704773_DFB6771B)
In-Reply-To: <1404070795-3034-1-git-send-email-tvboxspy@gmail.com>
References: <1404070795-3034-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2GHz band the values of wCurrentRate match the idx rates.

However, on 5GHz they do not because in channel.c vnt_rates_a do not
match idx.

Instead use the info->control.rates[0].idx the value that was tried.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 428193e..c5d4047 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -419,9 +419,14 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	}
 
 	if (context->skb) {
+		s8 idx;
+
 		info = IEEE80211_SKB_CB(context->skb);
+
+		idx = info->control.rates[0].idx;
+
 		ieee80211_tx_info_clear_status(info);
-		info->status.rates[0].idx = priv->wCurrentRate;
+		info->status.rates[0].idx = idx;
 		info->status.rates[0].count = 0;
 		if (!urb->status)
 			info->flags |= IEEE80211_TX_STAT_ACK;
-- 
1.9.1

