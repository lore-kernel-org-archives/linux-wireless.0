Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbZHDDOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 23:14:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	ath9k-devel@lists.ath9k.org, stephen.chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: add initial ar9271 support
Date: Mon,  3 Aug 2009 23:14:09 -0400
Message-Id: <1249355652-10031-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar9721 is the next generation Atheros 802.11 USB device.
Contrary to ar9170 ar9271 actually has an Atheros based
MAC. ar9271 is a single stream 802.11n device intended
supporting only the 2.4 GHz band. As it is single
stream max supported MCS rate is MCS 7. The devices
do come with 2 antennas for antenna TX/RX diversity.

This series adds the initial hardware ar9271 support
on ath9k. Since the device is USB based and actually does
require firmware a different driver core may be used,
however, we do expect the hardware access to be shared.

I'll send a separate notice about the driver core, am
hoping other interested developers may want to join in on
helping getting that part done. Hope is to get ar9271
supported merged in the 2.6.32-rc series but since the
attached changes are also required I'm sending these early
in the hopes to minimize the required driver core chages
required to support ar9271.

Luis R. Rodriguez (3):
  ath9k: add ar9271 revision and subrevision ID helpers
  ath9k: add initvals and registry definitions for AR9271
  ath9k: add initial hardware support for ar9271

 drivers/net/wireless/ath/ath9k/calib.c    |  106 +++++-
 drivers/net/wireless/ath/ath9k/eeprom.c   |  142 +++++--
 drivers/net/wireless/ath/ath9k/hw.c       |  104 +++++-
 drivers/net/wireless/ath/ath9k/hw.h       |    2 +
 drivers/net/wireless/ath/ath9k/initvals.h |  666 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/phy.h      |    3 +
 drivers/net/wireless/ath/ath9k/reg.h      |   37 ++
 7 files changed, 1020 insertions(+), 40 deletions(-)

