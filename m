Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39361 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 22:31:28 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] wireless: ipw2x00: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 13:45:49 -0700
Message-Id: <20180920204548.2405-1-natechancellor@gmail.com> (sfid-20180920_224620_110030_1B9DD798)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: warning: equality
comparison with extraneous parentheses [-Wparentheses-equality]
                if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
                     ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: remove
extraneous parentheses around the comparison to silence this warning
                if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
                    ~                    ^               ~
drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: use '=' to
turn this equality comparison into an assignment
                if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
                                         ^~
                                         =
1 warning generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/134
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 9644e7b93645..bbdca13c5a9f 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -5652,7 +5652,7 @@ static void ipw_merge_adhoc_network(struct work_struct *work)
 		}
 
 		mutex_lock(&priv->mutex);
-		if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
+		if (priv->ieee->iw_mode == IW_MODE_ADHOC) {
 			IPW_DEBUG_MERGE("remove network %*pE\n",
 					priv->essid_len, priv->essid);
 			ipw_remove_current_network(priv);
-- 
2.19.0
