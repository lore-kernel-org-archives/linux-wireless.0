Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1043 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbZD3T4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/9] ath5k updates
Date: Thu, 30 Apr 2009 15:55:43 -0400
Message-Id: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This series has Nick's patches for tx power, AP mode, beacon fixes, 
and antenna diversity that were posted earlier in patches 1-7.  I 
corrected the overly long changelogs, fixed one sparse warning, and 
tacked another txpower and an LED patch onto the end.

Bob Copeland (1):
  ath5k: use ctl settings based on current regdomain

Jiri Slaby (1):
  ath5k: Enable AP mode

Nick Kossifidis (6):
  ath5k: Allow user/driver to set txpower
  ath5k: Read Spur channels from EEPROM
  ath5k: Put remaining EEPROM data on ee struct
  ath5k: Beaconing fixes
  ath5k: Implement antenna control
  ath5k: Add Spur filter support on newer chips

Paride Legovini (1):
  Add LED support for AR5BXB6 IBM Thinkpad PCIe adapters

 drivers/net/wireless/ath/ath5k/ath5k.h  |   37 ++-
 drivers/net/wireless/ath/ath5k/attach.c |    1 -
 drivers/net/wireless/ath/ath5k/base.c   |  140 ++++++---
 drivers/net/wireless/ath/ath5k/eeprom.c |   69 ++++--
 drivers/net/wireless/ath/ath5k/eeprom.h |   46 +++-
 drivers/net/wireless/ath/ath5k/led.c    |    6 +-
 drivers/net/wireless/ath/ath5k/pcu.c    |    4 +-
 drivers/net/wireless/ath/ath5k/phy.c    |  493 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath5k/qcu.c    |    7 +-
 drivers/net/wireless/ath/ath5k/reg.h    |    9 +-
 drivers/net/wireless/ath/ath5k/reset.c  |   70 ++---
 11 files changed, 724 insertions(+), 158 deletions(-)


