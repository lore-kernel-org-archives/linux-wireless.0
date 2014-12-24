Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17388 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLXH71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 02:59:27 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 0/8] ath10k: add per station debugfs support
Date: Wed, 24 Dec 2014 13:29:01 +0530
Message-ID: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141224_085931_080005_F8FE93DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches add support for sending addba/addba response/delba
for every station entries. These commands are purely for testing purpose.

Before using any of the above aggregation commands, the mode should be moved
to manual. To disable automatic aggretation in target

echo 1 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
        stations/XX:XX:XX:XX:XX:XX/aggr_mode

Then for sending addba request,

echo 1 32 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
        stations/XX:XX:XX:XX:XX:XX/addba

To send addba response,

echo 0 25 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
        stations/XX:XX:XX:XX:XX:XX/addba_resp

And for delba,

echo 0 1 37 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
        stations/XX:XX:XX:XX:XX:XX/delba

v2: Rebased on top of 10.2.4 WMI ops support

Rajkumar Manoharan (8):
  ath10k: add wmi support for addba_clear_resp
  ath10k: add wmi support for addba_send
  ath10k: add wmi support for addba_set_resp
  ath10k: add wmi support for delba_send
  ath10k: Implement sta_add_debugfs
  ath10k: add support to send addba request
  ath10k: add support to send addba response
  ath10k: add support to send delba

 drivers/net/wireless/ath/ath10k/Makefile      |   1 +
 drivers/net/wireless/ath/ath10k/core.h        |   5 +
 drivers/net/wireless/ath/ath10k/debug.h       |  11 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 256 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |   3 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h     |  78 ++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c     |   4 +
 drivers/net/wireless/ath/ath10k/wmi.c         | 119 ++++++++++++
 8 files changed, 476 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/debugfs_sta.c

-- 
2.2.1

