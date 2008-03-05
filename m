Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16846 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756292AbYCEJfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:35:25 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 0/4] ath5k descriptor cleanup + ibss beacon fix
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 05 Mar 2008 18:34:51 +0900
Message-ID: <20080305091347.5670.40944.stgit@one> (sfid-20080305_093530_551698_A8275AD0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

here are some patches, some i have had lying around for a while.

especially the first two touch the very core of the driver, so please review
them. i have been careful and i don't think it creates a problem, but i have
tested it only with ar5212 because i don't have a 5210 to test with
unfortunately.

the other ones are just about rx timestamps and a workaround for some hardware
bugs in ibss mode.

Bruno Randolf (4):
      ath5k: work around wrong beacon rx timestamp in IBSS mode
      ath5k: add notes about rx timestamp
      ath5k: move rx and tx status structures out of hardware descriptor
      ath5k: struct ath5k_desc cleanups


 drivers/net/wireless/ath5k/ath5k.h |   35 ++--
 drivers/net/wireless/ath5k/base.c  |  144 ++++++++++------
 drivers/net/wireless/ath5k/debug.c |   31 ++-
 drivers/net/wireless/ath5k/debug.h |    6 -
 drivers/net/wireless/ath5k/hw.c    |  331 ++++++++++++++++++------------------
 drivers/net/wireless/ath5k/hw.h    |  150 ++++++++++------
 6 files changed, 379 insertions(+), 318 deletions(-)

-- 
Signature
