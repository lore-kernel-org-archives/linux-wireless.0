Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45398 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZKERqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 12:46:20 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: [PATCH] wireless-regdb: update US rules for 5600 MHz - 5650 MHz
Date: Thu,  5 Nov 2009 12:46:25 -0500
Message-Id: <1257443185-3614-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCC is trying to assist airports that use Terminal Doppler
Weather Radar (TDWR) systems in avoiding interference with
some outdoor wireless systems operating in the 5.4 GHz
(5470 MHz - 5725 MHz) band. One of the things they have decided
on is to disallow operation on the 5600 MHz - 5650 MHz frequency
range inclusive. What this means in practice is 5 GHz 802.11
devices programmed to operate in the US will have these
channels now disabled:

 * 5600 MHz [120] (disabled)
 * 5620 MHz [124] (disabled)
 * 5640 MHz [128] (disabled)

Channel on 5660 MHz (132) will be left enabled as the channel
bandwidth is 20 MHz for legacy 802.11 networks but note that
HT40- will be disallowed for that channel. The HT40+ and HT40-
allowed channel map obviously changes. This is computed
dynamically on cfg80211 based on your allowed channel list.
For a US based device this is what you will get now
(excerpt from on /sys/kernel/debug/ieee80211/phy0):

 .. etc ..
5540 HT40 -+
5560 HT40 -+
5580 HT40 -
5600 Disabled
5620 Disabled
5640 Disabled
5660 HT40  +
5680 HT40 -+
 .. etc ..

The details on which this patch is based on is documented on
the FCC Knowledge based Publication Number: 443999 [1]

[1] https://fjallfoss.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=41732

Cc: Michael Green <Michael.Green@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: David Quan <David.Quan@atheros.com>
Cc: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index 84be443..c71b35b 100644
--- a/db.txt
+++ b/db.txt
@@ -562,7 +562,8 @@ country US:
 	(2402 - 2472 @ 40), (3, 27)
 	(5170 - 5250 @ 40), (3, 17)
 	(5250 - 5330 @ 40), (3, 20), DFS
-	(5490 - 5710 @ 40), (3, 20), DFS
+	(5490 - 5600 @ 40), (3, 20), DFS
+	(5650 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
 
 country UY:
-- 
1.6.5.2.143.g8cc62

