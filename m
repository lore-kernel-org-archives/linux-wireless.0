Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59756 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752923AbeBSMtD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:49:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:42 +0200
Message-Id: <20180219124847.27169-9-luca@coelho.fi> (sfid-20180219_134910_816851_F2C4FE1B)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 08/13] mac80211: Do not disconnect on invalid operating class
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Some APs include a non global operating class in their extended channel
switch information element. In such a case, as the operating class is not
known, mac80211 would decide to disconnect.

However the specification states that the operating class needs to be
taken from Annex E, but it does not specify from which table it should be
taken, so it is valid for an AP to use a non global operating class.

To avoid possibly unneeded disconnection, in such a case ignore the
operating class and assume that the current band is used, and if the
resulting channel and band configuration is invalid disconnect.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/spectmgmt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index ee0181778a42..029334835747 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -8,6 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2008, Intel Corporation
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -27,7 +28,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie)
 {
-	enum nl80211_band new_band;
+	enum nl80211_band new_band = current_band;
 	int new_freq;
 	u8 new_chan_no;
 	struct ieee80211_channel *new_chan;
@@ -55,15 +56,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				elems->ext_chansw_ie->new_operating_class,
 				&new_band)) {
 			sdata_info(sdata,
-				   "cannot understand ECSA IE operating class %d, disconnecting\n",
+				   "cannot understand ECSA IE operating class, %d, ignoring\n",
 				   elems->ext_chansw_ie->new_operating_class);
-			return -EINVAL;
 		}
 		new_chan_no = elems->ext_chansw_ie->new_ch_num;
 		csa_ie->count = elems->ext_chansw_ie->count;
 		csa_ie->mode = elems->ext_chansw_ie->mode;
 	} else if (elems->ch_switch_ie) {
-		new_band = current_band;
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
 		csa_ie->count = elems->ch_switch_ie->count;
 		csa_ie->mode = elems->ch_switch_ie->mode;
-- 
2.15.1
