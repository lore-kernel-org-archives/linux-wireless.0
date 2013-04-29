Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46417 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab3D2JGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:06:18 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux@rempel-privat.de,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 0/2] Add STBC rx flag for radiotap using ath9k driver
Date: Mon, 29 Apr 2013 11:04:17 +0200
Message-Id: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130429_110624_031149_52467A75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add STBC rx flag for radiotap. They are based on
proposed field structure from radiotap.org. Only one STBC stream
is supported.

TODO: Implement mechanism for passing the number of STBC streams
being used. We could use mac80211_rx_flags to point number of
streams which would require 3 precious bits or use a separate structure.

Wojciech Dubowik (2):
  mac80211: Add STBC RX flag to radiotap
  ath9k: Add STBC flag to rx status

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    1 +
 drivers/net/wireless/ath/ath9k/recv.c       |    2 ++
 include/net/ieee80211_radiotap.h            |    6 ++++++
 include/net/mac80211.h                      |    2 ++
 net/mac80211/main.c                         |    3 ++-
 net/mac80211/rx.c                           |    2 ++
 8 files changed, 18 insertions(+), 1 deletion(-)

-- 
1.7.10.4

