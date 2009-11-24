Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46844 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbZKXC0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:42 -0500
Received: by mail-yw0-f182.google.com with SMTP id 12so5947609ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:48 -0800 (PST)
Message-ID: <4B0B4423.8050601@gmail.com>
Date: Mon, 23 Nov 2009 21:25:39 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 12/13] Add `enum nf_inet_hooks'
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduced on commit 6e23ae2a by Patrick McHardy in
include/linux/netfilter.h in
order to factor common macro value used by IPv6 and IPv4 code.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.25.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.25.h b/compat-2.6.25.h
index 5502741..fa42fd9 100644
--- a/compat-2.6.25.h
+++ b/compat-2.6.25.h
@@ -29,6 +29,15 @@ extern void		__dev_addr_unsync(struct dev_addr_list
**to, int *to_count, struct

 #define seq_file_net &init_net;

+enum nf_inet_hooks {
+	NF_INET_PRE_ROUTING = 0,
+	NF_INET_LOCAL_IN = 1,
+	NF_INET_FORWARD = 2,
+	NF_INET_LOCAL_OUT = 3,
+	NF_INET_POST_ROUTING = 4,
+	NF_INET_NUMHOOKS = 5
+};
+
 /* The patch:
  * commit 8b5f6883683c91ad7e1af32b7ceeb604d68e2865
  * Author: Marcin Slusarz <marcin.slusarz@gmail.com>
-- 
1.6.3.3.385.g60647.dirty


