Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbXGYNzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 09:55:33 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6PDtXXL009680
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 09:55:33 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6PDtWXB011121
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 09:55:33 -0400
Received: from [10.11.15.27] (vpn-15-27.rdu.redhat.com [10.11.15.27])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id l6PDtW7s000814
	for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 09:55:32 -0400
Subject: [Fwd: [PATCH] libertas: Per-socket mesh-ttl via setsockopt().]
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-FcxpAnyuMqhZmcCv85Al"
Date: Wed, 25 Jul 2007 09:53:48 -0400
Message-Id: <1185371628.11035.11.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FcxpAnyuMqhZmcCv85Al
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Any objections before I push to libertas?

Dan

--=-FcxpAnyuMqhZmcCv85Al
Content-Disposition: inline
Content-Description: Forwarded message - [PATCH] libertas: Per-socket
	mesh-ttl via setsockopt().
Content-Type: message/rfc822

Return-Path: <libertas-dev-bounces+dcbw=redhat.com@lists.infradead.org>
Received: from mail.boston.redhat.com ([unix socket]) by
	mail.boston.redhat.com (Cyrus v2.2.12-Invoca-RPM-2.2.12-8.1.RHEL4) with
	LMTPA; Thu, 19 Jul 2007 19:29:32 -0400
X-Sieve: CMU Sieve 2.2
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com
	[172.16.52.254]) by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id
	l6JNTWKm031603 for <dcbw@boston.redhat.com>; Thu, 19 Jul 2007 19:29:32 -0400
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31]) by
	int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6JNTVZp026878 for
	<dcbw@redhat.com>; Thu, 19 Jul 2007 19:29:31 -0400
Received: from canuck.infradead.org (canuck.infradead.org [209.217.80.40])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6JNTSsv021552 for
	<dcbw@redhat.com>; Thu, 19 Jul 2007 19:29:29 -0400
