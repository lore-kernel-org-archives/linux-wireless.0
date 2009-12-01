Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34668 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbZLAIkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:40:15 -0500
Received: by yxe17 with SMTP id 17so4395908yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 00:40:22 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 4/5] Add `enum nf_inet_hooks'
Date: Tue,  1 Dec 2009 03:38:20 -0500
Message-Id: <1259656701-12329-4-git-send-email-lacombar@gmail.com>
In-Reply-To: <1259656701-12329-3-git-send-email-lacombar@gmail.com>
References: <4B0B4405.4050605@gmail.com>
 <1259656701-12329-1-git-send-email-lacombar@gmail.com>
 <1259656701-12329-2-git-send-email-lacombar@gmail.com>
 <1259656701-12329-3-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduced on commit 6e23ae2a by Patrick McHardy in include/linux/netfilter.h in
order to factor common macro value used by IPv6 and IPv4 code.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.25.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.25.h b/compat-2.6.25.h
index 5502741..fa42fd9 100644
--- a/compat-2.6.25.h
+++ b/compat-2.6.25.h
@@ -29,6 +29,15 @@ extern void		__dev_addr_unsync(struct dev_addr_list **to, int *to_count, struct
 
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

