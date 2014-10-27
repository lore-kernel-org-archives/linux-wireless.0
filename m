Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaJ0Kpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:45:32 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] Add mcast event when hwsim radios are created and removed
Date: Mon, 27 Oct 2014 12:44:45 +0200
Message-Id: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114536_599448_FF2C1C5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

patch 1 renames HWSIM_CMD_CREATE_RADIO to HWSIM_CMD_NEW_RADIO and
HWSIM_CMD_DESTROY_RADIO to HWSIM_CMD_DEL_RADIO. They are more
fitting on how other pieces of the wireless system work. A define
to old name is provided for backward compatibility.

Patches 2 and 3 use the newly named enums and provide a way to inform
the listeners on the multicast group "config" when new radio is created
and existing radio is deleted.


Cheers,
Jukka


Jukka Rissanen (3):
  mac80211-hwsim: Rename CREATE and DESTROY radio to NEW and DEL radio
  mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
  mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO

 drivers/net/wireless/mac80211_hwsim.c | 184 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/mac80211_hwsim.h |  14 ++-
 2 files changed, 169 insertions(+), 29 deletions(-)

-- 
1.8.3.1

