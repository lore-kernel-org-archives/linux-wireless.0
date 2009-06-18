Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZFRWVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:38 -0400
Received: by ewy6 with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:21:39 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 00/23] orinoco: initiate cfg80211 conversion
Date: Thu, 18 Jun 2009 23:21:12 +0100
Message-Id: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compared to the last RFC, this series:
 * addresses Marcels comments, using a switch instead of an if (2,3,4)
 * fixes scanning problems for older firmware (21)
 * depends on cfg80211 rather than selecting it (in line with "cfg80211:
   fix Kconfig for users of cfg80211") (14).
 * updates change_vif argument from ifindex to net_device (in line with
   "cfg80211: pass netdev to change_virtual_intf") (20)

Patches 1-5 modify cfg80211, mostly so it can advertise (the more
restrictive) orinoco capabilities correctly.

Patches 6-13 refactor the orinoco internal interfaces and initialisation
to make the switch to cfg80211 easier. The main thrust is to avoid using
net_device in the device drivers allowing us to register the net_device
later.

Patch 14 starts the cfg80211 conversion, before patches 15-19 cleanup
the fallout from the conversion.

Patches 20 though 23 convert a few of the WE handlers to cfg80211
handlers.

This series is intended for the wireless-testing tree.

---
David Kilroy (23):
  cfg80211: add wrapper function to get wiphy from priv pointer
  cfg80211: Advertise ciphers via WE according to driver capability
  cfg80211: allow drivers that can't scan for specific ssids
  cfg80211: set WE encoding size based on available ciphers
  cfg80211: infer WPA and WPA2 support from TKIP and CCMP
  orinoco: Move firmware capability determination into hw.c
  orinoco: Move card reading code into hw.c
  orinoco: Move FID allocation to hw.c
  orinoco: use dev_err in early initialisation routines
  orinoco: firmware helpers should use dev_err and friends
  orinoco: Replace net_device with orinoco_private in driver interfaces
  orinoco: initialise independently of netdev
  orinoco: Change set_tkip to use orinoco_private instead of hermes_t
  orinoco: initiate cfg80211 conversion
  orinoco: make firmware download less verbose
  orinoco: move netdev interface creation to main driver
  airport: store irq in card private structure
  orinoco: Handle suspend/restore in core driver
  orinoco: provide generic commit function
  orinoco: convert mode setting to cfg80211
  orinoco: convert scanning to cfg80211
  orinoco: convert giwrange to cfg80211
  orinoco: remove WE nickname support

 drivers/net/wireless/orinoco/Kconfig          |    1 +
 drivers/net/wireless/orinoco/Makefile         |    2 +-
 drivers/net/wireless/orinoco/airport.c        |   98 +--
 drivers/net/wireless/orinoco/cfg.c            |  162 ++++
 drivers/net/wireless/orinoco/cfg.h            |   15 +
 drivers/net/wireless/orinoco/fw.c             |   41 +-
 drivers/net/wireless/orinoco/hermes.h         |    2 +-
 drivers/net/wireless/orinoco/hermes_dld.c     |   50 +-
 drivers/net/wireless/orinoco/hw.c             |  668 +++++++++++++++-
 drivers/net/wireless/orinoco/hw.h             |   11 +-
 drivers/net/wireless/orinoco/main.c           | 1133 +++++++++----------------
 drivers/net/wireless/orinoco/main.h           |    3 +-
 drivers/net/wireless/orinoco/orinoco.h        |   49 +-
 drivers/net/wireless/orinoco/orinoco_cs.c     |   96 +--
 drivers/net/wireless/orinoco/orinoco_nortel.c |   38 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |   38 +-
 drivers/net/wireless/orinoco/orinoco_pci.h    |   57 +--
 drivers/net/wireless/orinoco/orinoco_plx.c    |   38 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |   38 +-
 drivers/net/wireless/orinoco/scan.c           |  285 +++----
 drivers/net/wireless/orinoco/scan.h           |   21 +-
 drivers/net/wireless/orinoco/spectrum_cs.c    |   96 +--
 drivers/net/wireless/orinoco/wext.c           |  878 ++------------------
 include/net/cfg80211.h                        |   11 +
 net/wireless/core.c                           |    3 -
 net/wireless/wext-compat.c                    |   31 +-
 26 files changed, 1748 insertions(+), 2117 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/cfg.c
 create mode 100644 drivers/net/wireless/orinoco/cfg.h

