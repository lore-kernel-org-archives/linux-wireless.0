Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36500 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0KLSOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:14:54 -0500
Date: Fri, 12 Nov 2010 13:13:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH] compat-wireless: support backporting bluetooth to RHEL 6
Message-ID: <20101112181348.GG2338@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RHEL kernels in general (and RHEL 6 kernels in particular) often
contain features backported from later upstream kernels.  This means
that the normal KERNEL_VERSION checks are not always correct for RHEL
kernels.  This patch augments a number of such tests to be compatible
with building compat-wireless on RHEL 6 kernels.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This patch contains the bluetooth backporting portions...

diff -up compat-wireless-2.6.36-4/patches/16-bluetooth.patch.orig compat-wireless-2.6.36-4/patches/16-bluetooth.patch
--- compat-wireless-2.6.36-4/patches/16-bluetooth.patch.orig	2010-11-12 12:42:52.602182539 -0500
+++ compat-wireless-2.6.36-4/patches/16-bluetooth.patch	2010-11-12 12:46:36.049287339 -0500
@@ -35,7 +35,7 @@ here still, but for now we keep this her
  }
  EXPORT_SYMBOL(bt_sock_unregister);
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int bt_sock_create(struct net *net, struct socket *sock, int proto,
  			  int kern)
 +#else
@@ -48,7 +48,7 @@ here still, but for now we keep this her
  	read_lock(&bt_proto_lock);
  
  	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  		err = bt_proto[proto]->create(net, sock, proto, kern);
 +#else
 +		err = bt_proto[proto]->create(net, sock, proto);
@@ -127,7 +127,7 @@ here still, but for now we keep this her
  	.obj_size	= sizeof(struct hci_pinfo)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
  			   int kern)
 +#else
@@ -180,7 +180,7 @@ here still, but for now we keep this her
  	return hidp_queue_report(session, buf, rsize);
  }
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
  		unsigned char report_type)
  {
@@ -438,7 +438,7 @@ here still, but for now we keep this her
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int rfcomm_sock_create(struct net *net, struct socket *sock,
  			      int protocol, int kern)
 +#else
@@ -505,7 +505,7 @@ here still, but for now we keep this her
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int sco_sock_create(struct net *net, struct socket *sock, int protocol,
  			   int kern)
 +#else
@@ -532,7 +532,7 @@ here still, but for now we keep this her
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -547,7 +547,7 @@ here still, but for now we keep this her
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -562,7 +562,7 @@ here still, but for now we keep this her
  	.obj_size	= sizeof(struct bt_sock)
  };
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
  			    int kern)
 +#else
@@ -577,7 +577,7 @@ here still, but for now we keep this her
  	return sk;
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)) || (defined(RHEL_MAJOR) && (RHEL_MAJOR == 6))
  static int l2cap_sock_create(struct net *net, struct socket *sock, int protocol,
  			     int kern)
 +#else
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
