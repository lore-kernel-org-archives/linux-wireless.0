Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:55319 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3IVWmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:35 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so1917188lab.22
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:34 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 00/16] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
Date: Sun, 22 Sep 2013 23:41:57 +0100
Message-Id: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_004238_959828_C9E601F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
far WCN3660/WCN3680 is available only on MSM platform.

While waiting for a merge window to be opened a lot of changes were added to wcn36xx. The main goal of changes was to move all properties from wcn36xx struct to wcn36xx_vif and wcn36xx_sta structs.

To make review easier the driver sent in several patches, one patch per file, but after
review it will be sent as one big file.

Firmware can be found here:
https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS

Wiki page is available here:
http://wireless.kernel.org/en/users/Drivers/wcn36xx

A lot people made a contribution to this driver. Her is the list in
alphabetical order:

Eugene Krasnikov <k.eugene.e@gmail.com>
Kalle Valo <kvalo@qca.qualcomm.com>
Olof Johansson <dev@skyshaper.net>
Pontus Fuchs <pontus.fuchs@gmail.com>
Yanbo Li <yanbol@qti.qualcomm.com>

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>

Eugene Krasnikov (16):
  wcn36xx: add main.c
  wcn36xx: add wcn36xx.h
  wcn36xx: add debug.c
  wcn36xx: add debug.h
  wcn36xx: add dxe.h
  wcn36xx: add dxe.c
  wcn36xx: add hal.h
  wcn36xx: add pmc.h
  wcn36xx: add pmc.c
  wcn36xx: add smd.c
  wcn36xx: add smd.h
  wcn36xx: add txrx.h
  wcn36xx: add txrx.c
  wcn36xx: add Kconfig
  wcn36xx: add Makefile
  wcn36xx: add wcn36xx to ath Makefile and Kconfig

 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/wcn36xx/Kconfig   |   16 +
 drivers/net/wireless/ath/wcn36xx/Makefile  |    7 +
 drivers/net/wireless/ath/wcn36xx/debug.c   |  188 ++
 drivers/net/wireless/ath/wcn36xx/debug.h   |   49 +
 drivers/net/wireless/ath/wcn36xx/dxe.c     |  805 +++++
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  284 ++
 drivers/net/wireless/ath/wcn36xx/hal.h     | 4657 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/main.c    | 1036 +++++++
 drivers/net/wireless/ath/wcn36xx/pmc.c     |   62 +
 drivers/net/wireless/ath/wcn36xx/pmc.h     |   33 +
 drivers/net/wireless/ath/wcn36xx/smd.c     | 2121 +++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h     |  127 +
 drivers/net/wireless/ath/wcn36xx/txrx.c    |  284 ++
 drivers/net/wireless/ath/wcn36xx/txrx.h    |  160 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  238 ++
 17 files changed, 10069 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Kconfig
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Makefile
 create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/hal.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/main.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/wcn36xx.h

-- 
1.8.1.2

