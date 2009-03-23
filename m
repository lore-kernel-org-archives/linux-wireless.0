Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZCWQcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:22 -0400
Message-Id: <20090323162834.154525349@sipsolutions.net> (sfid-20090323_173225_411533_528EB86B)
Date: Mon, 23 Mar 2009 17:28:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] mac80211 aggregation improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
   
Here's my patch set for improving aggregation, it contains

 * mac80211: rewrite fragmentation
 * mac80211: fix A-MPDU queue assignment
 * mac80211: rework the pending packets code
 * mac80211: clean up __ieee80211_tx args   
 * mac80211: unify and fix TX aggregation start
 * mac80211: add skb length sanity checking
 * mac80211: fix aggregation to not require queue stop
 * mac80211/iwlwifi: move virtual A-MDPU queue bookkeeping to iwlwifi

The skb length sanity checking isn't strictly part of this series,
but it would help debug things like the zd1211 problem Jouni fixed
recently, and I wanted to do it after the third patch due to the  
amount of code changes in that.

The rest of the code changes fix/rework some things related to
pending frames and fragmentation (to be able to work with that
code for pending aggregation frames), clean up some aggregation
code and finally remove a lot of the code that was necessary for
trying to handle hardware aggregation queues in mac80211 -- the 
code for handling it in the driver is much simpler (because it  
can be less generic) too.

Despite adding new features, long comments and reworking things
the diffstat thus looks fairly good with not many new code lines
in total:

 drivers/net/wireless/ath9k/main.c           |    2
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   52 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    8   
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2   
 drivers/net/wireless/mac80211_hwsim.c       |    1   
 include/net/mac80211.h                      |   22   
 net/mac80211/agg-tx.c                       |  243 ++++-----
 net/mac80211/ieee80211_i.h                  |   31 -
 net/mac80211/main.c                         |   13  
 net/mac80211/sta_info.c                     |   17  
 net/mac80211/sta_info.h                     |    4  
 net/mac80211/tx.c                           |  704 +++++++++++++++-------------
 net/mac80211/util.c                         |   97 +--
 net/mac80211/wep.c                          |   21    
 net/mac80211/wpa.c                          |   28 -  
 20 files changed, 656 insertions(+), 614 deletions(-) 


I've tested this with various Intel hardware, Sujith has also
tested with ath9k hardware (thanks!)

johannes

