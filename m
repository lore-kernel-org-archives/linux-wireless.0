Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZHEUYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:24:10 -0400
Received: by ewy10 with SMTP id 10so285565ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:24:10 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/6] orinoco: preliminary refactorring before cfg80211 key handling
Date: Wed,  5 Aug 2009 21:23:26 +0100
Message-Id: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series does a little clean up, moves a few common routines which we
will need in the cfg80211 handlers to hw.c, and puts all our keys in one
basket.

These have been running for a while on my machine, and I haven't noticed
any breakage.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>

---
David Kilroy (6):
  orinoco: prefer_port3 can be a single bit
  orinoco: use local types for auth alg and sequence length
  orinoco: pass orinoco_set_tkip_key the sequence lengths
  orinoco: move disassociation to hw.c
  orinoco: add function to retrieve current bssid
  orinoco: consolidate storage of WEP and TKIP keys

 drivers/net/wireless/orinoco/hw.c      |  120 +++++++++++++++++-----
 drivers/net/wireless/orinoco/hw.h      |    7 +-
 drivers/net/wireless/orinoco/main.c    |   35 ++++--
 drivers/net/wireless/orinoco/orinoco.h |   16 ++-
 drivers/net/wireless/orinoco/wext.c    |  173 +++++++++++++++++++-------------
 5 files changed, 236 insertions(+), 115 deletions(-)

