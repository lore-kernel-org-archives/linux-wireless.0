Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36212 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbcA2TYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 14:24:38 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: netdev@vger.kernel.org
Cc: dvyukov@google.com, linux-wireless@vger.kernel.org,
	julian.calaby@gmail.com, eric.dumazet@gmail.com,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 net] nfc: use GFP_USER for user-controlled kmalloc
Date: Fri, 29 Jan 2016 11:24:24 -0800
Message-Id: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com> (sfid-20160129_202446_476274_0A839E39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two functions are called in sendmsg path, and the
'len' is passed from user-space, so we should not allow
malicious users to OOM kernel on purpose.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/nfc/llcp_commands.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 3621a90..3425532 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -663,7 +663,7 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 		return -ENOBUFS;
 	}
 
-	msg_data = kzalloc(len, GFP_KERNEL);
+	msg_data = kmalloc(len, GFP_USER | __GFP_NOWARN);
 	if (msg_data == NULL)
 		return -ENOMEM;
 
@@ -729,7 +729,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
 	if (local == NULL)
 		return -ENODEV;
 
-	msg_data = kzalloc(len, GFP_KERNEL);
+	msg_data = kmalloc(len, GFP_USER | __GFP_NOWARN);
 	if (msg_data == NULL)
 		return -ENOMEM;
 
-- 
1.8.3.1

