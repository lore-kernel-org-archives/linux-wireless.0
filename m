Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2GAGqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 02:46:17 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 60g v1 0/5] Infrastructure for 60g (802.11ad)
Date: Sun, 1 Jul 2012 09:45:49 +0300
Message-ID: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120701_084655_591962_ECD79841)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add minimal infrastructure for the 60gHz (802.11ad)
band WiFi drivers.

This change enables offload drivers for the 60GHz devices that implement
the 802.11 MAC functionality in the device itself.

Addressed comments form Johannes Berg. Since no significant issues raised,
change it from RFC to PATCH.

Driver based on this infrastructure see at:
http://wireless.kernel.org/en/users/Drivers/wil6210

Vladimir Kondratiev (5):
  wireless: add 802.11ad (60gHz band)
  wireless: rate check logic for 60g
  wireless: regulatory for 60g
  wireless: 60g protocol constants
  wireless: bitrate calculation for 60g

 include/linux/ieee80211.h |   89 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/nl80211.h   |    2 +
 include/net/cfg80211.h    |    4 ++
 net/mac80211/tx.c         |    2 +
 net/wireless/core.c       |   10 ++++-
 net/wireless/reg.c        |    5 ++-
 net/wireless/util.c       |   84 ++++++++++++++++++++++++++++++++++++++----
 7 files changed, 184 insertions(+), 12 deletions(-)

-- 
1.7.9.5

