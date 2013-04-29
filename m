Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49824 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab3D2Jdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:33:53 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M9M3c-1UK3AM2Fvq-00ChPH for
 <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 11:33:52 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/4 RFC] STBC work for ath9k*
Date: Mon, 29 Apr 2013 11:33:40 +0200
Message-Id: <1367228024-17936-1-git-send-email-linux@rempel-privat.de> (sfid-20130429_113357_236533_FA28AE38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This serie of patches is about support for STBC on ath9k chips.
It will add STBC Tx to ath9k-htc and allow tracing Rx packets.
Radiotap part of this patch set based on Wojciech Dubowik work.
Currently this values seems to be not compatible with STBC draft for radiotap:
http://www.radiotap.org/suggested-fields/MCS%20extension%20for%20STBC%20and%20Ness

but compatible with wireshark (thx Wojciech):
http://code.wireshark.org/git/?p=wireshark;a=blob;f=epan/dissectors/packet-ieee80211-radiotap-defs.h;h=e0b9a6a0098b3b8ada30cacb75e6ff5009284d3a;hb=HEAD#l280

Oleksij Rempel (4):
  ath9k_htc: add STBC TX support
  mac80211: add STBC RX flag for radiotap
  ath9k: remove useless flag conversation.
  ath9k: check for Rx-STBC flag and pass it to ieee80211

 drivers/net/wireless/ath/ath9k/ar9003_mac.c   |  5 +++--
 drivers/net/wireless/ath/ath9k/htc.h          |  2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  4 ++++
 drivers/net/wireless/ath/ath9k/mac.c          | 14 ++++++++++----
 drivers/net/wireless/ath/ath9k/mac.h          |  4 +++-
 drivers/net/wireless/ath/ath9k/recv.c         |  5 +----
 include/net/ieee80211_radiotap.h              |  2 ++
 include/net/mac80211.h                        |  2 ++
 net/mac80211/main.c                           |  3 ++-
 net/mac80211/rx.c                             |  2 ++
 net/mac80211/status.c                         |  3 ++-
 12 files changed, 36 insertions(+), 13 deletions(-)

-- 
1.8.1.2

