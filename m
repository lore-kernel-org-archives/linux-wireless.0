Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50738 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1KUAtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 19:49:14 -0500
Received: by ghbz2 with SMTP id z2so2246231ghb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 16:49:13 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 0/4] Fix the way ANI is being disabled for ar9100 and ar9340
Date: Sun, 20 Nov 2011 19:48:56 -0500
Message-Id: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com> (sfid-20111121_014918_079008_F9DFCCB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently in ath9k code there is an attempt which is meant to disable ANI for ar9100 and ar9340. But it doesn't really achieve this. All it does is disable ANI init and setup (i.e. calls to ath9k_hw_ani_setup and ath9k_hw_ani_init). Since ath9k_hw_ani_setup is not called ah->config.ani_poll_interval is never initialized (i.e. it is always zero) and ath_ani_calibrate always executes ANI procedures (over uninitialized ANI parameters).
  Moreover, ath_ani_calibrate is being called each 1ms because common->ani.timer is set to zero interval because ah->config.ani_poll_interval==0 (and thus smallest value of all intervals). Normally it should not be called this often.
  This patchset makes use of config.enable_ani to check if ANI should be performed. It sets config.enable_ani to false for appropriate platforms.
  Also last patch in this set enables ANI for ar9100 - it seems to be working fine there (tested on ar9102).

  Question: there are common.disable_ani (and corresponding debugfs file) and config.enable_ani in ath9k code. config.enable_ani sets if ANI is supported and common.disable_ani is meant to disable calibration. This is confusing on a sense that disable_ani completely disables all calibration code including short/long calibration and ANI, not ANI alone. Would it make sense to rename disable_ani to disable_calib and enable_ani to ani_supported?

  All comments and suggestions are appreciated.
  Thanks.

Nikolay Martynov (4):
  ath9k: cosmetic fix in calibration debug log
  ath9k: change calibration debug to log all calibration types
  ath9k: use config.enable_ani to check if ani should be performed
  ath9k: enable ani for 9100

 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/main.c         |   12 +++++++-----
 4 files changed, 18 insertions(+), 11 deletions(-)

-- 
1.7.4.1

