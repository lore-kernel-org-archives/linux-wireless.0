Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57730 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3ESHjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 03:39:10 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MKwSE-1UdyCz0BzE-0006F9 for
 <linux-wireless@vger.kernel.org>; Sun, 19 May 2013 09:39:09 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/3] Work on STBC Rx monitoring
Date: Sun, 19 May 2013 09:38:53 +0200
Message-Id: <1368949136-6079-1-git-send-email-linux@rempel-privat.de> (sfid-20130519_093924_522580_99533937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set will pass RxSTBC flags from ath9k to ieee80211
and to radiotap.
This field is now a part of radiotap specification:
http://www.radiotap.org/defined-fields/MCS

Oleksij Rempel (3):
  mac80211: add STBC flag for radiotap
  ath9k: remove useless flag conversation.
  ath9k: check for Rx-STBC flag and pass it to ieee80211

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  5 +++--
 drivers/net/wireless/ath/ath9k/mac.c        | 16 ++++++++++++----
 drivers/net/wireless/ath/ath9k/mac.h        |  4 +++-
 drivers/net/wireless/ath/ath9k/recv.c       |  5 +----
 include/net/ieee80211_radiotap.h            |  7 +++++++
 include/net/mac80211.h                      |  4 ++++
 net/mac80211/main.c                         |  3 ++-
 net/mac80211/rx.c                           |  4 ++++
 net/mac80211/status.c                       |  3 ++-
 9 files changed, 38 insertions(+), 13 deletions(-)

-- 
1.8.1.2

