Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKGIWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 03:22:04 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Add HWSIM_CMD_GET_RADIO command
Date: Fri,  7 Nov 2014 10:21:58 +0200
Message-Id: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141107_092212_259872_B09A0071)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


      Hi,

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


Cheers,

	Patrik


Patrik Flykt (2):
  mac80211-hwsim: Factor out netlink attribute appending
  mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command

 drivers/net/wireless/mac80211_hwsim.c | 167 +++++++++++++++++++++++++++-------
 drivers/net/wireless/mac80211_hwsim.h |   3 +
 2 files changed, 139 insertions(+), 31 deletions(-)

-- 
2.1.1

