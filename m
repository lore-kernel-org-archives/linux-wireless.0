Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:58221 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbXK0TmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:42:03 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1086541nfb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:42:01 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/11] rt2x00: Cleanup rfkill
Date: Tue, 27 Nov 2007 21:51:57 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272151.57802.IvDoorn@gmail.com> (sfid-20071127_194250_980434_CBD5936F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The label exit_free_polldev is no longer used and can be removed.
input_free_polled_device() also calls input_free_device(), so
don't call it seperatly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 7439637..34a96d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -148,9 +148,6 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 
-exit_free_polldev:
-	input_free_polled_device(rt2x00dev->poll_dev);
-
 exit_free_rfkill:
 	rfkill_free(rt2x00dev->rfkill);
 
@@ -163,7 +160,6 @@ void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
-	input_free_device(rt2x00dev->poll_dev->input);
 	input_free_polled_device(rt2x00dev->poll_dev);
 	rfkill_free(rt2x00dev->rfkill);
 }
-- 
1.5.3.6

