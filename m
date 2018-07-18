Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:24450 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeGRKfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 06:35:02 -0400
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>
Subject: [PATCH] net/nfc: Avoid stalls when nfc_alloc_send_skb() returned NULL.
Date: Wed, 18 Jul 2018 18:57:27 +0900
Message-Id: <1531907847-3500-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp> (sfid-20180718_115805_278698_D41BED4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

syzbot is reporting stalls at nfc_llcp_send_ui_frame() [1]. This is
because nfc_llcp_send_ui_frame() is retrying the loop without any delay
when nonblocking nfc_alloc_send_skb() returned NULL.

Since there is no need to use MSG_DONTWAIT if we retry until
sock_alloc_send_pskb() succeeds, let's use blocking call.
Also, in case an unexpected error occurred, let's break the loop
if blocking nfc_alloc_send_skb() failed.

[1] https://syzkaller.appspot.com/bug?id=4a131cc571c3733e0eff6bc673f4e36ae48f19c6

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>
---
 net/nfc/llcp_commands.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 2ceefa1..6a196e4 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -752,11 +752,14 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
 		pr_debug("Fragment %zd bytes remaining %zd",
 			 frag_len, remaining_len);
 
-		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
+		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, 0,
 					 frag_len + LLCP_HEADER_SIZE, &err);
 		if (pdu == NULL) {
-			pr_err("Could not allocate PDU\n");
-			continue;
+			pr_err("Could not allocate PDU (error=%d)\n", err);
+			len -= remaining_len;
+			if (len == 0)
+				len = err;
+			break;
 		}
 
 		pdu = llcp_add_header(pdu, dsap, ssap, LLCP_PDU_UI);
-- 
1.8.3.1
