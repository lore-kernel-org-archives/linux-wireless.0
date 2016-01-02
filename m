Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36169 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcABAe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 19:34:28 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: netdev@vger.kernel.org
Cc: dvyukov@google.com, linux-wireless@vger.kernel.org,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [Patch net] nfc: use GFP_USER for user-controlled kmalloc
Date: Fri,  1 Jan 2016 16:34:16 -0800
Message-Id: <1451694857-21873-1-git-send-email-xiyou.wangcong@gmail.com> (sfid-20160102_013514_354319_84A95564)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/nfc/llcp_commands.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 3621a90..5d94055 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -729,7 +729,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
 	if (local == NULL)
 		return -ENODEV;
 
-	msg_data = kzalloc(len, GFP_KERNEL);
+	msg_data = kzalloc(len, GFP_USER | __GFP_NOWARN);
 	if (msg_data == NULL)
 		return -ENOMEM;
 
-- 
1.8.3.1

