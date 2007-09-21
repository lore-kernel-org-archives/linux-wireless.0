Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXIUDIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 23:08:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Zhu Yi <chuyee@santarosa.sh.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.24] iwlwifi: create own directory for iwlwifi driver
Date: Fri, 21 Sep 2007 11:00:59 +0800
Message-Id: <11903436591320-git-send-email-yi.zhu@intel.com>
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <chuyee@santarosa.sh.intel.com>

	drivers/net/wireless/iwlwifi/

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

http://intellinuxwireless.org/iwlwifi/0002-iwlwifi-create-own-directory-for-iwlwifi-driver.patch

---
 drivers/net/wireless/Kconfig                |  130 +-
 drivers/net/wireless/Makefile               |    6 +-
 drivers/net/wireless/iwl-3945-hw.h          |  118 -
 drivers/net/wireless/iwl-3945-rs.c          |  982 ---
 drivers/net/wireless/iwl-3945-rs.h          |  191 -
 drivers/net/wireless/iwl-3945.c             | 2300 -------
 drivers/net/wireless/iwl-3945.h             |   41 -
 drivers/net/wireless/iwl-4965-hw.h          |  581 --
 drivers/net/wireless/iwl-4965-rs.c          | 2123 ------
 drivers/net/wireless/iwl-4965-rs.h          |  266 -
 drivers/net/wireless/iwl-4965.c             | 4736 --------------
 drivers/net/wireless/iwl-4965.h             |  341 -
 drivers/net/wireless/iwl-channel.h          |  161 -
 drivers/net/wireless/iwl-commands.h         | 1734 -----
 drivers/net/wireless/iwl-debug.h            |  149 -
 drivers/net/wireless/iwl-eeprom.h           |  336 -
 drivers/net/wireless/iwl-helpers.h          |  255 -
 drivers/net/wireless/iwl-hw.h               |  537 --
 drivers/net/wireless/iwl-io.h               |  470 --
 drivers/net/wireless/iwl-priv.h             |  308 -
 drivers/net/wireless/iwl-prph.h             |  229 -
 drivers/net/wireless/iwl-spectrum.h         |   91 -
 drivers/net/wireless/iwl3945-base.c         | 8749 -------------------------
 drivers/net/wireless/iwl4965-base.c         | 9338 ---------------------------
 drivers/net/wireless/iwlwifi.h              |  713 --
 drivers/net/wireless/iwlwifi/Kconfig        |  128 +
 drivers/net/wireless/iwlwifi/Makefile       |    5 +
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |  118 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |  982 +++
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |  191 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     | 2300 +++++++
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   41 +
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |  581 ++
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  | 2123 ++++++
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |  266 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     | 4736 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.h     |  341 +
 drivers/net/wireless/iwlwifi/iwl-channel.h  |  161 +
 drivers/net/wireless/iwlwifi/iwl-commands.h | 1734 +++++
 drivers/net/wireless/iwlwifi/iwl-debug.h    |  149 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |  336 +
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |  255 +
 drivers/net/wireless/iwlwifi/iwl-hw.h       |  537 ++
 drivers/net/wireless/iwlwifi/iwl-io.h       |  470 ++
 drivers/net/wireless/iwlwifi/iwl-priv.h     |  308 +
 drivers/net/wireless/iwlwifi/iwl-prph.h     |  229 +
 drivers/net/wireless/iwlwifi/iwl-spectrum.h |   91 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c | 8749 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c | 9338 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwlwifi.h      |  713 ++
 50 files changed, 34884 insertions(+), 34883 deletions(-)
 delete mode 100644 drivers/net/wireless/iwl-3945-hw.h
 delete mode 100644 drivers/net/wireless/iwl-3945-rs.c
 delete mode 100644 drivers/net/wireless/iwl-3945-rs.h
 delete mode 100644 drivers/net/wireless/iwl-3945.c
 delete mode 100644 drivers/net/wireless/iwl-3945.h
 delete mode 100644 drivers/net/wireless/iwl-4965-hw.h
 delete mode 100644 drivers/net/wireless/iwl-4965-rs.c
 delete mode 100644 drivers/net/wireless/iwl-4965-rs.h
 delete mode 100644 drivers/net/wireless/iwl-4965.c
 delete mode 100644 drivers/net/wireless/iwl-4965.h
 delete mode 100644 drivers/net/wireless/iwl-channel.h
 delete mode 100644 drivers/net/wireless/iwl-commands.h
 delete mode 100644 drivers/net/wireless/iwl-debug.h
 delete mode 100644 drivers/net/wireless/iwl-eeprom.h
 delete mode 100644 drivers/net/wireless/iwl-helpers.h
 delete mode 100644 drivers/net/wireless/iwl-hw.h
 delete mode 100644 drivers/net/wireless/iwl-io.h
 delete mode 100644 drivers/net/wireless/iwl-priv.h
 delete mode 100644 drivers/net/wireless/iwl-prph.h
 delete mode 100644 drivers/net/wireless/iwl-spectrum.h
 delete mode 100644 drivers/net/wireless/iwl3945-base.c
 delete mode 100644 drivers/net/wireless/iwl4965-base.c
 delete mode 100644 drivers/net/wireless/iwlwifi.h
 create mode 100644 drivers/net/wireless/iwlwifi/Kconfig
 create mode 100644 drivers/net/wireless/iwlwifi/Makefile
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-rs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-channel.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-commands.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-debug.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-helpers.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-io.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-priv.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-prph.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl3945-base.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl4965-base.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwlwifi.h
