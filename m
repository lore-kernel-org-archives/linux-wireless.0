Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45762 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaH1CvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 22:51:16 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so130122wes.5
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 19:51:15 -0700 (PDT)
Message-ID: <53FE9920.2040702@gmail.com> (sfid-20140828_045130_496991_BF2D5C0B)
Date: Thu, 28 Aug 2014 04:51:12 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] MediaTek Inc. MT7601U Wireless Adapter
References: <53FCC55B.90705@gmail.com> <20140826182849.GE30445@tuxdriver.com> <53FD7BFA.1040304@maya.org> <20140827135550.GD15173@tuxdriver.com>
In-Reply-To: <20140827135550.GD15173@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A patch[1] is composed partly from the RT3573 source code patched by ashaffer, from Andreas work, some of the ideas are from the beagleboard community, and some of my. :)
Debug(trace) is turned off.

Device now works more or less OK but slow, max. 10 Mbit, although connectable is only within the "N" & "N/G" modes.
What is important is the system no longer crashes, and disconnection are rare.
Generally better than before.

Tested with kernels:
3.15.10-200.fc20.x86_64
3.16.1-301.fc21.x86_64
3.17.0-0.rc2.git0.1.fc22.x86_64

and with debug kernel:
3.17.0-0.rc2.git1.1.fc22.x86_64
dmesg:
...
mt7601Usta: module verification failed: signature and/or  required key missing - tainting kernel
rtusb init rt2870 --->
usbcore: registered new interface driver rt2870
0x1300 = 00064300
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 687 Comm: NetworkManager Tainted: G           OE  3.17.0-0.rc2.git1.1.fc22.x86_64 #1
...
Call Trace:
 [<ffffffff81823d70>] dump_stack+0x4d/0x66
 [<ffffffff8182126b>] register_lock_class.part.25+0x38/0x3c
 [<ffffffff810fc0c9>] __lock_acquire+0x1c79/0x1ca0
 [<ffffffff810e335c>] ? update_curr+0x5c/0x200
 [<ffffffff8102429e>] ? native_sched_clock+0x2e/0xb0
 [<ffffffff810fc9d4>] lock_acquire+0xa4/0x1d0
 [<ffffffff810efa0c>] ? add_wait_queue+0x1c/0x50
 [<ffffffff8182d6d7>] _raw_spin_lock_irqsave+0x57/0xa0
 [<ffffffff810efa0c>] ? add_wait_queue+0x1c/0x50
 [<ffffffff810efa0c>] add_wait_queue+0x1c/0x50
 [<ffffffffa0715d54>] RtmpOsUsbEmptyUrbCheck+0xc4/0x140 [mt7601Usta]
 [<ffffffff810d8820>] ? wake_up_state+0x20/0x20
 [<ffffffffa06dc3bd>] RTMPDrvClose+0x8d/0x150 [mt7601Usta]
 [<ffffffffa0704b52>] rt28xx_close+0x22/0x30 [mt7601Usta]
 [<ffffffffa06e7223>] RTMP_COM_IoctlHandle+0x823/0x890 [mt7601Usta]
 [<ffffffff816f02b8>] ? linkwatch_schedule_work+0x58/0xa0
 [<ffffffff816f0357>] ? linkwatch_fire_event+0x57/0xa0
 [<ffffffffa070498c>] MainVirtualIF_close+0x7c/0xd0 [mt7601Usta]
 [<ffffffffa07050e0>] ? RtmpOSIRQRequest+0x60/0x60 [mt7601Usta]
 [<ffffffffa0704b30>] ? RT28xx_get_ether_stats+0x150/0x150 [mt7601Usta]
 [<ffffffff816d08a5>] __dev_close_many+0xb5/0x120
 [<ffffffff816d0a72>] __dev_close+0x42/0x70
 [<ffffffff816dcc8d>] __dev_change_flags+0x9d/0x160
 [<ffffffff816dcd79>] dev_change_flags+0x29/0x70
 [<ffffffff816ec0a9>] do_setlink+0x409/0xb80
 [<ffffffff810fa887>] ? __lock_acquire+0x437/0x1ca0
 [<ffffffff81422392>] ? nla_parse+0x32/0x120
 [<ffffffff816ee5cd>] rtnl_newlink+0x61d/0x780
 [<ffffffff81377218>] ? security_capable+0x18/0x20
 [<ffffffff810aaeb5>] ? ns_capable+0x35/0x70
 [<ffffffff816eae31>] rtnetlink_rcv_msg+0xa1/0x260
 [<ffffffff816ead6b>] ? rtnetlink_rcv+0x1b/0x40
 [<ffffffff816ead6b>] ? rtnetlink_rcv+0x1b/0x40
 [<ffffffff816ead90>] ? rtnetlink_rcv+0x40/0x40
 [<ffffffff81710e69>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff816ead7a>] rtnetlink_rcv+0x2a/0x40
 [<ffffffff81710475>] netlink_unicast+0x125/0x1a0
 [<ffffffff8171084f>] netlink_sendmsg+0x35f/0x7c0
 [<ffffffff816b880e>] sock_sendmsg+0x9e/0xe0
 [<ffffffff811fe38e>] ? might_fault+0x5e/0xc0
 [<ffffffff811fe3e9>] ? might_fault+0xb9/0xc0
 [<ffffffff811fe38e>] ? might_fault+0x5e/0xc0
 [<ffffffff816b9848>] ___sys_sendmsg+0x408/0x420
 [<ffffffff8102429e>] ? native_sched_clock+0x2e/0xb0
 [<ffffffff8102429e>] ? native_sched_clock+0x2e/0xb0
 [<ffffffff81024329>] ? sched_clock+0x9/0x10
 [<ffffffff810dc775>] ? local_clock+0x25/0x30
 [<ffffffff8127b54a>] ? __fget+0x12a/0x2f0
 [<ffffffff8127b425>] ? __fget+0x5/0x2f0
 [<ffffffff8127b780>] ? __fget_light+0x30/0x160
 [<ffffffff816ba031>] __sys_sendmsg+0x51/0x90
 [<ffffffff816ba082>] SyS_sendmsg+0x12/0x20
 [<ffffffff8182dbe9>] system_call_fastpath+0x16/0x1b
