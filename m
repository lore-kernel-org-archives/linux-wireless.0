Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61830 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab1FWDvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 23:51:00 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 20:50:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <hostap@lists.shmoo.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] hostapd: add ACS support
Date: Wed, 22 Jun 2011 20:50:49 -0700
Message-ID: <1308801053-2461-1-git-send-email-lrodriguez@atheros.com> (sfid-20110623_055105_040813_5F0171B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds ACS support to hostapd. I've completed
a few of my own TODOs and splitted up the patches as
best as possible. I'm pretty satisfied with this code now
as an initial start for ACS code. At this point we need
to start finding ideal values for the metrics for offchannel
operation so that we can consistently always find the same
channel, even if it means surveying longer or doing more
scans.

Other algorithms for ACS shoudl be easy to plug in, for example,
spectral scan ;)

Anyway, to enable and test this thing just set CONFIG_ACS=1
on your build config and then something like this on your
hostapd.conf:

channel=acs_survey
acs_num_req_surveys=10
acs_roc_duration_ms=100

Test results, rants are appreciated.

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

