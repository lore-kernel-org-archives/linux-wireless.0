Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37617 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBRBKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:33 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so7433893eek.32
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:32 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 0/7] rtl818x: second bunch of fixes ported from rtl8187se merge process 
Date: Tue, 18 Feb 2014 02:10:39 +0100
Message-Id: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021037_096233_1B620EC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on rtl818x driver for adding rtl8187se support I have
made some fixes and improvements unrelated to rtl8187se support itself.

In this second patch set I include the following seven changes:

andrea merello (7):
  rtl818x: Explicitly enable contetion window
  rtl818x: pci_iomap() should pair with pci_iounmap()
  rtl818x: check for pci_map_single() success when initializing RX ring
  rtl818x: make dev_alloc_skb() null pointer check to really work
  rtl818x: add comments to explain few not obvious HW configs
  rtl818x: Make sure the TX descriptor "valid" flag is written by last
  rtl818x: make sure TX descriptor writes are done before kicking DMA

 drivers/net/wireless/rtl818x/rtl8180/dev.c | 48 +++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

-- 
1.8.3.2

