Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:54970 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaIDN4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 09:56:45 -0400
Subject: [PATCH v3 0/2] ath10k: testmode support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Sep 2014 16:56:41 +0300
Message-ID: <20140904135447.26750.52873.stgit@potku.adurom.net> (sfid-20140904_155649_947231_DD312B50)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

new version of ath10k testmode support. Only functionality changes were in
ath10k_tm_cmd_utf_start(). The user space interface didn't change from v2.

v3:

* remove false "fall through" comment in ath10k_start() (Michal)

* fix multiline comment style (Michal)

* put testmode interface definitions to testmode_uapi.h (or similar) (Johannes)

* document __set_bit(ar->fw_features) better (Michal)

* ath10k_tm_cmd_utf_start(): return ar->fw_feature value if there's an error

* free firmware in ath10k_tm_cmd_utf_start() when an error happens (Michal)

* ath10k_tm_cmd_utf_start(): move hif_power_down() to err_power_down label


v2:

* check error from ath10k_wmi_alloc_skb() (Michal)

* int err -> int ret (Michal)

* fix conflicts in core.c

* add ar->testmode.utf_monitor to check if ath10k_tm_event_wmi()
  should deliver WMI events or not

* print mode in ath10k_download_fw() log messages

* set ar->testmode.utf to NULL after it's released (Michal)

* release ar->testmode.utf also in ath10k_tm_cmd_utf_stop()

* rename ath10k_testmode_unregister() to ath10k_testmode_destroy()

* call ath10k_core_stop() in ath10k_testmode_destroy() (Michal)

* document wmi packet format in testmode commands (Michal)

* consume WMI packets so that mac80211 calls are not made in UTF mode (Michal)

* force to use 10x WMI interface with UTF firmware

* API change: remove ATH10K_TM_CMD_EVENT_WMI, use ATH10K_TM_CMD_WMI also for events

* API change: add major and minor version numbers to
  ATH10K_TM_CMD_GET_VERSION for the user space more easily to detect
  interface changes

* use conf_mutex in ath10k_tm_cmd_wmi()

* print "UTF firmware started" and "UTF firmware stopped"

* print "testmode %d" in ath10k_print_driver_info()

* don't call ath10k_wait_for_suspend() in UTF mode


---

Kalle Valo (2):
      ath10k: make ath10k_wmi_cmd_send() public
      ath10k: add testmode


 drivers/net/wireless/ath/ath10k/Makefile     |    1 
 drivers/net/wireless/ath/ath10k/core.c       |   88 ++++--
 drivers/net/wireless/ath/ath10k/core.h       |   22 +-
 drivers/net/wireless/ath/ath10k/debug.c      |    5 
 drivers/net/wireless/ath/ath10k/debug.h      |    1 
 drivers/net/wireless/ath/ath10k/hw.h         |    2 
 drivers/net/wireless/ath/ath10k/mac.c        |    9 +
 drivers/net/wireless/ath/ath10k/testmode.c   |  375 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/testmode.h   |   46 +++
 drivers/net/wireless/ath/ath10k/testmode_i.h |   70 +++++
 drivers/net/wireless/ath/ath10k/wmi.c        |   22 +-
 drivers/net/wireless/ath/ath10k/wmi.h        |    4 
 12 files changed, 612 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.h
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode_i.h

