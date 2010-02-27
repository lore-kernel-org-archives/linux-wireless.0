Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968669Ab0B0RDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 12:03:23 -0500
Received: by pwj8 with SMTP id 8so759038pwj.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 09:03:22 -0800 (PST)
From: tom.leiming@gmail.com
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	stable@kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ath9k: decrease size of ath9k.ko
Date: Sun, 28 Feb 2010 00:56:43 +0800
Message-Id: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

The patch defines the fields of 'valid_single_stream' and 'valid' in
struct ath_rate_table as char type, so decrease the size of ath9k.ko
about 2KB.

old ath9k.ko
[tom@tom-lei ath9k]$ size ath9k.ko
   text    data     bss     dec     hex filename
  69344    3080     168   72592   11b90 ath9k.ko

new ath9k.ko
[tom@tom-lei ath9k]$ size ath9k.ko
   text    data     bss     dec     hex filename
  67304    3080     168   70552   11398 ath9k.ko

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/rc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 4f6d6fd..389168a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -110,8 +110,8 @@ struct ath_rate_table {
 	int rate_cnt;
 	int mcs_start;
 	struct {
-		int valid;
-		int valid_single_stream;
+		char valid;
+		char valid_single_stream;
 		u8 phy;
 		u32 ratekbps;
 		u32 user_ratekbps;
-- 
1.6.2.5

