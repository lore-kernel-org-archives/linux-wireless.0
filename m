Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792593733;
	b=3+6YlGhXfxc/LSOfEWfS7Ff4/Ey77eC1vx+g65MY4M0llmPJ9pjO3xN9e3HJZxg1aJlD
	 DEAVFtv7EjL6qBqjIBcOFg5m2p4W0Ho3xmtekhwIt+TfBio6iGogBMHpwQcjXF4/PlF8a
	 s90UZxRF57rKsevVjeXry4mkRiO2T5zaVUQoKsqAAlY6MtfZ/Cl7hBMJjPrN1HhqbRemP
	 jJej5SNex9VPD+9fy70yXC3CyHk0s0EFkbn6xuiVIB8IK53KbxQ6weJKFC35eO/RS8xOM
	 abWnquYABOW0TCYuavJn5f3WMYF7nzcnnqz4ojia6FoRFpmnd7vFBXGCfYrBKHEdU2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593733;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=m3CxB6xtmT9F0ayB3I8efdWp7E/o9TIKLlFpWK6YibE=;
	b=knLJqq1uniiWwFtvKqxb92YUT70OzeUAfQ8w8ZtIEVFOXIZnm8vRwfpzsOzoRO6fP5HF
	 wqCxYrxCU9sKZF3VSqIsu8CkCLvJILBvwq5U6ceG7Y7fUHE2uXqvM53t3vnNbcbnNNkSp
	 p/zaP4mqq6EkAVcrov9ZSri+vxexVmbBgcLQNwWKN1e4PQjzM18n0sqFKoMU00/e+1r6+
	 hatg+A2ispu0wjm0IVaofI5BKlDymgI99qm8ClFn43ElUfNVarJMjl9GE8ZYRdzkjBBKT
	 Mo2IiIlKyEBB+6h0Irw3sjyWlrEhYUgOIu2gd0IB4poyLDSnzCsyFyaMsTOf3V+gM6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=F97FEM2w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.3
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AE2606A324;
	Wed, 21 Oct 2026 14:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6AE2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=F97FEM2w
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJHYsvD8aNOT57wwQzfr8DrQSDHTUuOmAbz8b8GptFE63wFP/7WmaRAMfSD7SM+MpM02mwWlEk82WBvepAW8kg8ipociTRddgqzTQ92ftvMmmBQl7n93lkqTSqXsx9qocHs6b4PP469ciGDXUB7rOdyn5Fvz2a9u6WjAFjssZBySlw3WtnlC+fFRoJvCMNVAH9Lt+yiijfgMg4TLvVt1IpoOTFtuJQfcbsjLg/AzcscXEdehuOaSQWnZ0zxjx5E/+YSovr8bzPo8+B0YdJt5gKTtmeUHJ2hYEJEp9mFXAW8pCPJcyT+tEh+DkTun3JWnjiOKgo5awsKd4JUeLmSiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3CxB6xtmT9F0ayB3I8efdWp7E/o9TIKLlFpWK6YibE=;
 b=Ux/L6GUrX0NytWiymmnPwsnAkihOkjKX1cPpORBm/7ec4dImN7tE0z/E59D7x4mYkOPGegeYbhFPNMtM+X6MMFEwuY1f/wEIGmtolHYhAezeOMprUeGVkoqPbEUJ0jfO/O0QRi1LV9+DiuywDhVXknJoMEsk/Bx2fIgiN8pzWoN7FrNA8dr10NxjLLQvyuSOakyPt/CvMyPd0z6ZylqwmLm6twa2pdMZ760NWghqjZPXi+W+2cuTmPCAf8e3XEvQx9zPTO7R2Tw4hIMdwq5GlatjXTJHiYY71pu2Yj8GlQGPmKxC2ieh50M+7jmDykSLQ15sXQXcNV1Q9CmJCwqjsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3CxB6xtmT9F0ayB3I8efdWp7E/o9TIKLlFpWK6YibE=;
 b=F97FEM2w5ehNi1jeYormjkfRhvK3VzFwfYP0i4ionAfpGWF8XDkaRluWurlrYPv48dfTWx1eVnLzwA42ZdWclCWiBOjT7X5emul3xHFW/gdHzDAkl1LKSA887RL5+Ql7bu8Kr/9rku5HNVJMulOsfuIcpit8N0JvGWRXZ+O0EmCwPfuJFUBnU+v1okszpj4MkCZTTKwdbfPi7l9rJ8iVKLYBmdrF6xaWh4AC1n9+fu8/ENiMru+gZlOHwjjCaScjjwJkpU8RYPQlj7rCAHd/nM6THMpEfU8K5KL9i9jMV3NxDGyKkD3fTWw4kBgARnV8MOHaeCEluWJeOzbEqb1wwQ==
