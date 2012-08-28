Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47332 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2H1NCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 09:02:41 -0400
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 21:02:40 +0800
Message-ID: <CAPgLHd80nD+uYpMMC+sLjcErRcLbGpAVMw7PktrAoxJB8NwHsg@mail.gmail.com> (sfid-20120828_150248_300165_56A37562)
Subject: [PATCH] NFC: remove pointless conditional before kfree_skb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, davem@davemloft.net
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/nfc/hci/shdlc.c | 3 +--
 net/nfc/hci/core.c  | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 6f840c1..52e5cbb 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -241,8 +241,7 @@ static void nfc_shdlc_rcv_i_frame(struct nfc_shdlc *shdlc,
 	}
 
 exit:
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 }
 
 static void nfc_shdlc_rcv_ack(struct nfc_shdlc *shdlc, int y_nr)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 1ac7b3f..35413cc 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -398,8 +398,7 @@ disconnect_all:
 	nfc_hci_disconnect_all_gates(hdev);
 
 exit:
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 
 	return r;
 }

