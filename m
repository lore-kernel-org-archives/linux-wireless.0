Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48892 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2INHop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 03:44:45 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20562.57398.203651.913249@gargle.gargle.HOWL> (sfid-20120914_094449_592199_1B134BBF)
Date: Fri, 14 Sep 2012 13:13:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 0/8] AR9565 antenna diversity
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a work in progress to enable WLAN Antenna diversity for AR9565.
Please review !

Sujith

Sujith Manoharan (8):
  ath9k_hw: Use HW cap ATH9K_HW_CAP_ANT_DIV_COMB
  ath9k: Remove redundant variable assignment
  ath9k: Remove a couple of unused variables
  ath9k_hw: Add antenna diversity group for AR9565
  ath9k_hw: Update AR9565 initvals
  ath9k_hw: Add a HW callback to set diversity
  ath9k: Add a module parameter to enable diversity for AR9565
  ath9k_hw: Enable WLAN RX diversity for AR9565

 drivers/net/wireless/ath/ath.h                     |   1 +
 drivers/net/wireless/ath/ath9k/antenna.c           | 117 ++++++++++++---------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  20 ++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  63 +++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  24 +++++
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 100 +++++++++---------
 drivers/net/wireless/ath/ath9k/ath9k.h             |   2 -
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   7 ++
 drivers/net/wireless/ath/ath9k/hw.c                |   6 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   3 +-
 drivers/net/wireless/ath/ath9k/init.c              |  12 +++
 11 files changed, 245 insertions(+), 110 deletions(-)

-- 
1.7.12

