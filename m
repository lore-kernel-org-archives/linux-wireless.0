Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57651 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LEIvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 03:51:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 00/12] ath9k initval updates
Date: Thu,  5 Dec 2013 14:16:05 +0530
Message-Id: <1386233177-11132-1-git-send-email-sujith@msujith.org> (sfid-20131205_095105_019030_B7B1FE31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series updates initvals for the AR9003/AR9004 family.

AR9300 v2.2
------------

* Update the high_power TX gain table that is used by default
  for v2.2 cards.

* Handle the Buffalo-specific array via platform_data for
  the specific device - an OpenWrt patch for WZR-HP-G450H will be
  sent once the backports package is updated.

AR9331 v1.1/v1.2
-----------------

* Updates for radio/baseband arrays.
  These probably require HW code updates (hence the RFC).

AR955x/AR9485/AR9462/AR9565
---------------------------

* Remove a number of duplicates, reducing module size.

DFS
----

* Use DFS-specific baseband parameters when using a DFS channel.

With this series, all the INI files have been updated, verify_checksum shows:

ar9003-2p2     e08640f0fc48a9a2a5f90699bd530123b238b4b1 pass
ar9330-1p1     4e08677bf31000d97bcccfbe82b03bbb068376c3 pass
ar9330-1p2     688f60aac1986d9c09043c03c3917936dedb48b9 pass
ar9340         8817822fa8eeb9cd71f50258fb21dab3078524e7 pass
ar9462-1p0     da39a3ee5e6b4b0d3255bfef95601890afd80709 pass
ar9485         e73550261601ea10d6bfec752a57fb43bae3cfb4 pass
ar955x-1p0     afeaaa07c1833c69642a3a5fc5cbd6b24ce8515b pass
ar9565-1p0     d03982594e7e6ef2a7eac0bbe601379580ed3af3 pass
ar9580-1p0     1134cdb72d89a643b94ecb6475a7c5e0ddaa1637 pass

All the initval tool changes have been pushed to:
https://github.com/sujith/qca-swiss-army-knife/commits/master

Sujith

Sujith Manoharan (12):
  ath9k: Add initval arrays for DFS channels
  ath9k: Initialize baseband for DFS channels
  ath9k: Update mac_postamble for AR9003 family
  ath9k: Remove AR955x INI duplicates
  ath9k: Update AR9331 v1.1 initvals
  ath9k: Update AR9331 v1.2 initvals
  ath9k: Add a new flag for Buffalo devices
  ath9k: Use a separate TX gain table for WZR-HP-G450H
  ath9k: Update high power gain table for AR9300
  ath9k: Identify duplicate AR9485 initvals
  ath9k: Identify duplicate AR9462 v2.0 initvals
  ath9k: Identify duplicate AR9565 v1.0 initvals

 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 191 +++---
 .../wireless/ath/ath9k/ar9003_buffalo_initvals.h   | 126 ++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  18 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   6 +
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   | 128 +---
 .../net/wireless/ath/ath9k/ar9330_1p2_initvals.h   | 401 ++++++++++--
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   |   2 +
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   | 697 +++------------------
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   | 117 +---
 .../net/wireless/ath/ath9k/ar955x_1p0_initvals.h   | 540 +---------------
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   |  85 +--
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |  13 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   2 +
 drivers/net/wireless/ath/ath9k/init.c              |  36 +-
 include/linux/ath9k_platform.h                     |   2 +
 15 files changed, 749 insertions(+), 1615 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h

-- 
1.8.4.2

