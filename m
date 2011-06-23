Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64063 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab1FWSpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 14:45:00 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 11:44:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/4] hostapd: add ACS support
Date: Thu, 23 Jun 2011 11:44:47 -0700
Message-ID: <1308854691-5958-1-git-send-email-lrodriguez@atheros.com> (sfid-20110623_204504_564591_ED48E0C9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is rebased on top of hostapd.git as of today but also
fixes a typo I made on patch 2 where I put the event within an ifdef,
this means patch 3 would not apply as well.

All in one patch:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/hostapd/acs-all-in-one-v2.patch

Luis R. Rodriguez (4):
  hostapd: split up channel checking into helpers
  hostapd: add offchannel support
  hostapd: add survey dump support
  hostapd: add Automatic Channel Selection (ACS) support

 hostapd/Makefile             |    5 +
 hostapd/config_file.c        |   47 ++++-
 hostapd/defconfig            |   25 +++
 hostapd/hostapd.conf         |   17 ++
 src/ap/acs.c                 |  464 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h                 |   40 ++++
 src/ap/ap_config.c           |   15 ++
 src/ap/ap_config.h           |    4 +
 src/ap/ap_drv_ops.h          |   27 +++
 src/ap/drv_callbacks.c       |  139 +++++++++++++-
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   24 +++
 src/ap/hw_features.c         |  188 +++++++++++------
 src/drivers/driver.h         |  171 +++++++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++
 15 files changed, 1290 insertions(+), 71 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

-- 
1.7.4.15.g7811d

