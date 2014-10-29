Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62722 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbaJ2PDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:03:04 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/2] brcmsmac: fix and expose 802.11 core statistics
Date: Wed, 29 Oct 2014 16:02:49 +0100
Message-ID: <1414594971-26389-1-git-send-email-arend@broadcom.com> (sfid-20141029_160308_258911_C3108BC8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When looking at exposing the 802.11 core statistics a problem was found
in code obtaining the statistics from the device. This series fixes that
and exposes the statistics in debugfs. Hopefully this can reveal what
is causing connectivity issues on certain bcm4313 chipsets.

The series is intended for 3.19 and applies to the master branch of
the wireless-next repository.

Arend van Spriel (2):
  brcmsmac: fix statistic counter update function
  brcmsmac: expose 802.11 core statistics in debugfs

 drivers/net/wireless/brcm80211/brcmsmac/debug.c | 166 +++++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |  18 +--
 2 files changed, 142 insertions(+), 42 deletions(-)

-- 
1.9.1

