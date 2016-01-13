Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50273 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbcAMJ3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:29:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0D9P1S8014478
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 01:29:52 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 20dkx580a9-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 01:29:52 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 0/6] mwifiex wowlan enahancements
Date: Wed, 13 Jan 2016 01:26:51 -0800
Message-ID: <1452677217-21439-1-git-send-email-akarwar@marvell.com> (sfid-20160113_102957_934748_1AD6B4E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for schedule scan,
wowlan net-detect and reporting wakeup reason to
cfg80211.

Changes in v2:
  Following error reported by kbuild test robot for
  patch 3/6 on m68k architecture has been resolved.
  "'struct wiphy' has no member named 'wowlan_config'"

Amitkumar Karwar (1):
  mwifiex: use SYNC flag for canceling host sleep

Ganapathi Bhat (1):
  mwifiex: add RSSI support for net-detect

Xinming Hu (1):
  mwifiex: add schedule scan support

chunfan chen (3):
  mwifiex: add wowlan info messages
  mwifiex: add wowlan net-detect support
  mwifiex: report wakeup reason to cfg80211

 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 244 ++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  13 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  86 ++++++
 drivers/net/wireless/marvell/mwifiex/ioctl.h       |   5 +
 drivers/net/wireless/marvell/mwifiex/main.c        |  14 +
 drivers/net/wireless/marvell/mwifiex/main.h        |  17 ++
 drivers/net/wireless/marvell/mwifiex/scan.c        | 310 +++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  23 ++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   6 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   7 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  30 ++
 12 files changed, 740 insertions(+), 17 deletions(-)

-- 
1.8.1.4

