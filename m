Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55504 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3HNGBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 02:01:52 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH-resend 0/9] ath5k/ath9k: respin/resend 5/10 MHz and CSA patches
Date: Wed, 14 Aug 2013 08:01:29 +0200
Message-Id: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130814_080209_559452_20478F08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains the rebased patches for 5/10 MHz and channel switch
announcement for ath5k/ath9k as sent in their respective series earlier. No
modification was made. Since Johannes picked the nl/cfg/mac80211 parts
only, these patches are still missing in the tree. John reported some
trouble building with these patches, but I couldn't see any problems here.

The series is based on wireless-testing of todays master. Please tell
me if there are any problems (including compiler errors and kernel config)
so I can rework if neccesary.

Thanks!
	Simon

Simon Wunderlich (9):
  ath9k: always use SIFS times from OFDM for 5/10 MHz
  ath9k: use chandef instead of channel_type
  ath9k: report 5/10 MHz channels
  ath9k: set 5/10 MHz supported channels and fix bitrate
  ath9k: announce that ath9k supports 5/10 MHz
  ath5k: report 5/10 MHz channels
  ath5k: set 5/10 MHz supported channels and fix duration
  ath5k: enable support for 5 MHz and 10 MHz channels
  ath9k: enable CSA functionality in ath9k

 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |   59 ++++++++++++++++++----
 drivers/net/wireless/ath/ath5k/base.h         |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c          |    2 +
 drivers/net/wireless/ath/ath5k/qcu.c          |   25 ++++++++-
 drivers/net/wireless/ath/ath9k/ath9k.h        |    2 +
 drivers/net/wireless/ath/ath9k/beacon.c       |   21 ++++++++
 drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++++++++++----------
 drivers/net/wireless/ath/ath9k/common.h       |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    5 +-
 drivers/net/wireless/ath/ath9k/init.c         |   30 +++++++----
 drivers/net/wireless/ath/ath9k/main.c         |   25 +++++++--
 drivers/net/wireless/ath/ath9k/rc.c           |    9 +++-
 drivers/net/wireless/ath/ath9k/recv.c         |   11 ++++
 drivers/net/wireless/ath/ath9k/xmit.c         |    2 +
 17 files changed, 206 insertions(+), 65 deletions(-)

-- 
1.7.10.4