Received: from localhost ([127.0.0.1] helo=canuck.infradead.org) by
	canuck.infradead.org with esmtp (Exim 4.63 #1 (Red Hat Linux)) id
	1IBfQp-0002nQ-NR; Thu, 19 Jul 2007 19:29:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]) by
	canuck.infradead.org with esmtp (Exim 4.63 #1 (Red Hat Linux)) id
	1IBfQW-0002nH-Vi for libertas-dev@lists.infradead.org; Thu, 19 Jul 2007
	19:29:00 -0400
Received: by wa-out-1112.google.com with SMTP id v33so805793wah for
	<libertas-dev@lists.infradead.org>; Thu, 19 Jul 2007 16:28:55 -0700 (PDT)
Received: by 10.114.199.1 with SMTP id w1mr3054531waf.1184887735362; Thu,
	19 Jul 2007 16:28:55 -0700 (PDT)
Received: from localhost ( [71.156.104.53]) by mx.google.com with ESMTPS id
	m28sm5848942poh.2007.07.19.16.28.54 (version=TLSv1/SSLv3 cipher=OTHER);
	Thu, 19 Jul 2007 16:28:54 -0700 (PDT)
To: libertas-dev@lists.infradead.org
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 9 Jul 2007 13:12:33 -0700
Subject: [PATCH] libertas: Per-socket mesh-ttl via setsockopt().  
Message-ID: <469ff3b6.1cef600a.642b.ffffa1d2@mx.google.com>
X-Spam-Report: SpamAssassin version 3.1.9 on canuck.infradead.org summary:
	Content analysis details:   (1.6 points, 5.0 required) pts rule name       
	description ---- ----------------------
	-------------------------------------------------- 1.6 DATE_IN_PAST_96_XX
	Date: is 96 hours or more before Received: date
X-BeenThere: libertas-dev@lists.infradead.org
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <libertas-dev.lists.infradead.org>
List-Unsubscribe: 
	<http://lists.infradead.org/mailman/listinfo/libertas-dev>,
	<mailto:libertas-dev-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/libertas-dev>
List-Post: <mailto:libertas-dev@lists.infradead.org>
List-Help: <mailto:libertas-dev-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/libertas-dev>,
	<mailto:libertas-dev-request@lists.infradead.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: libertas-dev-bounces@lists.infradead.org
Errors-To: 
	libertas-dev-bounces+dcbw=redhat.com+dcbw=redhat.com@lists.infradead.org
X-RedHat-Spam-Score: 1.572 *
Content-Transfer-Encoding: 7bit

Resent per Dan's request.

Support for using setsockpt() to change the mesh-ttl on a network flow, i.e.

<snip>
    sock = socket (PF_INET, SOCK_STREAM, 0);
    setsockopt(sock, SOL_IP, MESH_SO_SET_TTL, &ttl, optlen);
    ttl = 0;
    getsockopt(sock, SOL_IP, MESH_SO_GET_TTL, &ttl, &optlen);
</snip>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/Kconfig              |    7 +
 drivers/net/wireless/libertas/Makefile    |    1 +
 drivers/net/wireless/libertas/decl.h      |    3 +
 drivers/net/wireless/libertas/hostcmd.h   |    6 +
 drivers/net/wireless/libertas/mesh_opts.c |  174 +++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/mesh_opts.h |    5 +
 drivers/net/wireless/libertas/tx.c        |   46 +++++++-
 include/linux/in.h                        |    3 +
 8 files changed, 241 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1146f3d..f4123c3 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -294,6 +294,13 @@ config LIBERTAS_USB
 	---help---
 	  A driver for Marvell Libertas 8388 USB devices.
 
+config LIBERTAS_MESH_OPTS
+	tristate "Mesh Configuration Options for Libertas USB 802.11b/g cards"
+	depends on LIBERTAS_USB && NETFILTER
+	---help---
+	  This module enables the configuration of mesh parameters on a
+	  per-socket basis, via setsockopt() calls. 
+
 config LIBERTAS_DEBUG
 	bool "Enable full debugging output in the Libertas module."
 	depends on LIBERTAS
diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index 71c5a25..a31d4f7 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -18,3 +18,4 @@ usb8xxx-objs += if_usb.o
 
 obj-$(CONFIG_LIBERTAS)     += libertas.o
 obj-$(CONFIG_LIBERTAS_USB) += usb8xxx.o
+obj-m			   += mesh_opts.o
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 4d553da..2cbc137 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -14,6 +14,7 @@
 struct wlan_private;
 struct sk_buff;
 struct net_device;
+struct mesh_options;
 
 extern char *libertas_fw_name;
 
@@ -86,6 +87,8 @@ int libertas_activate_card(wlan_private *priv, char *fw_name);
 int libertas_remove_card(wlan_private *priv);
 int libertas_add_mesh(wlan_private *priv, struct device *dev);
 void libertas_remove_mesh(wlan_private *priv);
+int libertas_register_mesh_opts(struct mesh_options *);
+int libertas_unregister_mesh_opts(struct mesh_options *);
 
 
 #endif				/* _WLAN_DECL_H_ */
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 0f67cba..bc86ed0 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -34,6 +34,12 @@ struct txpd {
 	u8 reserved1;
 };
 
+struct txpd_mesh {
+	__le16 reserved;
+	/* mesh ttl */
+	u8 ttl;
+} __attribute__ ((packed));
+
 /* RxPD Descriptor */
 struct rxpd {
 	/* Current Rx packet status */
diff --git a/drivers/net/wireless/libertas/mesh_opts.c b/drivers/net/wireless/libertas/mesh_opts.c
new file mode 100644
index 0000000..118eaed
--- /dev/null
+++ b/drivers/net/wireless/libertas/mesh_opts.c
@@ -0,0 +1,174 @@
+/*
+ * mesh_opts
+ *
+ * Author: Javier Cardona <javier@cozybit.com>
+ * Copyright: Marvell Semiconductors Inc., 2007
+ *
+ * Apply mesh-layer specific configuration to network flows.  Currently this
+ * only supports the mesh TTL parameter.
+ *
+ * Users call setsockopt on sockets to configure mesh parameters.  This module
+ * maintains a list of sockets (mesh_sks) that have different mesh parameters
+ * than the per-interface defaults.  The driver will modify the mesh
+ * configuration for each outgoing frame that belongs to one of the sockets in
+ * the mesh_sks list.
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/net.h>
+#include <linux/in.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/spinlock.h>
+#include <net/sock.h>
+
+#include <asm/uaccess.h>
+
+#include "mesh_opts.h"
+
+#define MESH_SO_BASE_CTL 	MESH_SO_SET_TTL
+
+static struct list_head mesh_sks = LIST_HEAD_INIT(mesh_sks);
+static DEFINE_RWLOCK(mesh_sks_lock);
+
+struct mesh_sock {
+	struct list_head list;
+
+	struct sock *sk;
+	unsigned char ttl;
+	void (*orig_sk_destruct) (struct sock *sk);
+};
+
+static struct mesh_sock * lookup_socket(struct sock *sk)
+{
+	struct mesh_sock *mesh_sk;
+	struct mesh_sock *found_sk = NULL;
+
+	read_lock(&mesh_sks_lock);
+	list_for_each_entry(mesh_sk, &mesh_sks, list) 
+		if (mesh_sk->sk == sk) {
+			found_sk = mesh_sk;
+			break;
+		}
+	read_unlock(&mesh_sks_lock);
+	return found_sk;
+}
+
+static void mesh_sk_destruct(struct sock *sk)
+{
+	struct mesh_sock *mesh_sk;
+	void (*orig_sk_destruct) (struct sock *sk);
+
+	mesh_sk = lookup_socket(sk);
+
+	if (mesh_sk) {
+		orig_sk_destruct = mesh_sk->orig_sk_destruct;
+		write_lock(&mesh_sks_lock);
+		list_del(&mesh_sk->list);
+		write_unlock(&mesh_sks_lock);
+		kfree(mesh_sk);
+		(*orig_sk_destruct)(sk);
+	}
+}
+
+static int do_mesh_set_mesh_ttl(struct sock *sk, void __user *user, unsigned int len)
+{
+	struct mesh_sock *mesh_sk;
+	unsigned char ttl;
+
+
+	if (len) {
+		if (get_user(ttl, (unsigned char *) user))
+			return -EFAULT;
+	} else
+		return -EINVAL;
+
+	mesh_sk = (struct mesh_sock*) kmalloc(sizeof(struct mesh_sock), GFP_KERNEL);
+	mesh_sk->ttl = ttl;
+	mesh_sk->sk = sk;
+	mesh_sk->orig_sk_destruct = sk->sk_destruct;
+	sk->sk_destruct = mesh_sk_destruct;
+	write_lock(&mesh_sks_lock);
+	list_add(&mesh_sk->list, &mesh_sks);
+	write_unlock(&mesh_sks_lock);
+
+	return 0;
+}
+
+static int do_mesh_get_mesh_ttl(struct sock *sk, void __user *user, int *len)
+{
+	struct mesh_sock *mesh_sk;
+	int rc = 0;
+
+	if ((mesh_sk = lookup_socket(sk)) == NULL)
+		return -ENODATA;	
+
+	if (put_user(mesh_sk->ttl, (unsigned char*) user))
+		return -EFAULT;
+
+	/* netfilter wrapper does the copy to user of len */
+	*len = sizeof(unsigned char);
+
+	return rc;
+}
+
+static int do_mesh_set_ctl(struct sock *sk, int optval, void __user *user,
+		unsigned int len) 
+{
+	return do_mesh_set_mesh_ttl(sk, user, len);
+}
+
+static int do_mesh_get_ctl(struct sock *sk, int optval, void __user *user, 
+		int *len) 
+{
+	return do_mesh_get_mesh_ttl(sk, user, len);
+}
+
+static unsigned char get_sock_mesh_ttl(struct sock *sk)
+{
+	struct mesh_sock *mesh_sk;
+
+	mesh_sk = lookup_socket(sk);
+
+	/* zero ttl results in using the network interface default */
+	return mesh_sk ? mesh_sk->ttl : 0;	
+}
+
+static struct mesh_options mesh_opts =
+{
+	.get_sock_ttl = get_sock_mesh_ttl,
+};
+
+static struct nf_sockopt_ops mesh_sockopt_ops =
+{
+	.pf		= PF_INET,
+	.set_optmin     = MESH_SO_BASE_CTL,
+	.set_optmax     = MESH_SO_BASE_CTL + 1,
+	.set		= do_mesh_set_ctl,
+	.get_optmin     = MESH_SO_BASE_CTL,
+	.get_optmax     = MESH_SO_BASE_CTL + 1,
+	.get		= do_mesh_get_ctl,
+};
+
+static int __init mesh_opts_init(void)
+{
+	int ret;
+
+	if ((ret = nf_register_sockopt(&mesh_sockopt_ops)) < 0) {
+		return ret;
+	}
+	libertas_register_mesh_opts(&mesh_opts);
+	return ret;
+}
+
+static void __exit mesh_opts_fini(void)
+{
+	nf_unregister_sockopt(&mesh_sockopt_ops);
+	libertas_unregister_mesh_opts(&mesh_opts);
+}
+
+module_init(mesh_opts_init);
+module_exit(mesh_opts_fini);
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/libertas/mesh_opts.h b/drivers/net/wireless/libertas/mesh_opts.h
new file mode 100644
index 0000000..cd18fb1
--- /dev/null
+++ b/drivers/net/wireless/libertas/mesh_opts.h
@@ -0,0 +1,5 @@
+
+struct mesh_options {
+	unsigned char (*get_sock_ttl)(struct sock*);
+};
+
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 194f033..497c227 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -9,6 +9,10 @@
 #include "defs.h"
 #include "dev.h"
 #include "wext.h"
+#include "mesh_opts.h"
+
+
+static struct mesh_options mesh_opts = { NULL };
 
 /**
  *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE 
@@ -122,15 +126,34 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
 	lbs_dbg_hex("txpd", (u8 *) plocaltxpd, sizeof(struct txpd));
 	
 	if (IS_MESH_FRAME(skb)) {
-		plocaltxpd->tx_control |= TxPD_MESH_FRAME;
+		struct txpd_mesh msh_txpd;
+ 		plocaltxpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
+
+		memset(&msh_txpd, 0, sizeof(msh_txpd));
+
+		if (mesh_opts.get_sock_ttl)
+			msh_txpd.ttl = (*mesh_opts.get_sock_ttl)(skb->sk);
+
+		/* ttl of zero is never sent to the hardware */
+		if (msh_txpd.ttl) {
+			/* make room for the mesh descriptor that follows */
+			plocaltxpd->tx_packet_location = cpu_to_le32(
+				sizeof(struct txpd) + sizeof(msh_txpd));
+
+			memcpy(ptr + sizeof(struct txpd), &msh_txpd, 
+					sizeof(msh_txpd));
+			lbs_dbg_hex("txpd_mesh", (u8 *) &msh_txpd, 
+					sizeof(msh_txpd));
+		}
 	}
 
 	memcpy(ptr, plocaltxpd, sizeof(struct txpd));
 
