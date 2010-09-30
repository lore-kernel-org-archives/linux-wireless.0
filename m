Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0I3ILH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 04:11:07 -0400
Received: by bwz11 with SMTP id 11so1176761bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 01:11:05 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 0/3] wl1271: Packet aggregation optimizations
Date: Thu, 30 Sep 2010 10:10:56 +0200
Message-Id: <1285834259-3178-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WL1271 HW supports sending and receiving multiple packets within
a single transaction. This can substantially reduce CPU usage and
increase network throughput.

The following patches add support for RX and TX packet aggregation.
An opportunistic approach was taken - all packets that are currently
available for sending/receiving are aggregated and transferred
in a single transaction.

On SPI platforms, tests done by Juuso Oikarinen have shown a 20% improvement
in CPU usage.
On SDIO platforms, some tests have shown an improvement of over 30% in CPU
usage.

Changes since v1:
The SPI callbacks do not handle large transfers well. The first patch fixes
this by fragmenting large transfers into smaller ones.

Thanks Juuso Oikarinen for reporting the SPI issue and helping with testing
and benchmarking these optimizations.

Ido Yariv (3):
  wl1271: Handle large SPI transfers
  wl1271: Support firmware RX packet aggregation
  wl1271: Support firmware TX packet aggregation

 drivers/net/wireless/wl12xx/wl1271.h      |    5 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   15 +++-
 drivers/net/wireless/wl12xx/wl1271_rx.c   |   63 ++++++++++----
 drivers/net/wireless/wl12xx/wl1271_spi.c  |  132 ++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   99 ++++++++--------------
 5 files changed, 185 insertions(+), 129 deletions(-)

