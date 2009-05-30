Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573AbZE3RhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:00 -0400
Received: by ewy24 with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:01 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 00/23] orinoco: initiate conversion to cfg80211
Date: Sat, 30 May 2009 18:36:34 +0100
Message-Id: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've completely refactorred since the last RFC, and switched to the
cfg80211 handlers for scanning, mode changing and giwrange.

Patches 1-5 modify cfg80211, mostly so it can advertise (the more
restrictive) orinoco capabilities correctly.

Patches 6-13 refactor the orinoco internal interfaces and initialisation
to make the switch to cfg80211 easier. The main thrust is to avoid using
net_device in the device drivers allowing us to register the net_device
later.

Patch 14 starts the cfg80211 conversion, before patches 15-19 cleanup
the fallout from the conversion.

Patches 20 though 23 convert a few of the WE handler to cfg80211
handlers.

The refactorring affects all the card and firmware types, but I'm only
able to test orinoco_cs with Agere firmware.
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
 drivers/net/wireless/orinoco/cfg.c            |  169 ++++
 drivers/net/wireless/orinoco/cfg.h            |   15 +
 drivers/net/wireless/orinoco/fw.c             |   41 +-
 drivers/net/wireless/orinoco/hermes.h         |    2 +-
 drivers/net/wireless/orinoco/hermes_dld.c     |   50 +-
 drivers/net/wireless/orinoco/hw.c             |  668 +++++++++++++++-
 drivers/net/wireless/orinoco/hw.h             |   11 +-
 drivers/net/wireless/orinoco/main.c           | 1131 +++++++++----------------
 drivers/net/wireless/orinoco/main.h           |    3 +-
 drivers/net/wireless/orinoco/orinoco.h        |   49 +-
 drivers/net/wireless/orinoco/orinoco_cs.c     |   96 +--
 drivers/net/wireless/orinoco/orinoco_nortel.c |   38 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |   38 +-
 drivers/net/wireless/orinoco/orinoco_pci.h    |   57 +--
 drivers/net/wireless/orinoco/orinoco_plx.c    |   38 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |   38 +-
 drivers/net/wireless/orinoco/scan.c           |  265 +++----
 drivers/net/wireless/orinoco/scan.h           |   21 +-
 drivers/net/wireless/orinoco/spectrum_cs.c    |   96 +--
 drivers/net/wireless/orinoco/wext.c           |  878 ++------------------
 include/net/cfg80211.h                        |   11 +
 net/wireless/core.c                           |    3 -
 net/wireless/wext-compat.c                    |   24 +-
 26 files changed, 1725 insertions(+), 2118 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/cfg.c
 create mode 100644 drivers/net/wireless/orinoco/cfg.h

