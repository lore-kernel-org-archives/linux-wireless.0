Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26553 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1LRCA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 21:00:59 -0500
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Support for TCP checksum offload to firmware
Date: Sat, 17 Dec 2011 18:00:30 -0800
Message-ID: <1324173631-14594-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111218_030103_051152_71B782AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change enables offloading TCP checksum calculation to firmware.
This has been achieved by adding a module param called csum_offload.
The support has been added for QA team's testing purposes and currently
there is no plan to offload the feature to firmware by default.
To enable TCP checksum offload, at the time of loading the ath6kl
driver, add 'csum_offload=1' to the load instruction as follows:
insmod ath6kl_sdio.ko csum_offload=1

Rishi Panjwani (1):
  ath6kl: Support for TCP checksum offload to firmware

 drivers/net/wireless/ath/ath6kl/core.h |    2 +
 drivers/net/wireless/ath/ath6kl/init.c |    7 ++++++
 drivers/net/wireless/ath/ath6kl/txrx.c |   38 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 ++
 4 files changed, 45 insertions(+), 5 deletions(-)

