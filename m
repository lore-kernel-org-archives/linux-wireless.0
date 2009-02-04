Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZBDXGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:04 -0500
Received: by ewy14 with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:02 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 00/16] orinoco: reorganisation
Date: Wed,  4 Feb 2009 23:05:42 +0000
Message-Id: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000613_359577_52C28EF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series reorganises the orinoco driver. The focus is on
splitting up the monolithic orinoco.c to make future changes easier.

The series has been through two RFCs on the orinoco-devel list.
As a result, checkpatch fixes prefix the core changes, and the last
two patches stop building hermes and hermes_dld as modules.

This series has been rebased on top of master-2009-02-03 to eliminate
conflicts.

Regards,

Dave.
---

David Kilroy (16):
  orinoco: address leading and trailing whitespace
  orinoco: spaces in parenthesised expressions
  orinoco: remove unnecessary braces
  orinoco: keep line length below 80 characters
  orinoco: Fix interesting checkpatch errors
  orinoco: Rename orinoco.c
  orinoco: use orinoco_private instead of net_device in scan helper
  orinoco: Move scan helpers to a separate file
  orinoco: Move MIC helpers into new file
  orinoco: Move firmware handling into a separate file
  orinoco: Use accessor functions for bitrate tables
  orinoco: Add hardware function to set multicast mode
  orinoco: Move hardware functions into separate file
  orinoco: Move WEXT handlers into a separate file
  orinoco: hermes_dld does not need to be a module
  orinoco: hermes doesn't need to be a separate module

 drivers/net/wireless/orinoco/Makefile      |    3 +-
 drivers/net/wireless/orinoco/airport.c     |    2 +-
 drivers/net/wireless/orinoco/fw.c          |  340 ++
 drivers/net/wireless/orinoco/fw.h          |   16 +
 drivers/net/wireless/orinoco/hermes.c      |   18 -
 drivers/net/wireless/orinoco/hermes_dld.c  |   33 +-
 drivers/net/wireless/orinoco/hw.c          |  586 +++
 drivers/net/wireless/orinoco/hw.h          |   47 +
 drivers/net/wireless/orinoco/main.c        | 2654 ++++++++++++
 drivers/net/wireless/orinoco/main.h        |   63 +
 drivers/net/wireless/orinoco/mic.c         |   79 +
 drivers/net/wireless/orinoco/mic.h         |   22 +
 drivers/net/wireless/orinoco/orinoco.c     | 6153 ----------------------------
 drivers/net/wireless/orinoco/orinoco_cs.c  |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.h |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c |    2 +-
 drivers/net/wireless/orinoco/scan.c        |  233 ++
 drivers/net/wireless/orinoco/scan.h        |   29 +
 drivers/net/wireless/orinoco/spectrum_cs.c |    4 +-
 drivers/net/wireless/orinoco/wext.c        | 2325 +++++++++++
 drivers/net/wireless/orinoco/wext.h        |   13 +
 21 files changed, 6417 insertions(+), 6209 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/fw.c
 create mode 100644 drivers/net/wireless/orinoco/fw.h
 create mode 100644 drivers/net/wireless/orinoco/hw.c
 create mode 100644 drivers/net/wireless/orinoco/hw.h
 create mode 100644 drivers/net/wireless/orinoco/main.c
 create mode 100644 drivers/net/wireless/orinoco/main.h
 create mode 100644 drivers/net/wireless/orinoco/mic.c
 create mode 100644 drivers/net/wireless/orinoco/mic.h
 delete mode 100644 drivers/net/wireless/orinoco/orinoco.c
 create mode 100644 drivers/net/wireless/orinoco/scan.c
 create mode 100644 drivers/net/wireless/orinoco/scan.h
 create mode 100644 drivers/net/wireless/orinoco/wext.c
 create mode 100644 drivers/net/wireless/orinoco/wext.h

