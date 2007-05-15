Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbXEOW2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 18:28:53 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id l4FMSmqo016672
	for <linux-wireless@vger.kernel.org>; Tue, 15 May 2007 15:28:48 -0700
Received: from akpm.corp.google.com (akpm.corp.google.com [172.18.116.160])
	by zps76.corp.google.com with SMTP id l4FMSjGq030212
	for <linux-wireless@vger.kernel.org>; Tue, 15 May 2007 15:28:45 -0700
Date: Tue, 15 May 2007 15:28:45 -0700
From: Andrew Morton <akpm@google.com>
To: linux-wireless@vger.kernel.org
Subject: wireless warnings
Message-Id: <20070515152845.f27b49b5.akpm@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mac80211/adm8211/adm8211.c: In function 'adm8211_interrupt_rci':
drivers/net/wireless/mac80211/adm8211/adm8211.c:501: warning: passing argument 2 of '__memcpy' makes pointer from integer without a cast
drivers/net/wireless/mac80211/adm8211/adm8211.c:501: warning: passing argument 2 of '__builtin_memcpy' makes pointer from integer without a cast
drivers/net/wireless/mac80211/adm8211/adm8211.c:523: warning: passing argument 2 of 'pci_map_single' makes pointer from integer without a cast
drivers/net/wireless/mac80211/adm8211/adm8211.c: In function 'adm8211_init_rings':
drivers/net/wireless/mac80211/adm8211/adm8211.c:1542: warning: passing argument 2 of 'pci_map_single' makes pointer from integer without a cast
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c: In function 'bcm43xx_chip_reset':
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c:3473: warning: 'err' may be used uninitialized in this function
drivers/net/wireless/mac80211/p54/prism54usb.c: In function 'p54u_rx_cb':
drivers/net/wireless/mac80211/p54/prism54usb.c:103: warning: assignment makes pointer from integer without a cast
drivers/net/wireless/mac80211/p54/prism54usb.c: In function 'p54u_init_urbs':
drivers/net/wireless/mac80211/p54/prism54usb.c:141: warning: passing argument 4 of 'usb_fill_bulk_urb' makes pointer from integer without a cast
drivers/net/wireless/mac80211/p54/prism54pci.c: In function 'p54p_refill_rx_ring':
drivers/net/wireless/mac80211/p54/prism54pci.c:261: warning: passing argument 2 of 'pci_map_single' makes pointer from integer without a cast


Some of these are pointing at serious bustage.  The kind which goes oops.
