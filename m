Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:53607 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab0ERMdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 08:33:03 -0400
From: Kiran Divekar <dkiran@marvell.com>
To: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Tue, 18 May 2010 05:32:58 -0700
Subject: [PATCH 0/3] Libertas : cfg80211, 11d support
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04D627399A@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/net/wireless/libertas/cmdresp.c |   82 +-
 drivers/net/wireless/libertas/debugfs.c |   54 +-
 drivers/net/wireless/libertas/decl.h    |    8 +
 drivers/net/wireless/libertas/dev.h     |   62 +-
 drivers/net/wireless/libertas/ethtool.c |    5 -
 drivers/net/wireless/libertas/host.h    |   28 +-
 drivers/net/wireless/libertas/main.c    |  226 +---
 drivers/net/wireless/libertas/rx.c      |  122 +--
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
