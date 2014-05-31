Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65089 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaEaStz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:49:55 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so2627884wiw.16
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:49:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/9] b43: clean channel handling
Date: Sat, 31 May 2014 20:49:32 +0200
Message-Id: <1401562181-14608-1-git-send-email-zajec5@gmail.com> (sfid-20140531_205008_274346_0DAFF812)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset cleans channel handling in the driver which became a bit
messy recently. We get rid of too many variables in PHY struct switching
to a simple struct cfg80211_chan_def (unsigned int channel is still
there because a lot of code depends on it).

This also slightly changes PHY ops to make PHY re-init possible with
the current channel (this will be needed for band switching).

This has been basically tested for regressions on the following cards:
14e4:4312 BCM4311 G-PHY rev 8
14e4:4315 BCM4312 LP-PHY rev 1
14e4:4328 BCM4321 N-PHY rev 2
14e4:432b BCM4322 N-PHY rev 4
14e4:4353 BCM43224 N-PHY rev 6
(note 14e4:4312 was never working correctly for me).

John: it's the last "big thing" I wanted for 3.16. It's a bit late, so
to minimalize a risk I gave it some testing on many devices. If you
manage to get it for 3.16, that will be cool for me. Still, it's up to
you, not a big pressure.

Rafał Miłecki (9):
  b43: drop B43_DEFAULT_CHANNEL
  b43: b43_op_config: drop check for core change
  b43: b43_op_config: use IEEE80211_CONF_CHANGE_CHANNEL
  b43: PHY: don't force default channel during init
  b43: b43_op_config: set channel info before switching band
  b43: store current channel using struct cfg80211_chan_def
  b43: PHY: drop own channel_freq (get it from chandef when needed)
  b43: PHY: drop is_40mhz (get width info from chandef)
  b43: PHY: drop channel_type (we can get this info from chandef)

 drivers/net/wireless/b43/main.c        | 46 ++++++------------
 drivers/net/wireless/b43/phy_common.c  | 21 ++++----
 drivers/net/wireless/b43/phy_common.h  | 12 +----
 drivers/net/wireless/b43/phy_ht.c      |  2 +-
 drivers/net/wireless/b43/phy_n.c       | 88 ++++++++++++++++++----------------
 drivers/net/wireless/b43/tables_nphy.c |  2 +-
 6 files changed, 75 insertions(+), 96 deletions(-)

-- 
1.8.4.5

