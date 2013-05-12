Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65356 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3ELLoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:05 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/7] wil6210 patches
Date: Sun, 12 May 2013 14:43:31 +0300
Message-ID: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134409_938373_5AE7F533)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next bunch of patches.

This time it is all about data path, save for trace support.

Vladimir Kondratiev (7):
  wil6210: 'length' in Tx/Rx descriptors is little endian
  wil6210: Sanity check for reported DMA length
  wil6210: debug dump packet content right after DMA
  wil6210: trace support
  wil6210: use NAPI
  wil6210: fix remaining use of non-cached copy of tx/rx descriptors
  wil6210: do not stop Tx queue on packet drop

 drivers/net/wireless/ath/wil6210/Kconfig     |  12 ++
 drivers/net/wireless/ath/wil6210/Makefile    |  21 ++-
 drivers/net/wireless/ath/wil6210/debug.c     |  70 ++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |   8 +-
 drivers/net/wireless/ath/wil6210/interrupt.c |  29 ++--
 drivers/net/wireless/ath/wil6210/main.c      |   6 +
 drivers/net/wireless/ath/wil6210/netdev.c    |  54 ++++++
 drivers/net/wireless/ath/wil6210/trace.c     |  20 +++
 drivers/net/wireless/ath/wil6210/trace.h     | 235 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c      | 175 ++++++++++++--------
 drivers/net/wireless/ath/wil6210/txrx.h      |  32 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  26 ++-
 drivers/net/wireless/ath/wil6210/wmi.c       |   8 +-
 13 files changed, 589 insertions(+), 107 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/debug.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.h

-- 
1.8.1.2

