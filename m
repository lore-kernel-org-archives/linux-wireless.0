Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:14042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbaJaMsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 08:48:52 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/2] Add mcast event when hwsim radios are created and removed
Date: Fri, 31 Oct 2014 14:48:46 +0200
Message-Id: <1414759728-20659-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141031_134855_666933_1CBEAE42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

v3:
- rebased on top of the latest changes in upstream

v2:
- removed old patch 1 as that is already applied
- added suitable prefixes to new function names
- refactored the patch 1 so that multicast message building is
  separated into a more generic function
- instead of passing radio parameters (6 pcs) into different functions
  separately, a struct is used instead

v1:
patch 1 renames HWSIM_CMD_CREATE_RADIO to HWSIM_CMD_NEW_RADIO and
HWSIM_CMD_DESTROY_RADIO to HWSIM_CMD_DEL_RADIO. They are more
fitting on how other pieces of the wireless system work. A define
to old name is provided for backward compatibility.

Patches 2 and 3 use the newly named enums and provide a way to inform
the listeners on the multicast group "config" when new radio is created
and existing radio is deleted.


Jukka Rissanen (2):
  mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
  mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO

 drivers/net/wireless/mac80211_hwsim.c | 329 +++++++++++++++++++++++++---------
 1 file changed, 245 insertions(+), 84 deletions(-)

-- 
1.8.3.1

