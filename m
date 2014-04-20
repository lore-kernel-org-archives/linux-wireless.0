Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34964 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDTLGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:05 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so2925182eek.15
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/9][wireless-next] b43: update N-PHY code
Date: Sun, 20 Apr 2014 13:05:42 +0200
Message-Id: <1397991951-13478-1-git-send-email-zajec5@gmail.com> (sfid-20140420_130643_860413_F0EAE990)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This patchset contains
1) Fixes for some mistakes noticed while comparing MMIO dumps
2) Preparing code for some newer hw support
3) Calibration fixes

It was tested for obvious regressions (in a simple home environment) using:
1) BCM4321
2) BCM4322
3) BCM43224
(connectivity to PSK2 and performance with iperf was tested).

I believe BCM43224 behaves a bit more stable, I expect this patchset to
improve situation with BCM43222 a bit as well.

Rafał Miłecki (9):
  b43: N-PHY: drop second noise variance table
  b43: N-PHY: rev3+: complete workarounds
  b43: N-PHY: random updates and typo fixes all around
  b43: N-PHY: implement reading support for radio 0x2057
  b43: N-PHY: implement RF control INTC for revs 7+
  b43: N-PHY: prepare for rev 7+ RSSI calibration
  b43: N-PHY: add init & calib values for radio 0x2056 rev 11
  b43: N-PHY: fix selection of init & calib values
  b43: N-PHY: enable forgotten write of hw power adjust table

 drivers/net/wireless/b43/phy_n.c       | 272 ++++++++++++++++++---
 drivers/net/wireless/b43/radio_2056.c  | 418 +++++++++++++++++++++++++++------
 drivers/net/wireless/b43/tables_nphy.c |  72 +-----
 drivers/net/wireless/b43/tables_nphy.h |   3 +-
 4 files changed, 592 insertions(+), 173 deletions(-)

-- 
1.8.4.5