Received: from CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39)
 by SA1PR12MB8642.namprd12.prod.outlook.com (2603:10b6:806:383::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 14:42:03 +0000
Received: from BN5PEPF0004698B.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::80) by CH2PR10CA0029.outlook.office365.com
 (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 14:41:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN5PEPF0004698B.mail.protection.outlook.com (10.167.245.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 14:41:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 07:41:32 -0700
Received: from c-237-113-240-247.mtl.labs.mlnx (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 07:41:29 -0700
From: Cosmin Ratiu <cratiu@nvidia.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Tariq Toukan
	<tariqt@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] wifi: wext: Limit notifier event flushes to the device's netns
Date: Wed, 21 Oct 2026 17:41:11 +0300
Message-ID: <20261021144111.611840-1-cratiu@nvidia.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698B:EE_|SA1PR12MB8642:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbe9952-e639-4491-9ec7-08df2f8176ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|18002099003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	yo7C++pO61iUZRyxolq9ltT2ovcsvkbGxUUxTqUiC0T8qOdHA9S7kLeOJyPFChK5YMeQ39bYUv32oFnmsycU7xRgeHz1HMRI6e4hCZZ+zlcSvpERPsdWCvGIffMt6cr8mixPNvRM7+T5SMx7aHEuxqn0FJ3hod6cEaXvAnpPWNu7C1LuqzKSJskuxghPcMwNwXaM72vZcIfF+vzusPUH7mraczvARU511SdI7zOYCQ0uYx1HQ1mrhyrDA9t+u34X3o8FkQVU0qXiRobZ3gTz2nZb5ub6ymt2wMGDZ/zogPHHfx2I3t0tOMWb7Sl6CK2XhjLM4dg8WDXy9+WFzrzUA4tGYVVPnSMGKwi4Yf25aLWJg5759KU0T9PdG0MIg455c88n/o4yfxN4Y4uIRWNH8C9p3SZz6QnRXfnk56A3/f0iWgs7d2uomZ+2tIjUgM6kffj7idFOZaXh2EbI+6FiujWNm1cUoMYWCFOeeaS9bKfiRdVI3IW4xZeVWjE0gO8wKMgP/iJ6A1t2aBr1K8jYkiV3V+Hxd0Jwq4kL4pdKzhhtKLF0bZTGFUKCborV9R610IK2OQjS9Qka9tlByf82jKDmHsokxRksK9/nKczZXzXDSHWnq/DViUkLY0tdEBRYVc6XU7lb5tJEP9jsCEIOMKoOwnBfmb4zff+ZLk9M7NN/GahOt6iY7WVG/0881VSgPPP22eCH3RK8uNIfe3bqCg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(18002099003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dLRSYArC7yLuFVhsJ6ElTLQgOrmqZkM3NIQ7SBogCeAm/yJcCwKmAdsbLCDa9TVMs7k8KyVQIOQwvgZmyVFzo905WjvvX2eg8zeKZSetRyzJYpREaxxVdSj5M7ayqko9H6AjxCmXqir+YhZavMQs1UytvOHuOdZeDyYUz+nbmP8lkWBQrfIG1wWfHv4tI2NLFB55Zyd2lSDtrM31ELCa8Si2Y1fsDAPyDaTW+mj2OpCQdzAd6Z7yWxwxNQmwXU75BDM6/MzOwiUgond2AAMW6cJ/NFIhIauf8SoHUUeBoGnV/bfH/8gB51GMnWlUOPLH5G3FAmwMLOffrKsvCpY1gzriMcV1HLiMM5OwdYo0fPaHIA6H8fxvuinyu86UGAKOYYVU1JuShNOdjLcQAFKWUZro7mWeffZwWUuWVbR7z0PoeUEsjBhrHL0BMEpQnfeS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 14:41:59.7357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbe9952-e639-4491-9ec7-08df2f8176ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8642

With mlx5 netdev instance locking enabled, registering an IPoIB netdev
calls the WEXT notifier while holding the instance mutex. Its call to
wireless_nlevent_flush() takes net_rwsem to walk every namespace,
completing the following lockdep dependency cycle:

  netdev instance mutex -> net_rwsem (read) -> GID table mutex
    -> event_handler_rwsem (read) -> netdev instance mutex

RoCE GID enumeration takes the GID table mutex under net_rwsem. GID
updates dispatch events under the table mutex, taking event_handler_rwsem.
The IPoIB event handler takes the netdev instance mutex in
ipoib_queue_work() to traverse child interfaces.

The all-namespace walk originated in the single global worker servicing
per-namespace WEXT queues. The ordering fixes later reused that routine
in netdevice notifiers to prevent delayed WEXT RTM_NEWLINK messages from
following RTM_DELLINK or reporting stale interface flags. A notifier only
needs to drain the affected device's namespace; there is no reason for it
to walk and flush all namespaces.

Pass dev_net(dev) from both notifier callers and make the flush helper
operate on that namespace. Keep the all-namespace walk and net_rwsem in
the existing worker. This removes the instance-mutex -> net_rwsem
dependency while retaining synchronous flushing from the notifiers.

It may seem strange that the fix for a lock cycle across multiple
subsystems lies in a completely unrelated part of the code, but this
seemed the most justified lock cycle edge to break.

Issue: 5331015
Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Change-Id: I98d7e77ffc9fa0ce72296d93c200da8fe1db378e
---
 include/net/iw_handler.h |  8 +++++---
 net/wireless/core.c      |  2 +-
 net/wireless/wext-core.c | 33 +++++++++++++++++----------------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index b80e474cb0aa..632618d9ff93 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -201,6 +201,8 @@
 #include <linux/wireless.h>		/* IOCTL user space API */
 #include <linux/if_ether.h>
 
+struct net;
+
 /***************************** VERSION *****************************/
 /*
  * This constant is used to know which version of the driver API is
@@ -411,10 +413,10 @@ struct iw_spy_data {
 void wireless_send_event(struct net_device *dev, unsigned int cmd,
 			 union iwreq_data *wrqu, const char *extra);
 #ifdef CONFIG_WEXT_CORE
-/* flush all previous wext events - if work is done from netdev notifiers */
-void wireless_nlevent_flush(void);
+/* Flush previous wext events in this netns from netdev notifiers. */
+void wireless_nlevent_flush(struct net *net);
 #else
-static inline void wireless_nlevent_flush(void) {}
+static inline void wireless_nlevent_flush(struct net *net) {}
 #endif
 
 /* We may need a function to send a stream of events to user space.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index cde3ca85494d..2f49ed14b26e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1878,7 +1878,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 
-	wireless_nlevent_flush();
+	wireless_nlevent_flush(dev_net(dev));
 
 	return NOTIFY_OK;
 }
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index db77912b3994..f09c589ff94c 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -342,32 +342,28 @@ static const int compat_event_type_size[] = {
 
 /* IW event code */
 
-void wireless_nlevent_flush(void)
+void wireless_nlevent_flush(struct net *net)
 {
 	struct sk_buff *skb;
-	struct net *net;
 
-	down_read(&net_rwsem);
-	for_each_net(net) {
-		while ((skb = skb_dequeue(&net->wext_nlevents)))
-			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
-				    GFP_KERNEL);
-	}
-	up_read(&net_rwsem);
+	while ((skb = skb_dequeue(&net->wext_nlevents)))
+		rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(wireless_nlevent_flush);
 
 static int wext_netdev_notifier_call(struct notifier_block *nb,
 				     unsigned long state, void *ptr)
 {
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
 	/*
-	 * When a netdev changes state in any way, flush all pending messages
-	 * to avoid them going out in a strange order, e.g. RTM_NEWLINK after
-	 * RTM_DELLINK, or with IFF_UP after without IFF_UP during dev_close()
-	 * or similar - all of which could otherwise happen due to delays from
-	 * schedule_work().
+	 * When a netdev changes state in any way, flush all pending messages in
+	 * its network namespace to avoid them going out in a strange order,
+	 * e.g. RTM_NEWLINK after RTM_DELLINK, or with IFF_UP after without
+	 * IFF_UP during dev_close() or similar - all of which could otherwise
+	 * happen due to delays from schedule_work().
 	 */
-	wireless_nlevent_flush();
+	wireless_nlevent_flush(dev_net(dev));
 
 	return NOTIFY_OK;
 }
@@ -410,7 +406,12 @@ subsys_initcall(wireless_nlevent_init);
 /* Process events generated by the wireless layer or the driver. */
 static void wireless_nlevent_process(struct work_struct *work)
 {
-	wireless_nlevent_flush();
+	struct net *net;
+
+	down_read(&net_rwsem);
+	for_each_net(net)
+		wireless_nlevent_flush(net);
+	up_read(&net_rwsem);
 }
 
 static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
-- 
2.53.0

