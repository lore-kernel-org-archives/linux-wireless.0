Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39784 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFT75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:57 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 21/33] NFC: Close listening LLCP sockets when the device is gone
Date: Fri,  6 Jul 2012 22:09:41 +0200
Message-Id: <1341605393-32056-22-git-send-email-sameo@linux.intel.com> (sfid-20120706_220536_606046_70A900EE)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the MAC link goes down, we should only keep the bound sockets
alive. They will be closed by sock_release or when the underlying
NFC device is moving away.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 6812b1e..0c8d25e 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -45,7 +45,7 @@ void nfc_llcp_sock_unlink(struct llcp_sock_list *l, struct sock *sk)
 	write_unlock(&l->lock);
 }
 
-static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
+static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool listen)
 {
 	struct sock *sk;
 	struct hlist_node *node, *tmp;
@@ -78,6 +78,11 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 
 				sock_orphan(accept_sk);
 			}
+
+			if (listen == true) {
+				release_sock(sk);
+				continue;
+			}
 		}
 
 		sk->sk_state = LLCP_CLOSED;
@@ -106,7 +111,7 @@ static void local_release(struct kref *ref)
 	local = container_of(ref, struct nfc_llcp_local, ref);
 
 	list_del(&local->list);
-	nfc_llcp_socket_release(local);
+	nfc_llcp_socket_release(local, false);
 	del_timer_sync(&local->link_timer);
 	skb_queue_purge(&local->tx_queue);
 	destroy_workqueue(local->tx_wq);
@@ -991,7 +996,7 @@ void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 	nfc_llcp_clear_sdp(local);
 
 	/* Close and purge all existing sockets */
-	nfc_llcp_socket_release(local);
+	nfc_llcp_socket_release(local, true);
 }
 
 void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
-- 
1.7.10

