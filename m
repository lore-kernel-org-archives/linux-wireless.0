Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbbIRNTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:19:45 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] mac80211: Deinline large functions in driver-ops.h
Date: Fri, 18 Sep 2015 15:19:33 +0200
Message-Id: <1442582379-10342-1-git-send-email-dvlasenk@redhat.com> (sfid-20150918_152212_883153_32910567)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After measuring size of inlines, these functions were found to be largest.
These patches reduce code size by about 21 kbytes.

CC: John Linville <linville@tuxdriver.com>
CC: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org

Denys Vlasenko (6):
  mac80211: Deinline drv_conf_tx()
  mac80211: Deinline drv_sta_rc_update()
  mac80211: Deinline drv_ampdu_action()
  mac80211: Deinline drv_get/set/reset_tsf()
  mac80211: Deinline drv_add/remove/change_interface()
  mac80211: Deinline drv_switch_vif_chanctx()

 net/mac80211/driver-ops.c | 223 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 237 ++++++----------------------------------------
 2 files changed, 250 insertions(+), 210 deletions(-)

-- 
1.8.1.4

