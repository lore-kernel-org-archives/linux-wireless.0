Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38530 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0FNLBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 07:01:47 -0400
Received: from MSI-MTA.marvell.com (msi-mta.marvell.com [10.68.76.91]) by dakia2.marvell.com with ESMTP id G3W5SrBShK7PWOtw for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 04:01:46 -0700 (PDT)
Subject: [PATCH 0/3] Libertas : cfg80211, 11d support (rebased)
From: Kiran Divekar <dkiran@marvell.com>
Reply-To: dkiran@marvell.com
To: <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 22:01:16 +0530
Message-ID: <1276533076.18884.8.camel@pe-lt028>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I resolved the issue with my MTA, please see if it applies.

The top commit log in libertas is 77c2061d10a408d0220c2b0e7faefe52d9c41008. 

Top commit in wireless testing is a5fdbcad0a3f461d43f7b801f8fc176cd2840704.

Add cfg80211 support to Libertas based on initial work from Holger Shurig.
Add 11d support to Libertas.

Kiran Divekar (3):
  Libertas: cfg80211 support
  Libertas: fix WARN_ON issues in cfg80211 support
  Libertas: Added 11d support using cfg80211

 drivers/net/wireless/libertas/Makefile  |    3 -
 drivers/net/wireless/libertas/assoc.c   | 2264 -----------------------------
 drivers/net/wireless/libertas/assoc.h   |  155 --
 drivers/net/wireless/libertas/cfg.c     | 2038 ++++++++++++++++++++++++++-
 drivers/net/wireless/libertas/cfg.h     |   21 +-
 drivers/net/wireless/libertas/cmd.c     |   87 +-
 drivers/net/wireless/libertas/cmdresp.c |   83 +-
 drivers/net/wireless/libertas/debugfs.c |   54 +-
 drivers/net/wireless/libertas/decl.h    |    8 +
 drivers/net/wireless/libertas/dev.h     |   62 +-
 drivers/net/wireless/libertas/ethtool.c |    5 -
 drivers/net/wireless/libertas/host.h    |   28 +-
 drivers/net/wireless/libertas/main.c    |  226 +---
 drivers/net/wireless/libertas/rx.c      |  121 +--
 drivers/net/wireless/libertas/scan.c    | 1354 ------------------
 drivers/net/wireless/libertas/scan.h    |   63 -
 drivers/net/wireless/libertas/tx.c      |   12 +-
 drivers/net/wireless/libertas/wext.c    | 2353 -------------------------------
 drivers/net/wireless/libertas/wext.h    |   17 -
 19 files changed, 2237 insertions(+), 6717 deletions(-)
 delete mode 100644 drivers/net/wireless/libertas/assoc.c
 delete mode 100644 drivers/net/wireless/libertas/assoc.h
 delete mode 100644 drivers/net/wireless/libertas/scan.c
 delete mode 100644 drivers/net/wireless/libertas/scan.h
 delete mode 100644 drivers/net/wireless/libertas/wext.c
 delete mode 100644 drivers/net/wireless/libertas/wext.h



