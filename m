Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11441 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755470AbcIKN0W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Sep 2016 09:26:22 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/26] ath: constify local structures
Date: Sun, 11 Sep 2016 15:05:48 +0200
Message-Id: <1473599168-30561-7-git-send-email-Julia.Lawall@lip6.fr> (sfid-20160911_153518_342101_F73B21E7)
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For structure types defined in the same file or local header files, find
top-level static structure declarations that have the following
properties:
1. Never reassigned.
2. Address never taken
3. Not passed to a top-level macro call
4. No pointer or array-typed field passed to a function or stored in a
variable.
Declare structures having all of these properties as const.

Done using Coccinelle.
Based on a suggestion by Joe Perches <joe@perches.com>.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch seems too long for a commit log, but is in the cover
letter.

 drivers/net/wireless/ath/dfs_pattern_detector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 2f8136d..4100ffd 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -338,7 +338,7 @@ static bool dpd_set_domain(struct dfs_pattern_detector *dpd,
 	return true;
 }
 
-static struct dfs_pattern_detector default_dpd = {
+static const struct dfs_pattern_detector default_dpd = {
 	.exit		= dpd_exit,
 	.set_dfs_domain	= dpd_set_domain,
 	.add_pulse	= dpd_add_pulse,
