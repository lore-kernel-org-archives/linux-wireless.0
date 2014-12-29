Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64768 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaL2GYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:19 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so21176159wiv.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:18 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.17
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:17 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/13] wlcore: fix WLCORE_VENDOR_ATTR_GROUP_KEY policy
Date: Mon, 29 Dec 2014 08:24:01 +0200
Message-Id: <1419834253-18331-1-git-send-email-eliad@wizery.com> (sfid-20141229_072423_384413_7EF2CFA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The attribute type is binary data (with max length).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
index ad86a48..fd4e9ba 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -21,7 +21,7 @@ static const
 struct nla_policy wlcore_vendor_attr_policy[NUM_WLCORE_VENDOR_ATTR] = {
 	[WLCORE_VENDOR_ATTR_FREQ]		= { .type = NLA_U32 },
 	[WLCORE_VENDOR_ATTR_GROUP_ID]		= { .type = NLA_U32 },
-	[WLCORE_VENDOR_ATTR_GROUP_KEY]		= { .type = NLA_U32,
+	[WLCORE_VENDOR_ATTR_GROUP_KEY]		= { .type = NLA_BINARY,
 						    .len = WLAN_MAX_KEY_LEN },
 };
 
-- 
1.8.5.2.229.g4448466.dirty

