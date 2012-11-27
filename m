Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42690 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab2K0Nwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:41 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqfJ6031464
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:41 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqfAu014237
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:41 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 0/6] wlcore/wl18xx/wl12xx: firmware version checks
Date: Tue, 27 Nov 2012 15:51:55 +0200
Message-ID: <1354024321-20635-1-git-send-email-coelho@ti.com> (sfid-20121127_145245_077738_76BF1BA3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This a patchset to try to make as much sense as possible from the
firmware version checks.  Unfortunately, wl12xx and wl18xx have
different rules for each of the available fields, so we need to
compromise and make it generic enough so that it works with both
chips.

Cheers,
Luca

Luciano Coelho (6):
  wlcore/wl12xx: move wl12xx chip ID defines to the lower driver
  wlcore/wl12xx: remove deprecated FW version check
  wlcore: change way of checking the firmware version
  wl12xx: ignore some of the firmware version fields
  wlcore/wl12xx/wl18xx: verify multi-role and single-role fw versions
  wl18xx: ignore irrelevant firmware version fields

 drivers/net/wireless/ti/wl12xx/main.c     |   67 ++++++++++++-----------------
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |   38 +++++++++++-----
 drivers/net/wireless/ti/wl18xx/main.c     |    8 ++--
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    6 +--
 drivers/net/wireless/ti/wlcore/boot.c     |   58 ++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/wlcore.h   |   38 +++++++++-------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   11 -----
 7 files changed, 121 insertions(+), 105 deletions(-)

-- 
1.7.10.4

