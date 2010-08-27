Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42110 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0H0SlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] compat-wireless: do not use needed_headroom
Date: Fri, 27 Aug 2010 20:40:47 +0200
Message-Id: <1282934453-18093-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

needed_headroom was introduced in kernel 2.6.26.
Resize hard_header_len instead as it was done before using
needed_headroom.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index bb6b30d..e168105 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -278,7 +278,7 @@ without creating a headache on maintenance of the pathes.
  	dev->tx_queue_len = 0;
 --- a/drivers/net/wireless/orinoco/main.c
 +++ b/drivers/net/wireless/orinoco/main.c
-@@ -2268,9 +2268,9 @@ int orinoco_if_add(struct orinoco_privat
+@@ -2268,14 +2268,18 @@ int orinoco_if_add(struct orinoco_privat
  #endif
  	/* Default to standard ops if not set */
  	if (ops)
@@ -290,6 +290,15 @@ without creating a headache on maintenance of the pathes.
  
  	/* we use the default eth_mac_addr for setting the MAC addr */
  
+ 	/* Reserve space in skb for the SNAP header */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+ 	dev->needed_headroom = ENCAPS_OVERHEAD;
++#else
++	dev->hard_header_len += ENCAPS_OVERHEAD;
++#endif
+ 
+ 	netif_carrier_off(dev);
+ 
 --- a/net/bluetooth/bnep/netdev.c
 +++ b/net/bluetooth/bnep/netdev.c
 @@ -170,8 +170,12 @@ static inline int bnep_net_proto_filter(
-- 
1.7.0.4

