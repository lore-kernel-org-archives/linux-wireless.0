Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156AbaJ3PgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 11:36:12 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] Add mcast event when hwsim radios are created and removed
Date: Thu, 30 Oct 2014 17:34:24 +0200
Message-Id: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141030_163615_143606_638F9ADD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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

 drivers/net/wireless/mac80211_hwsim.c | 285 ++++++++++++++++++++++++++--------
 1 file changed, 216 insertions(+), 69 deletions(-)

-- 
1.8.3.1

