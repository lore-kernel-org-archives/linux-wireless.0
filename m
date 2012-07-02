Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18369 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2GBGct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 02:32:49 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
Date: Mon, 2 Jul 2012 09:32:31 +0300
Message-ID: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120702_083253_414787_DCD337B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add minimal infrastructure for the 60gHz (802.11ad)
band WiFi drivers.

This change enables offload drivers for the 60GHz devices that implement
the 802.11 MAC functionality in the device itself.

Driver based on this infrastructure see at:
http://wireless.kernel.org/en/users/Drivers/wil6210

Identation should be fine now, thanks Joe Perches for hint.

I put in #if 0 one entry in MCS-to-bitrate translation table,
since it does not fit into u16. It should work fine until
real devices with 6.5Gbps bitrate appears.

Vladimir Kondratiev (5):
  wireless: add 802.11ad (60gHz band)
  wireless: rate check logic for 60g
  wireless: regulatory for 60g
  wireless: 60g protocol constants
  wireless: bitrate calculation for 60g

 include/linux/ieee80211.h |   89 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/nl80211.h   |    2 +
 include/net/cfg80211.h    |    4 ++
 net/mac80211/tx.c         |    2 +
 net/wireless/core.c       |   10 ++++-
 net/wireless/reg.c        |    5 ++-
 net/wireless/util.c       |   90 +++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 190 insertions(+), 12 deletions(-)

-- 
1.7.9.5

