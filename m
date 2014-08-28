Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:53332 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934322AbaH1Hac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 03:30:32 -0400
Subject: [PATCH v2 0/2] ath10k: testmode support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Aug 2014 10:30:28 +0300
Message-ID: <20140828072642.14691.44313.stgit@potku.adurom.net> (sfid-20140828_093035_452044_2CDE8BDA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's v2 of my ath10k testmode patches. I sent v1 back in May, here's the link
to the archives:

http://lists.infradead.org/pipermail/ath10k/2014-May/002254.html

I hope I have addressed all the review comments now.

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


 drivers/net/wireless/ath/ath10k/Makefile   |    1 
 drivers/net/wireless/ath/ath10k/core.c     |   88 ++++--
 drivers/net/wireless/ath/ath10k/core.h     |   22 +-
 drivers/net/wireless/ath/ath10k/debug.c    |    5 
 drivers/net/wireless/ath/ath10k/debug.h    |    1 
 drivers/net/wireless/ath/ath10k/hw.h       |    2 
 drivers/net/wireless/ath/ath10k/mac.c      |   10 +
 drivers/net/wireless/ath/ath10k/testmode.c |  404 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/testmode.h |   46 +++
 drivers/net/wireless/ath/ath10k/wmi.c      |   22 +-
 drivers/net/wireless/ath/ath10k/wmi.h      |    4 
 11 files changed, 572 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.h

