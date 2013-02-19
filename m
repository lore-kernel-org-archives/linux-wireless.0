Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63066 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab3BSKIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 05:08:48 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so2179956pbc.28
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 02:08:48 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, linville@tuxdriver.com,
	johannes@sipsolutions.net, sachin.kamat@linaro.org
Subject: [PATCH 1/1] net: rfkill: Fix sparse warning in rfkill-regulator.c
Date: Tue, 19 Feb 2013 15:27:48 +0530
Message-Id: <1361267868-2316-1-git-send-email-sachin.kamat@linaro.org> (sfid-20130219_110858_996294_EBEC3461)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'rfkill_regulator_ops' is used only in this file. Hence make it static.
Silences the following warning:
net/rfkill/rfkill-regulator.c:54:19: warning:
symbol 'rfkill_regulator_ops' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 net/rfkill/rfkill-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill-regulator.c b/net/rfkill/rfkill-regulator.c
index 4b5ab21..d11ac79 100644
--- a/net/rfkill/rfkill-regulator.c
+++ b/net/rfkill/rfkill-regulator.c
@@ -51,7 +51,7 @@ static int rfkill_regulator_set_block(void *data, bool blocked)
 	return 0;
 }
 
-struct rfkill_ops rfkill_regulator_ops = {
+static struct rfkill_ops rfkill_regulator_ops = {
 	.set_block = rfkill_regulator_set_block,
 };
 
-- 
1.7.4.1

