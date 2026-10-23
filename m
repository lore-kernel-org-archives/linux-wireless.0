Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792743110;
	b=L4ZCdNU8+FGlj8DNxvNdaIutoeq9RXk1ZfWpUXgbJ9/mErJ79h5yZ2XJw7Yu26JR58eT
	 TgdkXsjJfl4GdseNoTLGr1Q4x9Q8hPgpgneE5oURPNwxgs4cUu1qtvjcu+gL+28QPgSTk
	 pxan/JnczR+LEvML4Ka9yC1ihHGydUQffrZFD3d4M2NFS8UcINN93LM0hWOzgX67iSBHu
	 k7JyYhyVFco83eTKyKXmE5d3KtINWv7pnQnTNC13FrZHN4NdtaBHC9sQd/LqvKSAHHGfn
	 IkFKt4xvvaOkm0PRRBdFldxNJKK4SfdryScaIG28tA9Oz0BBqfvferrATl5J0AsSROw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792743110;
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
	bh=jqpuQc0Fae+iz8bUDGg69eN6Pzr8Jk/XU1c9WTsdyws=;
	b=2AbXWzNyEtmHy8zIQhl2ggO/Z2d1oaxJ8wVq8o2N2QXwFJx7F0XWpLTbJcl5wy6yt8F1
	 WT97ZiVCrWWmmUjwL9UKC/Cej+vfKnnYVpxIiu0VZvKy84ib76hJkWIAyAFdsMLQRqd+Z
	 JlUmKjjXSBHx83y96Nq52Lli6Ga4L2o/YLVXF60z7pW9w1w3NdveBhcVVNC9m8sB9u9cS
	 fAqXligJIKa/HkOqhTAjsnwt2Rfshbg2/nauZBGQnXnBdFG79qNaAv0wmvR2bN21OaD9m
	 il23JZVRcqXn2t7jy4Bed2zl4qwN0qvX1Q+Ba/hSRfVTik0qpc73zZvTrBI/CoT3pJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NrUtY+eO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.53
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D6606A31F;
	Fri, 23 Oct 2026 08:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 924D6606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NrUtY+eO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gaAS74my2YS+12kOtgvEEF4vmgs6U/WPMjjXdQCrCV8CfHpeURSegKrDpCuE4pPNCptKhXNbNBnZlXbdBSodVHZLh3M8HsIlU3//rH8aC2y7vmU5WzGD+nskuGlKQZwdsRBuyanyrvaE06mKeE/A5YnwH43dmpI1diNScyf6SiMHkW1yX1ZRVWiNURHtnGOuFJWr562tsYWh5RokZ0uQt6lGKkrYvnRM5E3pwGXmWZaCF+ePrADfx7xk0r4aINqTRoyWK8uxDMjX8uUHOTGZIMGfqyX5/sEPBHnyC+5K2wjLee33qXb7mE60wTgbLedpwCP+Lcg3plMiD+xDZ9udCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqpuQc0Fae+iz8bUDGg69eN6Pzr8Jk/XU1c9WTsdyws=;
 b=a+gHsUmo3m8RfUm1SJH+O2V90rmYPbhM5jjf9Ziz2yn8g1wB09ZQdC+nl9LC1EVrUPHqTV9QL+FmcgXfX/ple2NaiNVjsOZMVo3pMGpvWcRgAl+ym/35UskCpAhBvnRdbdmDxYI9adZrTIiHRPH6RRDam2oZjsvTv8jLy//glaS5LmEb01wvr0XBg9KV7LJ+ObBRt5ennVJC+DUbueJ5H6UBqkRiq1Dle4HHuFrgBK8dbIwDV1iFyjUZ/nCez/jpqH89KluR8YmA3f97QaO/3i6Yr6L3TPPDuPnbi7ZJU++k0Nu00AKyGttW2iPRxuJJmFG7T1lkdjGy9YUwR6fo3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqpuQc0Fae+iz8bUDGg69eN6Pzr8Jk/XU1c9WTsdyws=;
 b=NrUtY+eO7i2rtGHgs0EFRVnDBaaktWO1Ia7RLA+si7DgXnpoOMFRkyRJ7JoGcp+l9bdXOixjKTVxeaGBbj7txYFVM4VifNwy4NDhlGv3Jq8VgGn+TTX5uOK0fhBW+E9vrYu3gpsKT0KHY+MEhFnGKZYCaCWX+l4XocoBslMiNWkCGDrQ1O7RclljxSHnwA5nVoiKgtQKNGlvDPlTFrkjGYc+dAocksWUD5FiIU3GA9AAeLIyqsJLeTw0yaYGOx5mT9501BxLBqv2sWRBWrU6NjGt4iHv9gHDSdfbh3u2YVxqE3kMGqxeTatJGPbWOGC4cjXEZsrYp5XWysUXbFrf7A==
