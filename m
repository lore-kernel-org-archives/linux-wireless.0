Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53322 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaIDWJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 18:09:33 -0400
Received: by mail-wi0-f182.google.com with SMTP id z2so1948246wiv.9
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 15:09:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6656: remove rate_control_algorithm pid
Date: Thu,  4 Sep 2014 23:08:37 +0100
Message-Id: <1409868517-4270-2-git-send-email-tvboxspy@gmail.com> (sfid-20140905_000936_256588_BA7150C5)
In-Reply-To: <1409868517-4270-1-git-send-email-tvboxspy@gmail.com>
References: <1409868517-4270-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rate control algorithm pid was removed from wireless tree

The device defaults to algorithm 'minstrel_ht'

There has been no problems using this algorithm.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 422fcba..2fbff90 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -993,7 +993,6 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_TIMING_BEACON_ONLY;
 
-	priv->hw->rate_control_algorithm = "pid";
 	priv->hw->max_signal = 100;
 
 	SET_IEEE80211_DEV(priv->hw, &intf->dev);
-- 
1.9.1

