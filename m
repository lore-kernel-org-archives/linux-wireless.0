Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51117 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1K1AW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 19:22:28 -0500
Received: by vbbfc26 with SMTP id fc26so3356107vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 16:22:28 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 0/4] Fix the way ANI is being handled for ar9100 and ar9340
Date: Sun, 27 Nov 2011 19:22:10 -0500
Message-Id: <1322439734-14520-1-git-send-email-mar.kolya@gmail.com> (sfid-20111128_012232_213059_56DA7509)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently in ath9k code there is an attempt which is meant to
disable ANI for ar9100 and ar9340. But it doesn't really achieve
this. All it does is disable ANI init and setup (i.e. calls to
ath9k_hw_ani_setup and ath9k_hw_ani_init). Since ath9k_hw_ani_setup is
not called ah->config.ani_poll_interval is never initialized (i.e. it
is always zero) and ath_ani_calibrate always executes ANI procedures
(over uninitialized ANI parameters).
  Moreover, ath_ani_calibrate is being called each 1ms because
common->ani.timer is set to zero interval because
ah->config.ani_poll_interval==0 (and thus smallest value of all
intervals). Normally it should not be called this often.
  This patch changes the code so config.enable_ani is used to check if
ANI should be performed.
  Also, this pacthset enables ANI for ar9100 - ANI was always performed
for this chip, but this patch fixes the fact that it was performed
over uninitialized data.

  All comments and suggestions are appreciated.
  Thanks.

Nikolay Martynov (4):
  ath9k: trivial: cosmetic fix in calibration debug log
  ath9k: change calibration debug log to output all calibration types
  ath9k: use config.enable_ani to check if ani should be performed
  ath9k: enable ANI for ar9100 chips

 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/main.c         |   12 +++++++-----
 5 files changed, 19 insertions(+), 12 deletions(-)

-- 
1.7.4.1