Received: from SJ0PR03CA0228.namprd03.prod.outlook.com (2603:10b6:a03:39f::23)
 by IA0PR12MB8328.namprd12.prod.outlook.com (2603:10b6:208:3dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 08:11:45 +0000
Received: from SJ1PEPF000037B5.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::62) by SJ0PR03CA0228.outlook.office365.com
 (2603:10b6:a03:39f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.19 via Frontend Transport; Fri,
 23 Oct 2026 08:11:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000037B5.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Fri, 23 Oct 2026 08:11:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Fri, 23 Oct
 2026 01:11:19 -0700
Received: from c-237-113-240-247.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 23 Oct 2026 01:11:16 -0700
From: Cosmin Ratiu <cratiu@nvidia.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Tariq Toukan
	<tariqt@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH wireless v2] wifi: wext: Limit notifier event flushes to the device's netns
Date: Fri, 23 Oct 2026 11:10:44 +0300
Message-ID: <20261023081044.728500-1-cratiu@nvidia.com>
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
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B5:EE_|IA0PR12MB8328:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6dd661-9248-478c-7368-08df30dd46f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|261021123027099003|261022105027099003|261022075727099003|56012099006|11063799006|261009223027099003|18002099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Rt5itCEWDYa9h5Yc4hNMugzMVd4tHlid44k3FHpYZ/878XalLYUvw2FR6pqmySfQHxRNQD7ex6a+nE9Cf+s1wp8pzRH0HtWS8vAPQ6pkNp4vRF57qiO+liD/Xpqx03Iy06uzpilLQOjPB4/cfbjC+A9pZKt1H8XrjC2CfKPHR1STWxv3n+S+r6d70ZODH9KYrUFcyuWBXHUXeWPclfsuIA3WUQELSx/Ng+Hb7x6VbfiJy2gBrWaN+6UH2ULC3XSNhAcxmDtzhrQuJxFRonUn/N2qFHQsKwhH6qO7lAClp3qwmCKvbPhqV5IcaKuae9dEiDpTcIwgTpVPrQdJW2vHlKg7Y4Vd+ndo1CB1hks3s8CNJFF34Q8C3E6NWm8bA9eoS/kBBp5UKbIqlETuHn2Gs5cSu6JsIjwTulLxeg1ccYoBRKaTkdgB1W/V9i6bSGtXs6tYU1BvVpi1VxUMpAvXO639FTbp8sSNWpf0JIAURAj9rJjI4vEBBUrWWA50843wHqwVbfzucaJNKb6cWE1FbytYKnKjD5dBtLkCOTgdHE21QLbjE5Xh3ysZXypvLl+7/rTD8jl2tfRWgReWRSx/JyWHuuy9RJfGV3OPxgtzGcDzZzW0HXvfRw8+dSTUb6/MgOxZxZDb05kluX08hOzCQ7fyYel73V3VcFbPKV/F6QRKlA9aqXxYtYAAiQNHdbR+mqN90SmDJyIZ1Hi9zRHeoA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(261021123027099003)(261022105027099003)(261022075727099003)(56012099006)(11063799006)(261009223027099003)(18002099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8y9p3f0uQRFefsqPK8Kg8qXaRju8xlyESVWn1V8S8Ib5E8E6orDGgUWG0d68yzgsXnNKvzEK3HTCYCqGkvZT3XrB1j04Mi4I31hwtJqaGsKHqwGSOGAePqWVUeIxg6BiuBThNk7bwquNPEIDMWu3jDyG8Wayq6qIHcwHuiSrO9/C2+BixD9QpMAwfnKqethenipvJDwmCBWduVUpaAyTTYqt8PrBvhC0IItNO6dlzVWUWVVUJKTzeRbiews93kedf6tNNLX0vZ/zIn3ALU923NC7tDu2hFUDYTf9HfLNgTzqfOVh6wV+kpB7rtdS4zGxUDtmvxAKcgNXALlqGJPH/3Hy3622TblyIg9uXUY4SkQ29l3khVN6GKQsaOJDbqI9pqcXnn3IgT1La58yN+tpYSRXXRuBYbUPeydpO1869q/oC2L8alSC0/om2/un6X4R
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 08:11:44.5142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6dd661-9248-478c-7368-08df30dd46f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8328

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

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
---

v1->v2:
- Removed unnecessary git tags from commit description.

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

