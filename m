Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:44548 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbbJEQPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 12:15:21 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 0/5] wireless-regdb: Update TW and US rules to latest regulations
Date: Tue,  6 Oct 2015 00:14:53 +0800
Message-Id: <1444061698-16384-1-git-send-email-wens@csie.org> (sfid-20151005_181529_613549_61B32649)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

This is v4 of my TW/US 5GHz updates series. Hopefully this one will go
in without further work.

Changes since v3:

  - Moved power limit increase of 5250 ~ 5350 MHz band from patch 4 to
    patch 5.

Changes since v2:

  - Moved the US U-NII-1 (5150 ~ 5250 MHz) patch in front of the TW patch

  - Drop U-NII-1 power limit from 24 dBm to 23 dBm, to be on the safe
    side of 250mW


Patch 1 updates the 5470 ~ 5725 MHz rules for Taiwan, specifically
the opening up of 5600 ~ 5650 MHz spectrum previously allocated to
weather radars. The transmission power limit is also corrected to
match the regulations.

Patch 2 changes the boundary frequencies for each rule for Taiwan to
match the frequency allocation table. The "regulation" database shouldn't
care about artificial channel boundaries.

Patch 3 updates the transmission power limits for 5150 ~ 5250 MHz for
the US.

Patch 4 adds the previously unusable 5150 ~ 5250 MHz band for Taiwan.

Patch 5 updates the transmission power limits for Taiwan, per the NCC's
official reply. This patch may be slightly controversial, as there is
no official English document. Either someone will have to independently
verify this, or translate the Chinese document.


Regards
ChenYu


Chen-Yu Tsai (5):
  wireless-regdb: Update U-NII-2c (5470 ~ 5725 MHz) rules for Taiwan
    (TW)
  wireless-regdb: Update regulatory rule boundary frequencies for Taiwan
    (TW)
  wireless-regdb: Update 5GHz rules for US
  wireless-regdb: Add U-NII-1 (5150 ~ 5250 MHz) band for Taiwan (TW)
  wireless-regdb: Update 5 GHz rules for Taiwan (TW) to follow US

 db.txt | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

-- 
2.5.3

