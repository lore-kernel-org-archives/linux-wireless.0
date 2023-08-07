Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696FFC001B0
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Aug 2023 14:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbjHGOus (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Aug 2023 10:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjHGOur (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2023 10:50:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101D10FD;
        Mon,  7 Aug 2023 07:50:45 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RKK0c73clzNmqK;
        Mon,  7 Aug 2023 22:47:12 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 22:50:40 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <horms@kernel.org>
Subject: [PATCH v3] wifi: iw_handler.h: Remove unused declaration dev_get_wireless_info()
Date:   Mon, 7 Aug 2023 22:50:32 +0800
Message-ID: <20230807145032.44768-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 556829657397 ("[NL80211]: add netlink interface to cfg80211")
declared but never implemented this, remove it.
Commit 11433ee450eb ("[WEXT]: Move to net/wireless") rename net/core/wireless.c
to net/wireless/wext.c, then commit 3d23e349d807 ("wext: refactor") refactor
wext.c to wext-core.c, fix the wext comment.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
v3: add commit log about comment fixup
v2: fix wext comment
---
 include/net/iw_handler.h | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index d2ea5863eedc..b2cf243ebe44 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -426,17 +426,10 @@ struct iw_public_data {
 
 /**************************** PROTOTYPES ****************************/
 /*
- * Functions part of the Wireless Extensions (defined in net/core/wireless.c).
- * Those may be called only within the kernel.
+ * Functions part of the Wireless Extensions (defined in net/wireless/wext-core.c).
+ * Those may be called by driver modules.
  */
 
-/* First : function strictly used inside the kernel */
-
-/* Handle /proc/net/wireless, called in net/code/dev.c */
-int dev_get_wireless_info(char *buffer, char **start, off_t offset, int length);
-
-/* Second : functions that may be called by driver modules */
-
 /* Send a single event to user space */
 void wireless_send_event(struct net_device *dev, unsigned int cmd,
 			 union iwreq_data *wrqu, const char *extra);
-- 
2.34.1