unlink cmd rsp urb
0x1300 = 00064300
unlink cmd rsp urb
0x1300 = 00064300
unlink cmd rsp urb
0x1300 = 00064300
...

# iwconfig ra0 
ra0       Ralink STA  ESSID:"Geppetto"  Nickname:"MT7601STA"
          Mode:Managed  Frequency=2.462 GHz  Access Point: 00:22:44:66:88:aa   
          Bit Rate=26 Mb/s   
          RTS thr:off   Fragment thr:off
          Encryption key:1111-2222-3333-4444-5555-6666-7777-8888 [2]   Security mode:open
          Link Quality=61/100  Signal level:-72 dBm  Noise level:-87 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


[1] DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0.patch
diff -ur DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/include/os/rt_linux.h DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/include/os/rt_linux.h
--- DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/include/os/rt_linux.h	2013-09-12 07:27:14.000000000 +0200
+++ DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/include/os/rt_linux.h	2014-08-28 02:09:13.823643901 +0200
@@ -882,9 +882,14 @@
 		
 #define GET_OS_PKT_DATATAIL(_pkt) \
 		(RTPKT_TO_OSPKT(_pkt)->tail)
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+#define SET_OS_PKT_DATATAIL(_pkt, _start, _len)	\
+		((RTPKT_TO_OSPKT(_pkt))->tail) = (ULONG)(RTPKT_TO_OSPKT(_pkt)->data - (ULONG)(RTPKT_TO_OSPKT(_pkt)->head) + (_len))
+#else
 #define SET_OS_PKT_DATATAIL(_pkt, _start, _len)	\
 		((RTPKT_TO_OSPKT(_pkt))->tail) = (PUCHAR)((_start) + (_len))
-		
+#endif
+
 #define GET_OS_PKT_HEAD(_pkt) \
 		(RTPKT_TO_OSPKT(_pkt)->head)
 
diff -ur DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/os/linux/config.mk DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/os/linux/config.mk
--- DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/os/linux/config.mk	2013-09-12 08:05:55.000000000 +0200
+++ DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/os/linux/config.mk	2014-08-28 02:09:32.557529121 +0200
@@ -290,7 +290,7 @@
 # config for STA mode
 
 ifeq ($(RT28xx_MODE),STA)
-WFLAGS += -DCONFIG_STA_SUPPORT -DSCAN_SUPPORT -DDBG
+WFLAGS += -DCONFIG_STA_SUPPORT -DSCAN_SUPPORT
 
 ifeq ($(HAS_XLINK),y)
 WFLAGS += -DXLINK_SUPPORT
@@ -1054,11 +1054,16 @@
 export CFLAGS
 endif
 
