Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1JUOZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG2Q-0008VW-9b
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:34 +0200
Message-Id: <20111021142429.250845759@sipsolutions.net> (sfid-20111021_162539_015709_12EB3AE0)
Date: Fri, 21 Oct 2011 16:23:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 08/12] net: add wireless TX status socket option
References: <20111021142322.229128720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The 802.1X EAPOL handshake hostapd does requires
knowing whether the frame was ack'ed by the peer.
Currently, we fudge this pretty badly by not even
transmitting the frame as a normal data frame but
injecting it with radiotap and getting the status
out of radiotap monitor as well. This is rather
complex, confuses users (mon.wlan0 presence) and
doesn't work with all hardware.

To get rid of that hack, introduce a real wifi TX
status option for data frame transmissions.

This works similar to the existing TX timestamping
in that it reflects the SKB back to the socket's
error queue with a SCM_WIFI_STATUS cmsg that has
an int indicating ACK status (0/1).

Since it is possible that at some point we will
want to have TX timestamping and wifi status in a
single errqueue SKB (there's little point in not
doing that), redefine SO_EE_ORIGIN_TIMESTAMPING
to SO_EE_ORIGIN_TXSTATUS which can collect more
than just the timestamp; keep the old constant
as an alias of course. Currently the internal APIs
don't make that possible, but it wouldn't be hard
to split them up in a way that makes it possible.

Thanks to Neil Horman for helping me figure out
the functions that add the control messages.

TODO:
 * sock_tx_timestamp() function should be renamed,
   maybe to sock_tx_status()?
 * sock_recv_timestamp() should also be renamed,
   I had a hard time figuring out the difference
   between that and sock_recv_ts_and_drops(). The
   former is generic, while the latter adds RX
   information only, maybe that should be reflected
   in new names?

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 arch/alpha/include/asm/socket.h   |    3 +++
 arch/arm/include/asm/socket.h     |    3 +++
 arch/avr32/include/asm/socket.h   |    3 +++
 arch/cris/include/asm/socket.h    |    3 +++
 arch/frv/include/asm/socket.h     |    3 +++
 arch/h8300/include/asm/socket.h   |    3 +++
 arch/ia64/include/asm/socket.h    |    3 +++
 arch/m32r/include/asm/socket.h    |    3 +++
 arch/m68k/include/asm/socket.h    |    3 +++
 arch/mips/include/asm/socket.h    |    3 +++
 arch/mn10300/include/asm/socket.h |    3 +++
 arch/parisc/include/asm/socket.h  |    3 +++
 arch/powerpc/include/asm/socket.h |    3 +++
 arch/s390/include/asm/socket.h    |    3 +++
 arch/sparc/include/asm/socket.h   |    3 +++
 arch/xtensa/include/asm/socket.h  |    3 +++
 include/asm-generic/socket.h      |    3 +++
 include/linux/errqueue.h          |    3 ++-
 include/linux/skbuff.h            |   19 +++++++++++++++++--
 include/net/sock.h                |    7 +++++++
 net/core/skbuff.c                 |   20 ++++++++++++++++++++
 net/core/sock.c                   |    9 +++++++++
 net/socket.c                      |   19 +++++++++++++++++++
 23 files changed, 125 insertions(+), 3 deletions(-)

--- a/include/asm-generic/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/include/asm-generic/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -64,4 +64,7 @@
 #define SO_DOMAIN		39
 
 #define SO_RXQ_OVFL             40
+
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS	SO_WIFI_STATUS
 #endif /* __ASM_GENERIC_SOCKET_H */
--- a/net/core/sock.c	2011-10-21 10:20:39.000000000 +0200
+++ b/net/core/sock.c	2011-10-21 12:07:43.000000000 +0200
@@ -743,6 +743,11 @@ set_rcvbuf:
 		else
 			sock_reset_flag(sk, SOCK_RXQ_OVFL);
 		break;
+
+	case SO_WIFI_STATUS:
+		sock_valbool_flag(sk, SOCK_WIFI_STATUS, valbool);
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -964,6 +969,10 @@ int sock_getsockopt(struct socket *sock,
 		v.val = !!sock_flag(sk, SOCK_RXQ_OVFL);
 		break;
 
+	case SO_WIFI_STATUS:
+		v.val = !!sock_flag(sk, SOCK_WIFI_STATUS);
+		break;
+
 	default:
 		return -ENOPROTOOPT;
 	}
