Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50172 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3LBU7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:45 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so5526741wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:44 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/13] iwlwifi: mvm: rs: reduce min failures to end test window
Date: Mon,  2 Dec 2013 22:59:14 +0200
Message-Id: <1386017965-13641-2-git-send-email-egrumbach@gmail.com> (sfid-20131202_220014_884300_7306A857)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This terminates a test window of a new rate quicker in case
we've hit a bad rate and should recover better.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0655209..ecf24cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -47,7 +47,7 @@
 #define IWL_HT_NUMBER_TRY   3
 
 #define IWL_RATE_MAX_WINDOW		62	/* # tx in history window */
-#define IWL_RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
+#define IWL_RATE_MIN_FAILURE_TH		3	/* min failures to calc tpt */
 #define IWL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
 
 /* max allowed rate miss before sync LQ cmd */
-- 
1.7.9.5

