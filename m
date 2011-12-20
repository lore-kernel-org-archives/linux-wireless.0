Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17684 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1LTSqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:46:19 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 0/6] atheros-wireless: fix sparse warnings ho ho ho
Date: Tue, 20 Dec 2011 10:46:05 -0800
Message-ID: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194625_501027_3DD2917D)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Here's a slew of sparse warning fixes for all Atheros wireless drivers.
These have been itching me for a while now. I ask all patch submitters
and driver maintainers to please run their patches with these two tests:

make C=1 M=drivers/net/wireless/ath/

And then if all is happy try:

make C=2 CF="-D__CHECK_ENDIAN__" M=drivers/net/wireless/ath/

Luis R. Rodriguez (6):
  ath6kl: fix sparse warning on init.c
  ath9k: make ath_mci_duty_cycle static
  ath9k_hw: fix sparse warnings on ar9003_rtt.c
  ath9k: fix tx queue sparse complaint
  ath5k: avoid sparse warnings on tracing
  ath9k_hw: fix sparse complaint on ar9003_switch_com_spdt_get()

 drivers/net/wireless/ath/ath5k/trace.h         |    5 +++--
 drivers/net/wireless/ath/ath6kl/init.c         |    5 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 ++--
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c    |    1 +
 drivers/net/wireless/ath/ath9k/mci.c           |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c          |    3 +++
 6 files changed, 14 insertions(+), 6 deletions(-)

-- 
1.7.4.15.g7811d

