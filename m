Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56275 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0EANFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 09:05:53 -0400
Received: by wwb34 with SMTP id 34so763709wwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 06:05:52 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/6] orinoco: Add support for Agere based USB cards
Date: Sat,  1 May 2010 14:05:37 +0100
Message-Id: <1272719143-26171-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds the orinoco_usb driver, originally written by
Manuel Estrada Sainz.

I believe the main stumbling block the last time this driver was
submitted for inclusion was the way it handled the orinoco driver
locking. I've reworked this into something reasonably sane (patch 3).

The resulting driver has been basically tested with a Compaq WL215
(thanks to Mark Davis for supplying one). Managed mode with WEP works
on this card while a WPA-enabled PCMCIA orinoco card is running.

I'm not familiar with the USB subsystem, so there may be issues that
need to be resolved in that area. Also the original driver used
in_atomic in one location. I left this as-is in the main driver
commit (patch 4), and the subsequent patch (5) is my attempt to fix
this up. It works, but there may be a better way to do this.

Changes since RFC:
 * added firmware download capability to orinoco_usb
 * changed reference to IW_MODE_MONITOR to NL80211_IFTYPE_MONITOR
 * propogated the op->locks to a number of other places that take
   priv->lock
 * added static annotations to a number of functions
 * added sparse annotations to lock wrappers

Regards,

Dave.
---
David Kilroy (6):
  orinoco: add hermes_ops
  orinoco: allow driver to specify netdev_ops
  orinoco: encapsulate driver locking
  orinoco: add orinoco_usb driver
  orinoco_usb: avoid in_atomic
  orinoco_usb: implement fw download

 drivers/net/wireless/orinoco/Kconfig          |    7 +
 drivers/net/wireless/orinoco/Makefile         |    1 +
 drivers/net/wireless/orinoco/airport.c        |    8 +-
 drivers/net/wireless/orinoco/cfg.c            |    2 +-
 drivers/net/wireless/orinoco/fw.c             |   10 +-
 drivers/net/wireless/orinoco/hermes.c         |  286 ++++-
 drivers/net/wireless/orinoco/hermes.h         |   62 +-
 drivers/net/wireless/orinoco/hermes_dld.c     |  243 +----
 drivers/net/wireless/orinoco/hw.c             |   63 +-
 drivers/net/wireless/orinoco/main.c           |  137 ++-
 drivers/net/wireless/orinoco/orinoco.h        |   30 +-
 drivers/net/wireless/orinoco/orinoco_cs.c     |    6 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c    | 1800 +++++++++++++++++++++++++
 drivers/net/wireless/orinoco/spectrum_cs.c    |    7 +-
 drivers/net/wireless/orinoco/wext.c           |    6 +-
 19 files changed, 2278 insertions(+), 398 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/orinoco_usb.c

