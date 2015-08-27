Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36323 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbbH0K5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 06:57:32 -0400
Received: by iodv127 with SMTP id v127so52236842iod.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 03:57:31 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/3] mesh support for ath10k
Date: Thu, 27 Aug 2015 06:57:01 -0400
Message-Id: <1440673024-13696-1-git-send-email-me@bobcopeland.com> (sfid-20150827_125738_501652_D2DC6BAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This was previously sent to ath10k ML, now adding linux-wireless for
wider review.  Patch 3 gained a minor change since then to check for
raw mode feature flag from the firmware.

This patchset implements mesh support on ath10k.  There aren't many
changes required to the driver, now that most of the required raw-mode
support is upstream.

I've tested VHT multihop on openwrt with the appropriate patches
backported.

Regarding performance: I currently get about 75 Mbps with udp iperf
due to small aggregates, which leaves a lot to be desired.  Some users,
however, have reported 300+ Mbps [1], so this is potentially solvable.

[1] http://thread.gmane.org/gmane.linux.drivers.mesh.open80211s/3963

Bob Copeland (3):
  ath10k: enable monitor when OTHER_BSS requested
  ath10k: check for encryption before adding MIC_LEN
  ath10k: implement mesh support

 drivers/net/wireless/ath/ath10k/core.c   |  6 ++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ++-
 drivers/net/wireless/ath/ath10k/mac.c    | 34 +++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 6 deletions(-)

-- 
2.1.4

