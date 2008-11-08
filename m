Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:37638 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYKHDxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 22:53:01 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mA83rYM2031867
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Sat, 8 Nov 2008 03:53:35 GMT
Date: Fri, 7 Nov 2008 19:50:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: akpm@linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove more excess kernel-doc
Message-Id: <20081107195042.be6aa4ec.randy.dunlap@oracle.com> (sfid-20081108_045308_580627_35DAA9FE)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Delete kernel-doc struct descriptions for fields that don't exist:

Warning(include/net/mac80211.h:1263): Excess struct/union/enum/typedef member 'conf_ht' description in 'ieee80211_ops'
Warning(net/mac80211/sta_info.h:309): Excess struct/union/enum/typedef member 'addr' description in 'sta_info'
Warning(net/mac80211/sta_info.h:309): Excess struct/union/enum/typedef member 'aid' description in 'sta_info'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Johannes Berg <johannes@sipsolutions.net>
cc: John W. Linville <linville@tuxdriver.com>
---
 include/net/mac80211.h  |    2 --
 net/mac80211/sta_info.h |    3 ---
 2 files changed, 5 deletions(-)

--- linux-2.6.28-rc3-git4.orig/include/net/mac80211.h
+++ linux-2.6.28-rc3-git4/include/net/mac80211.h
@@ -1202,8 +1202,6 @@ enum ieee80211_ampdu_mlme_action {
  *	This is needed only for IBSS mode and the result of this function is
  *	used to determine whether to reply to Probe Requests.
  *
- * @conf_ht: Configures low level driver with 802.11n HT data. Must be atomic.
- *
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
--- linux-2.6.28-rc3-git4.orig/net/mac80211/sta_info.h
+++ linux-2.6.28-rc3-git4/net/mac80211/sta_info.h
@@ -167,9 +167,6 @@ struct sta_ampdu_mlme {
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @flaglock: spinlock for flags accesses
- * @addr: MAC address of this STA
- * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
- *	only used in AP (and IBSS?) mode
  * @listen_interval: TBD
  * @pin_status: TBD
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
