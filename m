Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36573 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327AbZEUDEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 23:04:32 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 1/3] rfkill: add missing static
Date: Thu, 21 May 2009 00:04:17 -0300
Message-Id: <1242875059-9627-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
References: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse says:
  CHECK   net/rfkill/core.c
net/rfkill/core.c:430:6: warning: symbol '__rfkill_set_sw_state' was not declared. Should it be static?

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 net/rfkill/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 6991a41..9fd72ea 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -427,7 +427,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 }
 EXPORT_SYMBOL(rfkill_set_hw_state);
 
-void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 {
 	u32 bit = RFKILL_BLOCK_SW;
 
-- 
1.6.3.1

