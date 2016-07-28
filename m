Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52495 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbcG1IFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:30 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 0/8] Reuse firmware loader helpers
Date: Thu, 28 Jul 2016 09:55:04 +0200
Message-Id: <1469692512-16863-1-git-send-email-wagi@monom.org> (sfid-20160728_100547_882525_C086C90E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi,

While reviewing all the complete_all() users, I realized there is
recouring pattern how the completion API is used to synchronize the
stages of the firmware loading. Since firmware_class.c contains a
fairly complete implemetation for synching the loading, it worthwhile
to export it and reuse it in drivers, At the same time one
complete_all() user is gone which is a good thing for -rt (*).

The first 2 patches are bug fixes for the test script.

Patch 3 adds the new API, and the following patches update a few
drivers.

I haven't updated all the drivers because I wanted to see first if
this is going into the right direction. Since naming is a difficult, I
am more than please to pick a better name if you have one.

cheers,
daniel

(*) Under -rt waking all waiters via complete_all() is not good. If
the complete_all() call happens in IRQ context we have an unbound
latency there. Therefore the aim is to reduce the complete_all() users
and get rid of them where possible.

Daniel Wagner (8):
  selftests: firmware: do not abort test too early
  selftests: firmware: do not clutter output
  firmware: Factor out firmware load helpers
  Input: goodix: use firmware_stat instead of completion
  ath9k_htc: use firmware_stat instead of completion
  remoteproc: use firmware_stat instead of completion
  Input: ims-pcu: use firmware_stat instead of completion
  iwl4965: use firmware_stat instead of completion

 drivers/base/firmware_class.c                     | 112 ++++++++++------------
 drivers/input/misc/ims-pcu.c                      |  10 +-
 drivers/input/touchscreen/goodix.c                |  10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c          |  10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h          |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c    |   8 +-
 drivers/net/wireless/intel/iwlegacy/common.h      |   3 +-
 drivers/remoteproc/remoteproc_core.c              |  10 +-
 drivers/soc/ti/wkup_m3_ipc.c                      |   2 +-
 include/linux/firmware.h                          |  71 ++++++++++++++
 include/linux/remoteproc.h                        |   6 +-
 tools/testing/selftests/firmware/fw_filesystem.sh |   6 +-
 tools/testing/selftests/firmware/fw_userhelper.sh |   2 +-
 13 files changed, 158 insertions(+), 94 deletions(-)

-- 
2.7.4
