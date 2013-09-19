Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:47081 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab3ISHoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 03:44:15 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix tracing of ath10k_wmi_cmd
Date: Thu, 19 Sep 2013 09:44:09 +0200
Message-ID: <1379576649-3947-1-git-send-email-michal.kazior@tieto.com> (sfid-20130919_094419_140158_5534A948)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of my recent patches broke tracing. kbuild
test robot reported this issue.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index fd53130..90817dd 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -119,7 +119,7 @@ TRACE_EVENT(ath10k_wmi_cmd,
 		__field(unsigned int, id)
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
-		__field(int ret)
+		__field(int, ret)
 	),
 
 	TP_fast_assign(
-- 
1.7.9.5

