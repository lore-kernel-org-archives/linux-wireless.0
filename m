Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60962 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBMTKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 14:10:17 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath10k:  do not ratelimit ath10k_warn messages
Date: Thu, 13 Feb 2014 11:09:22 -0800
Message-Id: <1392318562-32440-2-git-send-email-greearb@candelatech.com> (sfid-20140213_201035_897902_D6EB16A3)
In-Reply-To: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

These are too important to miss, and if we ever do have some
that are overly verbose, could ratelimit the call to ath10k_warn
instead of doing the ratelimit inside of ath10k_warn.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6debd28..c922e39 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -89,8 +89,7 @@ int ath10k_warn(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 
-	if (net_ratelimit())
-		ret = ath10k_printk(KERN_WARNING, "%pV", &vaf);
+	ret = ath10k_printk(KERN_WARNING, "%pV", &vaf);
 
 	trace_ath10k_log_warn(&vaf);
 
-- 
1.7.11.7

