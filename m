Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44621 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab1K3Uqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 15:46:33 -0500
Received: by lagw12 with SMTP id w12so290792lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2011 12:46:31 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v3 0/4] Fix the way ANI is being handled for ar9100 and ar9340
Date: Wed, 30 Nov 2011 15:46:16 -0500
Message-Id: <1322685980-8757-1-git-send-email-mar.kolya@gmail.com> (sfid-20111130_214637_133984_71D4ADFA)
In-Reply-To: <20111130201051.GC2477@tuxdriver.com>
References: <20111130201051.GC2477@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  I'm really sorry that I missed all those tabs-vs-spaces. Please accept my apologies.
  I think I've now fixed all problems and checkpatch.pl doesn't report
any issues. Please let me know if there are still style problems.
  Thanks!

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
  Also, this patchset enables ANI for ar9100 - ANI was always performed
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
 drivers/net/wireless/ath/ath9k/hw.c           |    6 +++++-
 drivers/net/wireless/ath/ath9k/main.c         |   13 ++++++++-----
 5 files changed, 17 insertions(+), 9 deletions(-)

-- 
1.7.4.1

