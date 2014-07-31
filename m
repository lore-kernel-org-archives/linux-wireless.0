Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38028 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGaUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:00:43 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so3224150wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:00:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.18 0/7] b43: first series for 3.18
Date: Thu, 31 Jul 2014 21:59:41 +0200
Message-Id: <1406836788-23704-1-git-send-email-zajec5@gmail.com> (sfid-20140731_220047_263442_1EAD430A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, this patchset continues improvements for b43. It doesn't fix any
particular bug/issue, so please queue it for 3.18. There is nothing
important enough to risk breaking wireless-next for 3.17.

Rafał Miłecki (7):
  b43: update flushing many writes performed in a row
  b43: don't duplicate common PHY read/write ops
  b43: flush some writes on Broadcom MIPS SoCs
  b43: N-PHY: update rev3+ gain control workarounds
  b43: N-PHY: add RF power tables for radio 0x2057 revs 9 & 14
  b43: implement PPR (Power Per Rate) management/API
  b43: N-PHY: support setting custom TX power

 drivers/net/wireless/b43/Makefile      |   1 +
 drivers/net/wireless/b43/b43.h         |  16 +++
 drivers/net/wireless/b43/bus.h         |  14 +++
 drivers/net/wireless/b43/main.c        |  17 ++-
 drivers/net/wireless/b43/phy_a.c       |   4 +-
 drivers/net/wireless/b43/phy_common.c  |  25 ++++-
 drivers/net/wireless/b43/phy_g.c       |   8 +-
 drivers/net/wireless/b43/phy_ht.c      |  20 +---
 drivers/net/wireless/b43/phy_lcn.c     |  20 +---
 drivers/net/wireless/b43/phy_lp.c      |  20 +---
 drivers/net/wireless/b43/phy_n.c       | 128 +++++++++++++++------
 drivers/net/wireless/b43/phy_n.h       |   4 +
 drivers/net/wireless/b43/ppr.c         | 199 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/ppr.h         |  45 ++++++++
 drivers/net/wireless/b43/tables_nphy.c | 128 +++++++++++++++++----
 drivers/net/wireless/b43/tables_nphy.h |   2 +
 16 files changed, 523 insertions(+), 128 deletions(-)
 create mode 100644 drivers/net/wireless/b43/ppr.c
 create mode 100644 drivers/net/wireless/b43/ppr.h

-- 
1.8.4.5

