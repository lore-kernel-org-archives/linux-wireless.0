Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14754 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZHSAEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 20:04:21 -0400
Received: by ey-out-2122.google.com with SMTP id 22so862866eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 17:04:21 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 0/5] orinoco: use cfg80211 for key manipulation
Date: Wed, 19 Aug 2009 01:04:08 +0100
Message-Id: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series basically works (at least after the last patch is applied)
with wpa_supplicant in wext mode.

I had tested with wpa_supplicant in nl80211 mode, but hadn't realised
it wasn't using connect - I'll need to pick up Zhu Yis' patch and redo
some testing.

Anyway, the nl80211 interface has a small hole which patch 5 partially
papers over. I'm not that happy with the way it hijacks the AUTH/ASSOC
state machine, but it works.

Other outstanding issues:
 - It looks like I haven't quite got the connect_roamed callback right:
   I've got a WARNING I need to investigate in my logs
 - On disconnecting and reconnecting the card I have to restart
   wpa_supplicant for things to work. I'm guessing I have to look at
   driver shutdown, and ensure we send a disconnected event.

Dave.

---
David Kilroy (5):
  orinoco: add cfg80211 connect and disconnect
  orinoco: add cfg80211 join_ibss and leave_ibss
  orinoco: implement cfg80211 key manipulation functions
  orinoco: do WE via cfg80211
  cfg80211: scan before connect if we don't have the bss

 drivers/net/wireless/orinoco/cfg.c     |  497 ++++++++++++++++++++++
 drivers/net/wireless/orinoco/main.c    |  172 +++++----
 drivers/net/wireless/orinoco/orinoco.h |    1 +
 drivers/net/wireless/orinoco/wext.c    |  726 +-------------------------------
 net/wireless/sme.c                     |  150 +++++--
 5 files changed, 717 insertions(+), 829 deletions(-)

