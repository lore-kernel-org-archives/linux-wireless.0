Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62706 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1GUUwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 16:52:18 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 13:51:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <jouni@qca.qualcomm.com>
CC: <hostap@lists.shmoo.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@qualcomm.com>
Subject: [PATCH v4 0/4] hostapd: add ACS support
Date: Thu, 21 Jul 2011 13:52:10 -0700
Message-ID: <1311281534-10733-1-git-send-email-lrodriguez@atheros.com> (sfid-20110721_225238_489050_911AA0DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <lrodriguez@qualcomm.com>

Here's a v4 which corrects one bug (rather typo) and one uneeded
blank line hunk. This also rebases on top of today's hostapd.git.
This also casts to (unsigned long int) the u64 on debug prints
for the survey as in some compilers it will rant.

For more details please refer to:

http://wireless.kernel.org/en/users/Documentation/acs

You can get the v4 single patch file from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/hostapd/acs-all-in-one-v4.patch

When you run this you should get sometime like:

mcgrof@mouche ~/hostap/hostapd (git::master)$ sudo ./hostapd /home/mcgrof/wpa/hostapd.conf 
Configuration file: /home/mcgrof/wpa/hostapd.conf
ACS: automatic channel selection started, this may take a bit
ACS: Ideal chan: 9 (2452 MHz) Average interference factor: -3.403722
Using interface wlan0 with hwaddr 00:03:7f:11:a3:f3 and ssid 'pogo'

mcgrof@mouche ~/hostap/hostapd (git::master)$ grep acs /home/mcgrof/wpa/hostapd.conf 
channel=acs_survey
acs_num_req_surveys=5
acs_roc_duration_ms=5

Luis R. Rodriguez (4):
  hostapd: split up channel checking into helpers
  hostapd: add offchannel support
  hostapd: add survey dump support
  hostapd: add Automatic Channel Selection (ACS) support

 hostapd/Makefile             |   12 +
 hostapd/config_file.c        |   47 ++++-
 hostapd/defconfig            |   25 +++
 hostapd/hostapd.conf         |   17 ++
 src/ap/acs.c                 |  464 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h                 |   40 ++++
 src/ap/ap_config.c           |   15 ++
 src/ap/ap_config.h           |    4 +
 src/ap/ap_drv_ops.h          |   26 +++
 src/ap/drv_callbacks.c       |  138 +++++++++++++
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   24 +++
 src/ap/hw_features.c         |  188 +++++++++++------
 src/drivers/driver.h         |  171 +++++++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++
 15 files changed, 1296 insertions(+), 70 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

-- 
1.7.4.15.g7811d

