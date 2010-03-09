Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:34629 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751027Ab0CIHzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:16 -0500
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0421951313
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:14 +0900 (JST)
Subject: [PATCH 00/13] all my ath5k patches
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:12 +0900
Message-ID: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since it must be difficult for john to track all the different revisions of my
patches i send them here again as a clean series.

two of them are new:
  ath5k: add debugfs file frameerrors
  ath5k: Minor EEPROM documentation updates

others may be slightly updated.

greetings,
bruno

---

Bruno Randolf (13):
      ath5k: add antenna statistics and debugfs file for antenna settings
      ath5k: use fixed antenna for tx descriptors
      ath5k: preserve antenna settings
      ath5k: fix TSF reset
      ath5k: remove double opmode definition
      ath5k: remove ah_magic
      ath5k: remove ah_mac_revision
      ath5k: remove ah_gpio_npins
      ath5k: add debugfs file frameerrors
      ath5k: fix I/Q calibration (for real)
      ath5k: read eeprom IQ calibration values correctly for G mode
      ath5k: IQ calibration for AR5211 is slightly different
      ath5k: Minor EEPROM documentation updates


 drivers/net/wireless/ath/ath5k/ath5k.h  |    7 -
 drivers/net/wireless/ath/ath5k/attach.c |    5 -
 drivers/net/wireless/ath/ath5k/base.c   |   43 +++++-
 drivers/net/wireless/ath/ath5k/base.h   |   20 +++
 drivers/net/wireless/ath/ath5k/caps.c   |    3 
 drivers/net/wireless/ath/ath5k/debug.c  |  212 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h  |    2 
 drivers/net/wireless/ath/ath5k/desc.c   |    6 -
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +
 drivers/net/wireless/ath/ath5k/eeprom.h |   88 +++++++++----
 drivers/net/wireless/ath/ath5k/pcu.c    |   14 +-
 drivers/net/wireless/ath/ath5k/phy.c    |   51 ++++---
 drivers/net/wireless/ath/ath5k/reg.h    |    3 
 drivers/net/wireless/ath/ath5k/reset.c  |   31 ++---
 14 files changed, 396 insertions(+), 97 deletions(-)

-- 
Signature
