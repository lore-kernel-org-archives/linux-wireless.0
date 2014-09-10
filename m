Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9459 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaIJWOI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 18:14:08 -0400
Subject: [PATCH net-next v2 1/2] skb: Add documentation for skb_clone_sk
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: johannes@sipsolutions.net, davem@davemloft.net,
	eric.dumazet@gmail.com, linville@tuxdriver.com
Date: Wed, 10 Sep 2014 18:05:26 -0400
Message-ID: <20140910220448.23225.39224.stgit@ahduyck-bv4.jf.intel.com> (sfid-20140911_001412_225480_F7E5D232)
In-Reply-To: <20140910215837.23225.39149.stgit@ahduyck-bv4.jf.intel.com>
References: <20140910215837.23225.39149.stgit@ahduyck-bv4.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds some documentation to the call skb_clone_sk.  This is
meant to help clarify the purpose of the function for other developers.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

v2: Updated comments to specifically call out need for sock_hold/sock_put

 net/core/skbuff.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a18dfb0..c9da77a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3511,6 +3511,19 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_dequeue_err_skb);
 
+/**
+ * skb_clone_sk - create clone of skb, and take reference to socket
+ * @skb: the skb to clone
+ *
+ * This function creates a clone of a buffer that holds a reference on
+ * sk_refcnt.  Buffers created via this function are meant to be
+ * returned using sock_queue_err_skb, or free via kfree_skb.
+ *
+ * When passing buffers allocated with this function to sock_queue_err_skb
+ * it is necessary to wrap the call with sock_hold/sock_put in order to
+ * prevent the socket from being released prior to being enqueued on
+ * the sk_error_queue.
+ */
 struct sk_buff *skb_clone_sk(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;

