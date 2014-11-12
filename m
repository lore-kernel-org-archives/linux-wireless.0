Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59098 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaKLOnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:43:40 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] Add HWSIM_CMD_GET_RADIO command
Date: Wed, 12 Nov 2014 16:42:38 +0200
Message-Id: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141112_154345_910601_9574409E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


	Hi,

v2:
- Free skb in the error path in patch 01
- Fix dumping of hwsim radios in patch 02. Remember the last radio id used
  when adding radios to the previous netlink message and continue from this
  radio id onwards.


Cheers,

	Patrik


This patch set adds a new HWSIM_CMD_GET_RADIO command to mac80211_hwsim
which allows a user space application to dump a list of all hwsim radios
in the system. HWSIM_CMD_GET_RADIO can also return information about a
specific hwsim radio whose radio id is given with HWSIM_ATTR_RADIO_ID.

The first patch factors out netlink attribute appending from netlink
message creation so that the same information can be appended to
HWSIM_CMD_GET_RADIO replies as is already sent by multicast when issuing
a HWSIM_CMD_CREATE_RADIO command.

Patch 2/2 adds the new command providing means to dump all or one of the
existing radios. Regulatory data is saved to the hwsim struct as it
seems difficult to access it otherwise when needed.


Patrik Flykt (2):
  mac80211-hwsim: Factor out netlink attribute appending
  mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command

 drivers/net/wireless/mac80211_hwsim.c | 183 ++++++++++++++++++++++++++++------
 drivers/net/wireless/mac80211_hwsim.h |   3 +
 2 files changed, 155 insertions(+), 31 deletions(-)

-- 
2.1.1