--- a/include/net/sock.h	2011-10-21 10:20:39.000000000 +0200
+++ b/include/net/sock.h	2011-10-21 12:07:43.000000000 +0200
@@ -564,6 +564,7 @@ enum sock_flags {
 	SOCK_FASYNC, /* fasync() active */
 	SOCK_RXQ_OVFL,
 	SOCK_ZEROCOPY, /* buffers from userspace */
+	SOCK_WIFI_STATUS, /* push wifi status to userspace */
 };
 
 static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)
@@ -1705,7 +1706,10 @@ static inline int sock_intr_errno(long t
 
 extern void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	struct sk_buff *skb);
+extern void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
+	struct sk_buff *skb);
 
+/* XXX: rename this function now? */
 static __inline__ void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 {
@@ -1732,6 +1736,9 @@ sock_recv_timestamp(struct msghdr *msg,
 		__sock_recv_timestamp(msg, sk, skb);
 	else
 		sk->sk_stamp = kt;
+
+	if (sock_flag(sk, SOCK_WIFI_STATUS) && skb->wifi_acked_valid)
+		__sock_recv_wifi_status(msg, sk, skb);
 }
 
 extern void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
--- a/arch/alpha/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/alpha/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -69,6 +69,9 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 /* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
  * have to define SOCK_NONBLOCK to a different value here.
  */
--- a/arch/arm/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/arm/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
--- a/arch/avr32/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/avr32/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* __ASM_AVR32_SOCKET_H */
--- a/arch/cris/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/cris/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -64,6 +64,9 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
 
 
--- a/arch/frv/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/frv/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,5 +62,8 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
 
--- a/arch/h8300/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/h8300/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
--- a/arch/ia64/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/ia64/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -71,4 +71,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_IA64_SOCKET_H */
--- a/arch/m32r/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/m32r/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_M32R_SOCKET_H */
--- a/arch/m68k/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/m68k/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
--- a/arch/mips/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/mips/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -82,6 +82,9 @@ To add: #define SO_REUSEPORT 0x0200	/* A
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #ifdef __KERNEL__
 
 /** sock_type - Socket types
--- a/arch/mn10300/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/mn10300/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -62,4 +62,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
--- a/arch/parisc/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/parisc/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -61,6 +61,9 @@
 
 #define SO_RXQ_OVFL             0x4021
 
+#define SO_WIFI_STATUS		0x4022
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 /* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
  * have to define SOCK_NONBLOCK to a different value here.
  */
--- a/arch/powerpc/include/asm/socket.h	2011-10-21 10:20:39.000000000 +0200
+++ b/arch/powerpc/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -69,4 +69,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif	/* _ASM_POWERPC_SOCKET_H */
--- a/arch/s390/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/s390/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -70,4 +70,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif /* _ASM_SOCKET_H */
--- a/arch/sparc/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/sparc/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -58,6 +58,9 @@
 
 #define SO_RXQ_OVFL             0x0024
 
+#define SO_WIFI_STATUS		0x0025
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 /* Security levels - as per NRL IPv6 - don't actually do anything */
 #define SO_SECURITY_AUTHENTICATION		0x5001
 #define SO_SECURITY_ENCRYPTION_TRANSPORT	0x5002
--- a/arch/xtensa/include/asm/socket.h	2011-10-21 10:20:38.000000000 +0200
+++ b/arch/xtensa/include/asm/socket.h	2011-10-21 12:07:43.000000000 +0200
@@ -73,4 +73,7 @@
 
 #define SO_RXQ_OVFL             40
 
+#define SO_WIFI_STATUS		41
+#define SCM_WIFI_STATUS		SO_WIFI_STATUS
+
 #endif	/* _XTENSA_SOCKET_H */
--- a/include/linux/errqueue.h	2011-10-21 10:20:39.000000000 +0200
+++ b/include/linux/errqueue.h	2011-10-21 12:07:43.000000000 +0200
@@ -17,7 +17,8 @@ struct sock_extended_err {
 #define SO_EE_ORIGIN_LOCAL	1
 #define SO_EE_ORIGIN_ICMP	2
 #define SO_EE_ORIGIN_ICMP6	3
-#define SO_EE_ORIGIN_TIMESTAMPING 4
+#define SO_EE_ORIGIN_TXSTATUS	4
+#define SO_EE_ORIGIN_TIMESTAMPING SO_EE_ORIGIN_TXSTATUS
 
 #define SO_EE_OFFENDER(ee)	((struct sockaddr*)((ee)+1))
 
--- a/include/linux/skbuff.h	2011-10-21 10:20:39.000000000 +0200
+++ b/include/linux/skbuff.h	2011-10-21 12:07:43.000000000 +0200
@@ -190,6 +190,9 @@ enum {
 
 	/* device driver supports TX zero-copy buffers */
 	SKBTX_DEV_ZEROCOPY = 1 << 4,
+
+	/* generate wifi status information (where possible) */
+	SKBTX_WIFI_STATUS = 1 << 5,
 };
 
 /*
@@ -322,6 +325,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@queue_mapping: Queue mapping for multiqueue devices
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
+ *	@wifi_acked_valid: wifi_acked was set
+ *	@wifi_acked: whether frame was acked on wifi or not
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -414,10 +419,11 @@ struct sk_buff {
 	__u8			ndisc_nodetype:2;
 #endif
 	__u8			ooo_okay:1;
+	__u8			wifi_acked_valid:1;
+	__u8			wifi_acked:1;
+	/* 11/13 bit hole (depending on nodetype presence) */
 	kmemcheck_bitfield_end(flags2);
 
-	/* 0/13 bit hole */
-
 #ifdef CONFIG_NET_DMA
 	dma_cookie_t		dma_cookie;
 #endif
@@ -2062,6 +2068,15 @@ static inline void skb_tx_timestamp(stru
 	sw_tx_timestamp(skb);
 }
 
+/**
+ * skb_complete_wifi_ack - deliver skb with wifi status
+ *
+ * @skb: the original outgoing packet
+ * @acked: ack status
+ *
+ */
+void skb_complete_wifi_ack(struct sk_buff *skb, bool acked);
+
 extern __sum16 __skb_checksum_complete_head(struct sk_buff *skb, int len);
 extern __sum16 __skb_checksum_complete(struct sk_buff *skb);
 
--- a/net/core/skbuff.c	2011-10-21 10:20:39.000000000 +0200
+++ b/net/core/skbuff.c	2011-10-21 12:07:43.000000000 +0200
@@ -3150,6 +3150,26 @@ void skb_tstamp_tx(struct sk_buff *orig_
 }
 EXPORT_SYMBOL_GPL(skb_tstamp_tx);
 
+void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
+{
+	struct sock *sk = skb->sk;
+	struct sock_exterr_skb *serr;
+	int err;
+
+	skb->wifi_acked_valid = 1;
+	skb->wifi_acked = acked;
+
+	serr = SKB_EXT_ERR(skb);
+	memset(serr, 0, sizeof(*serr));
+	serr->ee.ee_errno = ENOMSG;
+	serr->ee.ee_origin = SO_EE_ORIGIN_TXSTATUS;
+
+	err = sock_queue_err_skb(sk, skb);
+	if (err)
+		kfree_skb(skb);
+}
+EXPORT_SYMBOL_GPL(skb_complete_wifi_ack);
+
 
 /**
  * skb_partial_csum_set - set up and verify partial csum values for packet
--- a/net/socket.c	2011-10-21 10:20:39.000000000 +0200
+++ b/net/socket.c	2011-10-21 12:07:43.000000000 +0200
@@ -531,6 +531,7 @@ void sock_release(struct socket *sock)
 }
 EXPORT_SYMBOL(sock_release);
 
+/* XXX: rename this function now */
 int sock_tx_timestamp(struct sock *sk, __u8 *tx_flags)
 {
 	*tx_flags = 0;
@@ -538,6 +539,8 @@ int sock_tx_timestamp(struct sock *sk, _
 		*tx_flags |= SKBTX_HW_TSTAMP;
 	if (sock_flag(sk, SOCK_TIMESTAMPING_TX_SOFTWARE))
 		*tx_flags |= SKBTX_SW_TSTAMP;
+	if (sock_flag(sk, SOCK_WIFI_STATUS))
+		*tx_flags |= SKBTX_WIFI_STATUS;
 	return 0;
 }
 EXPORT_SYMBOL(sock_tx_timestamp);
@@ -674,6 +677,22 @@ void __sock_recv_timestamp(struct msghdr
 }
 EXPORT_SYMBOL_GPL(__sock_recv_timestamp);
 
+void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
+	struct sk_buff *skb)
+{
+	int ack;
+
+	if (!sock_flag(sk, SOCK_WIFI_STATUS))
+		return;
+	if (!skb->wifi_acked_valid)
+		return;
+
+	ack = skb->wifi_acked;
+
+	put_cmsg(msg, SOL_SOCKET, SCM_WIFI_STATUS, sizeof(ack), &ack);
+}
+EXPORT_SYMBOL_GPL(__sock_recv_wifi_status);
+
 static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
 				   struct sk_buff *skb)
 {


