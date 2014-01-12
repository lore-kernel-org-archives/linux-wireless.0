Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaALIlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 03:41:18 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 0/3] wil6210 patches
Date: Sun, 12 Jan 2014 10:41:01 +0200
Message-ID: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140112_094129_835304_E2065A69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the previour submission, bug was found by kbuild, see below.
It is about incorrect #include, one I used do not work for the
architectures lacking native prefetch().

Re-submitting all series.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   1e2f9295f4c657500111514f92a3d3894d0e05b4
commit: 1cbbcb08c786964a16773c39f2536f1923c73c58 [135/140] wil6210: prefetch head of packet
config: make ARCH=microblaze allyesconfig

All error/warnings:

   drivers/net/wireless/ath/wil6210/txrx.c: In function 'wil_vring_reap_rx':
>> drivers/net/wireless/ath/wil6210/txrx.c:381:2: error: implicit declaration of function 'prefetch' [-Werror=implicit-function-declaration]
     prefetch(skb->data);
     ^
   cc1: some warnings being treated as errors

vim +/prefetch +381 drivers/net/wireless/ath/wil6210/txrx.c

   375                  wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
   376                  kfree_skb(skb);
   377                  return NULL;
   378          }
   379          skb_trim(skb, dmalen);
   380  
 > 381          prefetch(skb->data);
   382  
   383          wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
   384                            skb->data, skb_headlen(skb), false);

Vladimir Kondratiev (3):
  wil6210: interrupt moderation
  wil6210: Fix IP version indication for Tx csum offload
  wil6210: prefetch head of packet

 drivers/net/wireless/ath/wil6210/interrupt.c | 13 +++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  8 ++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
1.8.3.2