-	ptr += sizeof(struct txpd);
+	ptr += le32_to_cpu(plocaltxpd->tx_packet_location);
 
-	lbs_dbg_hex("Tx Data", (u8 *) p802x_hdr, plocaltxpd->tx_packet_length);
-	memcpy(ptr, p802x_hdr, plocaltxpd->tx_packet_length);
+	lbs_dbg_hex("Tx Data", (u8 *) p802x_hdr, 
+			le16_to_cpu(plocaltxpd->tx_packet_length));
+	memcpy(ptr, p802x_hdr, le16_to_cpu(plocaltxpd->tx_packet_length));
 	ret = priv->hw_host_to_card(priv, MVMS_DAT,
 		priv->adapter->tmptxbuf,
 		plocaltxpd->tx_packet_length +
@@ -287,4 +310,19 @@ void libertas_send_tx_feedback(wlan_private * priv)
 		netif_wake_queue(priv->mesh_dev);
 	}
 }
+
+int libertas_register_mesh_opts(struct mesh_options *opts)
+{
+	mesh_opts.get_sock_ttl = opts->get_sock_ttl;
+	return 0;
+}
+
+int libertas_unregister_mesh_opts(struct mesh_options *opts)
+{
+	mesh_opts.get_sock_ttl = NULL;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(libertas_register_mesh_opts);
+EXPORT_SYMBOL_GPL(libertas_unregister_mesh_opts);
 EXPORT_SYMBOL_GPL(libertas_send_tx_feedback);
diff --git a/include/linux/in.h b/include/linux/in.h
index 1912e7c..a69e2ab 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -102,6 +102,9 @@ struct in_addr {
 #define MCAST_LEAVE_SOURCE_GROUP	47
 #define MCAST_MSFILTER			48
 
+#define MESH_SO_SET_TTL 		50
+#define MESH_SO_GET_TTL 		50	
+
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1
 
-- 
1.4.4.2




_______________________________________________
libertas-dev mailing list
libertas-dev@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/libertas-dev

--=-FcxpAnyuMqhZmcCv85Al--

