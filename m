Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37427 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EJCdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 22:33:20 -0400
Received: by yenm10 with SMTP id m10so1012087yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 19:33:20 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: dmitry.tarnyagin@stericsson.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] cw1200: use != instead of ^ for comparison
Date: Wed,  9 May 2012 22:32:34 -0400
Message-Id: <1336617155-7455-2-git-send-email-me@bobcopeland.com> (sfid-20120510_043324_215183_30E33074)
In-Reply-To: <1336617155-7455-1-git-send-email-me@bobcopeland.com>
References: <1336617155-7455-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compiler output is the same but "!=" is a bit more obvious.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/staging/cw1200/sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cw1200/sta.c b/drivers/staging/cw1200/sta.c
index cc9ed7b..42bca38 100644
--- a/drivers/staging/cw1200/sta.c
+++ b/drivers/staging/cw1200/sta.c
@@ -581,7 +581,7 @@ void cw1200_configure_filter(struct ieee80211_hw *dev,
 			(FIF_BCN_PRBRESP_PROMISC |
 			 FIF_PROMISC_IN_BSS |
 			 FIF_PROBE_REQ)) ? 1 : 0;
-	if (priv->listening ^ listening) {
+	if (priv->listening != listening) {
 		priv->listening = listening;
 		wsm_lock_tx(priv);
 		cw1200_update_listening(priv, listening);
-- 
1.7.6

