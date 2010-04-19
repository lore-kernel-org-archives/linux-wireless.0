Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34085 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0DSHff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:35:35 -0400
Received: by wwb24 with SMTP id 24so2319543wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:35:33 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 0/5] orinoco: Add support for Agere based USB cards
Date: Mon, 19 Apr 2010 08:35:17 +0100
Message-Id: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
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


Regards,

Dave.

---
David Kilroy (5):
  orinoco: add hermes_ops
  orinoco: allow driver to specify netdev_ops
  orinoco: encapsulate driver locking
  orinoco: add orinoco_usb driver
  orinoco_usb: avoid in_atomic

 drivers/net/wireless/orinoco/Kconfig          |    7 +
 drivers/net/wireless/orinoco/Makefile         |    1 +
 drivers/net/wireless/orinoco/airport.c        |    4 +-
 drivers/net/wireless/orinoco/cfg.c            |    2 +-
 drivers/net/wireless/orinoco/fw.c             |    2 +-
 drivers/net/wireless/orinoco/hermes.c         |   76 +-
 drivers/net/wireless/orinoco/hermes.h         |   55 +-
 drivers/net/wireless/orinoco/hermes_dld.c     |   34 +-
 drivers/net/wireless/orinoco/hw.c             |   63 +-
 drivers/net/wireless/orinoco/main.c           |  129 ++-
 drivers/net/wireless/orinoco/orinoco.h        |   30 +-
 drivers/net/wireless/orinoco/orinoco_cs.c     |    2 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c    | 1678 +++++++++++++++++++++++++
 drivers/net/wireless/orinoco/spectrum_cs.c    |    2 +-
 drivers/net/wireless/orinoco/wext.c           |    6 +-
 19 files changed, 1932 insertions(+), 167 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/orinoco_usb.c

