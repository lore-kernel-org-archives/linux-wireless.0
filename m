Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2CMPHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:07:19 -0400
Message-Id: <20120313150613.300612962@sipsolutions.net> (sfid-20120313_160723_685669_68C2D49D)
Date: Tue, 13 Mar 2012 16:06:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Bing Zhao <bzhao@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.5] cfg80211: enforce lack of interface combinations
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My grand plan to allow drivers to gradually move over
to advertising virtual interface combinations and only
enforce with drivers that do want it enforced doesn't
seem to be working out, only Christian ever added the
advertising (to carl9170), nobody else did.

Begin enforcing combinations in cfg80211 so that users
can rely on the information reported about a device.

Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>  
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Luciano Coelho <coelho@ti.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    6 +-----
 net/wireless/core.c    |    4 ----
 net/wireless/util.c    |    7 -------
 3 files changed, 1 insertion(+), 16 deletions(-)

--- a/include/net/cfg80211.h	2012-03-13 13:49:53.000000000 +0100
+++ b/include/net/cfg80211.h	2012-03-13 15:54:10.000000000 +0100
@@ -1729,10 +1729,6 @@ struct cfg80211_ops {
  *	hints read the documenation for regulatory_hint_found_beacon()
  * @WIPHY_FLAG_NETNS_OK: if not set, do not allow changing the netns of this
  *	wiphy at all
- * @WIPHY_FLAG_ENFORCE_COMBINATIONS: Set this flag to enforce interface
- *	combinations for this device. This flag is used for backward
- *	compatibility only until all drivers advertise combinations and
- *	they will always be enforced.
  * @WIPHY_FLAG_PS_ON_BY_DEFAULT: if set to true, powersave will be enabled
  *	by default -- this flag will be set depending on the kernel's default
  *	on wiphy_new(), but can be changed by the driver if it has a good
@@ -1777,7 +1773,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
-	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
+	/* use hole at 12 */
 	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
--- a/net/wireless/core.c	2012-03-10 09:17:06.000000000 +0100
+++ b/net/wireless/core.c	2012-03-13 15:54:21.000000000 +0100
@@ -422,10 +422,6 @@ static int wiphy_verify_combinations(str
 	const struct ieee80211_iface_combination *c;
 	int i, j;
 
-	/* If we have combinations enforce them */
-	if (wiphy->n_iface_combinations)
-		wiphy->flags |= WIPHY_FLAG_ENFORCE_COMBINATIONS;
-
 	for (i = 0; i < wiphy->n_iface_combinations; i++) {
 		u32 cnt = 0;
 		u16 all_iftypes = 0;
--- a/net/wireless/util.c	2012-03-13 14:41:05.000000000 +0100
+++ b/net/wireless/util.c	2012-03-13 15:54:34.000000000 +0100
@@ -946,13 +946,6 @@ int cfg80211_can_change_interface(struct
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
 		return 0;
 
-	/*
-	 * Drivers will gradually all set this flag, until all
-	 * have it we only enforce for those that set it.
-	 */
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_ENFORCE_COMBINATIONS))
-		return 0;
-
 	memset(num, 0, sizeof(num));
 
 	num[iftype] = 1;


