Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57498 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1G2VnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 17:43:07 -0400
Received: by iyb12 with SMTP id 12so4402910iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 14:43:06 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: [PATCH v7 0/4] hostapd: add ACS support
Date: Fri, 29 Jul 2011 14:42:56 -0700
Message-Id: <1311975780-26602-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110729_234312_139763_36B2D997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a full respin of the ACS patches due to a merge
conflict after a rebase based on today's tree.

The all in one git am'able patch patch is available at:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/hostapd/acs-all-in-one-v7.patch

On my box with AR9280 it takes me this amount of time to get an ACS
channel, with the new 60ms interval for offchannel operation.

real    0m3.979s
user    0m0.004s
sys     0m0.056s

Luis R. Rodriguez (4):
  hostapd: split up channel checking into helpers
  hostapd: add offchannel support
  hostapd: add survey dump support
  hostapd: add Automatic Channel Selection (ACS) support

 hostapd/Makefile             |   13 ++
 hostapd/config_file.c        |   47 +++++-
 hostapd/defconfig            |   25 +++
 hostapd/hostapd.conf         |   17 ++
 src/ap/acs.c                 |  460 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h                 |   40 ++++
 src/ap/ap_config.c           |   15 ++
 src/ap/ap_config.h           |    4 +
 src/ap/ap_drv_ops.h          |   26 +++
 src/ap/drv_callbacks.c       |  138 +++++++++++++
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   24 +++
 src/ap/hw_features.c         |  188 +++++++++++------
 src/drivers/driver.h         |  171 ++++++++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++
 15 files changed, 1293 insertions(+), 70 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

-- 
1.7.4.15.g7811d

