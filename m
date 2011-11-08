Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHIUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:20:13 -0500
Subject: [PATCH] cfg80211: fix missing kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 09:20:07 +0100
Message-ID: <1320740407.4304.6.camel@jlt3.sipsolutions.net> (sfid-20111108_092017_573288_32199C2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Two new struct members were not documented, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/net/cfg80211.h	2011-11-07 21:09:22.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-08 09:19:03.000000000 +0100
@@ -456,6 +456,9 @@ enum station_parameters_apply_mask {
  *	as the AC bitmap in the QoS info field
  * @max_sp: max Service Period. same format as the MAX_SP in the
  *	QoS info field (but already shifted down)
+ * @sta_modify_mask: bitmap indicating which parameters changed
+ *	(for those that don't have a natural "no change" value),
+ *	see &enum station_parameters_apply_mask
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -615,6 +618,7 @@ struct sta_bss_parameters {
  *	user space MLME/SME implementation. The information is provided for
  *	the cfg80211_new_sta() calls to notify user space of the IEs.
  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
+ * @sta_flags: station flags mask & values
  */
 struct station_info {
 	u32 filled;


