Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2HLL2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 07:28:19 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] 4-way handshake offloading
Date: Sun, 12 Aug 2012 14:28:03 +0300
Message-ID: <1344770884-17102-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120812_132823_584151_BDF098C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rebased and fix in kerneldoc comments

Adding 4-way handshake offload support.

Intention is to support "smart" devices in P2P flow - they tend to
offload as much as possible.

This patch address WPA2-Personal - this is what P2P uses.
WPA2-Enterprise not supported yet.

Currently, ath6kl driver can use this feature (patch in works),
and wil6210 (60g) driver can work only in the offload mode - 
working on security flow right now.

Corresponding patch for WPA supplicant almost ready (by Jouni).
for WPA supplicant, STA part verified; AP not finalized yet.

Vladimir Kondratiev (1):
  cfg80211: Support for 4-way handshake offloading for WPA2-Personal

 include/linux/ieee80211.h |    2 ++
 include/linux/nl80211.h   |   19 +++++++++++++++++++
 include/net/cfg80211.h    |   10 ++++++++++
 net/wireless/nl80211.c    |   16 ++++++++++++++++
 4 files changed, 47 insertions(+)

-- 
1.7.9.5

