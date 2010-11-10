Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39368 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:15 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500250qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:15 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 17/44] compat/2.6.29: const'ify compat inline to dev_get_stats()
Date: Tue,  9 Nov 2010 21:19:59 -0500
Message-Id: <1289355626-25373-18-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.29.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index ef40d00..bd112d0 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -229,7 +229,8 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
 }
 
 
-static inline struct net_device_stats *dev_get_stats(struct net_device *dev)
+static inline const struct net_device_stats *
+dev_get_stats(struct net_device *dev)
 {
 	return dev->get_stats(dev);
 }
-- 
1.7.2.30.gc37d7.dirty

