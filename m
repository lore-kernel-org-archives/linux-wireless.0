Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46863 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0I1PHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:07:53 -0400
Received: by wyb28 with SMTP id 28so5050275wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 08:07:52 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 0/2] wl1271: Packet aggregation optimizations
Date: Tue, 28 Sep 2010 17:07:42 +0200
Message-Id: <1285686464-8668-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WL1271 HW supports sending and receiving multiple packets within
a single transaction. This can substantially reduce CPU usage and
increase network throughput.

The following patches add support for RX and TX packet aggregation.
An opportunistic approach was taken - all packets that are currently
available for sending/receiving are aggregated and transferred
in a single transaction.

The patches were tested on a Zoom2 platform (SDIO only).

Ido Yariv (2):
  wl1271: Support firmware RX packet aggregation
  wl1271: Support firmware TX packet aggregation

 drivers/net/wireless/wl12xx/wl1271.h      |    5 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   15 ++++-
 drivers/net/wireless/wl12xx/wl1271_rx.c   |   63 ++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   99 +++++++++++------------------
 4 files changed, 103 insertions(+), 79 deletions(-)

