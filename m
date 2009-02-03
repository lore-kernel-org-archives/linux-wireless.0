Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:45712 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZBCUkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:40:52 -0500
Received: by ewy14 with SMTP id 14so2845859ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:40:50 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 00/17] orinoco: reorganisation
Date: Tue,  3 Feb 2009 20:40:22 +0000
Message-Id: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214056_359145_074A1ADE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series reorganises the orinoco driver. The focus is on
splitting up the monolithic orinoco.c to make future changes easier.

The series has been through two RFCs on the orinoco-devel list.
As a result, checkpatch fixes prefix the core changes, and the last
two patches stop building hermes and hermes_dld as modules.

Because of patch conflicts, I've included Andrey's checkpatch cleanup
patch. However there is still a conflict with Harvey Harrison's
"wireless: replace use of __constant_{endian}" patch.


Regards,

Dave.
---

Andrey Borzenkov (1):
  orinoco: checkpatch cleanup

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

 drivers/net/wireless/orinoco/Makefile         |    3 +-
 drivers/net/wireless/orinoco/airport.c        |   37 +-
 drivers/net/wireless/orinoco/fw.c             |  340 ++
 drivers/net/wireless/orinoco/fw.h             |   16 +
 drivers/net/wireless/orinoco/hermes.c         |  120 +-
 drivers/net/wireless/orinoco/hermes.h         |   35 +-
 drivers/net/wireless/orinoco/hermes_dld.c     |   33 +-
 drivers/net/wireless/orinoco/hw.c             |  586 +++
 drivers/net/wireless/orinoco/hw.h             |   47 +
 drivers/net/wireless/orinoco/main.c           | 2654 +++++++++++
 drivers/net/wireless/orinoco/main.h           |   63 +
 drivers/net/wireless/orinoco/mic.c            |   79 +
 drivers/net/wireless/orinoco/mic.h            |   22 +
 drivers/net/wireless/orinoco/orinoco.c        | 6153 -------------------------
 drivers/net/wireless/orinoco/orinoco.h        |   17 +-
 drivers/net/wireless/orinoco/orinoco_cs.c     |   34 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c |    7 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    5 +-
 drivers/net/wireless/orinoco/orinoco_pci.h    |   12 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    3 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    4 +-
 drivers/net/wireless/orinoco/scan.c           |  233 +
 drivers/net/wireless/orinoco/scan.h           |   29 +
 drivers/net/wireless/orinoco/spectrum_cs.c    |   19 +-
 drivers/net/wireless/orinoco/wext.c           | 2325 ++++++++++
 drivers/net/wireless/orinoco/wext.h           |   13 +
 26 files changed, 6562 insertions(+), 6327 deletions(-)
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