+GCCVERSION = $(shell gcc -dumpversion)
+
 ifeq ($(PLATFORM),PC)
     ifneq (,$(findstring 2.4,$(LINUX_SRC)))
 	# Linux 2.4
 	CFLAGS := -D__KERNEL__ -I$(LINUX_SRC)/include -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686 -DMODULE -DMODVERSIONS -include $(LINUX_SRC)/include/linux/modversions.h $(WFLAGS)
 	export CFLAGS
+    else ifneq (,$(findstring 4.9,$(GCCVERSION)))
+	# GCC 4.9
+        EXTRA_CFLAGS := -Wno-error=date-time $(WFLAGS)
     else
 	# Linux 2.6
 	EXTRA_CFLAGS := $(WFLAGS) 
diff -ur DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/os/linux/rt_linux.c DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/os/linux/rt_linux.c
--- DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/os/linux/rt_linux.c	2013-09-12 07:27:14.000000000 +0200
+++ DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/os/linux/rt_linux.c	2014-08-28 02:09:13.838643009 +0200
@@ -27,13 +27,18 @@
 
 #define RTMP_MODULE_OS
 #define RTMP_MODULE_OS_UTIL
-
+#define CONFIG_UIDGID_STRICT_TYPE_CHECKS
+#define NET_SKBUFF_DATA_USES_OFFSET
 
 #include "rtmp_comm.h"
 #include "rtmp_osabl.h"
 #include "rt_os_util.h"
 #include <linux/rtnetlink.h>
 
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+#include <linux/uidgid.h>
+#endif
+
 #if defined(CONFIG_RA_HW_NAT) || defined(CONFIG_RA_HW_NAT_MODULE)
 #include "../../../../../../net/nat/hw_nat/ra_nat.h"
 #include "../../../../../../net/nat/hw_nat/frame_engine.h"
@@ -494,9 +499,15 @@
 		MEM_DBG_PKT_ALLOC_INC(skb);
 
 		skb_reserve(skb, 2);
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+		NdisMoveMemory(skb->data+skb->tail, pHeader802_3, HdrLen);
+		skb_put(skb, HdrLen);
+		NdisMoveMemory(skb->data+skb->tail, pData, DataSize);
+#else
 		NdisMoveMemory(skb->tail, pHeader802_3, HdrLen);
 		skb_put(skb, HdrLen);
 		NdisMoveMemory(skb->tail, pData, DataSize);
+#endif
 		skb_put(skb, DataSize);
 		skb->dev = pNetDev;	/*get_netdev_from_bssid(pAd, FromWhichBSSID); */
 		pPacket = OSPKT_TO_RTPKT(skb);
@@ -692,7 +703,11 @@
 	pOSPkt->dev = pNetDev;
 	pOSPkt->data = pData;
 	pOSPkt->len = DataSize;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	pOSPkt->tail = (pOSPkt->data-pOSPkt->head)+pOSPkt->len;
+#else
 	pOSPkt->tail = pOSPkt->data + pOSPkt->len;
+#endif
 
 	/* copy 802.3 header */
 
@@ -1118,9 +1133,15 @@
 		pOSFSInfo->fsgid = current->fsgid;
 		current->fsuid = current->fsgid = 0;
 #else
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+		struct user_namespace *to = current_user_ns();
+		pOSFSInfo->fsuid = from_kuid_munged(to, current_fsuid());
+		pOSFSInfo->fsgid = from_kgid_munged(to, current_fsgid());
+#else
 		pOSFSInfo->fsuid = current_fsuid();
 		pOSFSInfo->fsgid = current_fsgid();
 #endif
+#endif
 		pOSFSInfo->fs = get_fs();
 		set_fs(KERNEL_DS);
 	} else {
diff -ur DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/sta/sta_cfg.c DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/sta/sta_cfg.c
--- DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/sta/sta_cfg.c	2013-09-12 07:27:14.000000000 +0200
+++ DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0/sta/sta_cfg.c	2014-08-28 02:09:13.842642771 +0200
@@ -8274,6 +8274,7 @@
 			RTMPIoctlGetSiteSurvey(pAd, pRequest);
 			break;
 
+#ifdef DBG
 		case CMD_RTPRIV_IOCTL_MAC:
 			RTMPIoctlMAC(pAd, pRequest);
 			break;
@@ -8285,6 +8286,7 @@
 		case CMD_RTPRIV_IOCTL_RF:
 			RTMPIoctlRF(pAd, pRequest);
 			break;
+#endif /* DBG */
 
 		case CMD_RTPRIV_IOCTL_BBP:
 			RTMPIoctlBbp(pAd, pRequest, pData, Data);


poma




