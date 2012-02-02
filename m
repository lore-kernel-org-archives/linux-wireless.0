Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58320 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2BBKSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:18:39 -0500
Received: by werb13 with SMTP id b13so1675044wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:18:38 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] wl12xx: re-enable auto-arp
Date: Thu,  2 Feb 2012 12:22:08 +0200
Message-Id: <1328178131-28938-1-git-send-email-eliad@wizery.com> (sfid-20120202_111842_580966_91FCA80F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

auto-arp used to cause various issues when enabled. however,
after some fixes both in the driver and fw side, it seems to
work well. re-enable it.

Eliad Peller (3):
  wl12xx: consider encryption and QoS in auto arp template
  wl12xx: Revert "wl12xx: disable auto-arp"
  wl12xx: configure arp filtering only after association

 drivers/net/wireless/wl12xx/cmd.c          |   88 +++++++++++++++++++++------
 drivers/net/wireless/wl12xx/cmd.h          |    3 +-
 drivers/net/wireless/wl12xx/debugfs.c      |    1 +
 drivers/net/wireless/wl12xx/init.c         |    6 +-
 drivers/net/wireless/wl12xx/main.c         |   83 +++++++++++++++++---------
 drivers/net/wireless/wl12xx/tx.c           |   11 ++--
 drivers/net/wireless/wl12xx/tx.h           |    4 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |    6 ++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 9 files changed, 144 insertions(+), 60 deletions(-)

-- 
1.7.6.401.g6a319

