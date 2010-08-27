Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42120 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0H0SlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/7] compat-wireless: fix patch stile.
Date: Fri, 27 Aug 2010 20:40:48 +0200
Message-Id: <1282934453-18093-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should not change any functionality but the patches are looking
better with theses changes.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch    |    6 ++----
 patches/16-bluetooth.patch |   26 ++++++++++----------------
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index e168105..17b4b11 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -305,14 +305,12 @@ without creating a headache on maintenance of the pathes.
  }
  #endif
  
--static netdev_tx_t bnep_net_xmit(struct sk_buff *skb,
--				 struct net_device *dev)
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
-+static netdev_tx_t bnep_net_xmit(struct sk_buff *skb, struct net_device *dev)
+ static netdev_tx_t bnep_net_xmit(struct sk_buff *skb,
+ 				 struct net_device *dev)
 +#else
 +static int bnep_net_xmit(struct sk_buff *skb, struct net_device *dev)
 +#endif
-+
  {
  	struct bnep_session *s = netdev_priv(dev);
  	struct sock *sk = s->sock->sk;
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 29d990a..85e9b25 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -63,7 +63,7 @@ here still, but for now we keep this here.
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
  		sock_recv_ts_and_drops(msg, sk, skb);
 +#else
-+	  sock_recv_timestamp(msg, sk, skb);
++		sock_recv_timestamp(msg, sk, skb);
 +#endif
  
  	skb_free_datagram(sk, skb);
@@ -75,7 +75,7 @@ here still, but for now we keep this here.
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
  		amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
 +#else
-+    amount = sk->sk_sndbuf - atomic_read(&sk->sk_wmem_alloc);
++		amount = sk->sk_sndbuf - atomic_read(&sk->sk_wmem_alloc);
 +#endif
  		if (amount < 0)
  			amount = 0;
@@ -201,27 +201,21 @@ here still, but for now we keep this here.
  
  static void hidp_idle_timeout(unsigned long arg)
  {
-@@ -596,10 +607,16 @@ static int hidp_session(void *arg)
- 		session->input = NULL;
+@@ -597,8 +608,14 @@ static int hidp_session(void *arg)
  	}
  
--	if (session->hid) {
--		hid_destroy_device(session->hid);
--		session->hid = NULL;
--	}
-+  if (session->hid) {
+ 	if (session->hid) {
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
-+    hid_destroy_device(session->hid);
-+    session->hid = NULL;
+ 		hid_destroy_device(session->hid);
+ 		session->hid = NULL;
 +#else
-+    if (session->hid->claimed & HID_CLAIMED_INPUT)
-+      hidinput_disconnect(session->hid);
-+    hid_free_device(session->hid);
++		if (session->hid->claimed & HID_CLAIMED_INPUT)
++			hidinput_disconnect(session->hid);
++		hid_free_device(session->hid);
 +#endif
-+  }
+ 	}
  
  	/* Wakeup user-space polling for socket errors */
- 	session->intr_sock->sk->sk_err = EUNATCH;
 @@ -711,6 +728,70 @@ static void hidp_close(struct hid_device
  {
  }
-- 
1.7.0.4

