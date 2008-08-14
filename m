Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22160 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYHNSnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 14:43:22 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 11:43:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <mcgrof@gmail.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: remove kdoc references to IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE
Date: Thu, 14 Aug 2008 11:43:20 -0700
Message-ID: <1218739400-7999-1-git-send-email-lrodriguez@atheros.com> (sfid-20080814_204325_898293_5EFE258B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE was made unnecessary in
the recent revamp on beacon configuration.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 95de1ff..2055abb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -710,10 +710,7 @@ enum ieee80211_tkip_key_type {
  *	rely on the host system for such buffering. This option is used
  *	to configure the IEEE 802.11 upper layer to buffer broadcast and
  *	multicast frames when there are power saving stations so that
- *	the driver can fetch them with ieee80211_get_buffered_bc(). Note
- *	that not setting this flag works properly only when the
- *	%IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is also not set because
- *	otherwise the stack will not know when the DTIM beacon was sent.
+ *	the driver can fetch them with ieee80211_get_buffered_bc().
  *
  * @IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE:
  *	Hardware is not capable of short slot operation on the 2.4 GHz band.
@@ -1103,10 +1100,8 @@ enum ieee80211_ampdu_mlme_action {
  *	See the section "Frame filtering" for more information.
  *	This callback must be implemented and atomic.
  *
- * @set_tim: Set TIM bit. If the hardware/firmware takes care of beacon
- *	generation (that is, %IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is set)
- *	mac80211 calls this function when a TIM bit must be set or cleared
- *	for a given AID. Must be atomic.
+ * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
+ * 	must be set or cleared for a given AID. Must be atomic.
  *
  * @set_key: See the section "Hardware crypto acceleration"
  *	This callback can sleep, and is only called between add_interface
-- 
1.5.6.rc2.15.g457bb.dirty

