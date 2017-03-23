Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53352 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753152AbdCWNay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 09:30:54 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH v2 0/3] Channels in licensed bands, noise floor override
Date: Thu, 23 Mar 2017 14:30:45 +0100
Message-Id: <20170323133048.30062-1-sw@simonwunderlich.de> (sfid-20170323_143058_959110_90F07D67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the revised series for adding channels in licensed bands and the
noise floor override. Thanks for the previous discussions, I've adopted
suggestions from Zefir and Sebastian accordingly and rebased the series.

For more background info, please check the v1 series:

https://www.spinics.net/lists/linux-wireless/msg160266.html

Cheers,
     Simon
 
Ben Greear (1):
  ath9k: Support channels in licensed bands

Simon Wunderlich (2):
  ath10k: add support for channels in licensed bands
  ath9k: add noise floor override option

 drivers/net/wireless/ath/ath10k/Kconfig      | 20 +++++++++
 drivers/net/wireless/ath/ath10k/core.h       |  4 ++
 drivers/net/wireless/ath/ath10k/mac.c        | 10 +++++
 drivers/net/wireless/ath/ath10k/wmi.c        | 53 +++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/Kconfig       | 20 +++++++++
 drivers/net/wireless/ath/ath9k/calib.c       |  5 ++-
 drivers/net/wireless/ath/ath9k/common-init.c | 15 +++++++
 drivers/net/wireless/ath/ath9k/debug.c       | 62 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h          |  5 +++
 9 files changed, 177 insertions(+), 17 deletions(-)

-- 
2.11.0
