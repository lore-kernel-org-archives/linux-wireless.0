Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33830 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488Ab2FGJRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:35 -0400
Received: by lags15 with SMTP id s15so251251lag.6
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:32 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/5] wl18xx: add initial support for PG2.0 HW
Date: Thu,  7 Jun 2012 12:17:20 +0300
Message-Id: <1339060645-3574-1-git-send-email-coelho@ti.com> (sfid-20120607_111739_353618_BA3E6F85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are some patches to add support for PG2.0.  In the near future we
will remove support for PG1.0 to keep the code simple and since nobody
should be using that old R&D hardware version anymore, but for now we
support both.

Please review.

Cheers,
Luca.

Ido Reis (5):
  wl18xx: fix PHY_INIT addresses mem size
  wl18xx: support PG2 version of the chip
  wl18xx: FW/PHY arguments added for PG2
  wl18xx: PG2.0 HW Watch dog interrupt support
  wl18xx: pad only last frame in aggregration buffer for PG2

 drivers/net/wireless/ti/wl12xx/acx.h    |   14 ++++++
 drivers/net/wireless/ti/wl12xx/main.c   |    5 +-
 drivers/net/wireless/ti/wl18xx/acx.h    |   20 ++++++++
 drivers/net/wireless/ti/wl18xx/conf.h   |    4 ++
 drivers/net/wireless/ti/wl18xx/main.c   |   77 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ti/wl18xx/reg.h    |    7 +++
 drivers/net/wireless/ti/wl18xx/tx.h     |    3 ++
 drivers/net/wireless/ti/wlcore/acx.h    |   27 +++++------
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 ++++
 drivers/net/wireless/ti/wlcore/main.c   |   13 +++++-
 drivers/net/wireless/ti/wlcore/tx.c     |   16 +++++--
 drivers/net/wireless/ti/wlcore/tx.h     |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    4 ++
 13 files changed, 170 insertions(+), 33 deletions(-)

-- 
1.7.10

