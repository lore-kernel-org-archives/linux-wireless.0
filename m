Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34071 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755879AbcINMpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 08:45:10 -0400
Received: by mail-it0-f66.google.com with SMTP id 186so1438871itf.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2016 05:45:09 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwifiex: fix error handling in mwifiex_create_custom_regdomain
Date: Wed, 14 Sep 2016 08:42:36 -0400
Message-Id: <20160914124236.1951-1-me@bobcopeland.com> (sfid-20160914_144515_376968_21E13FBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

smatch reports:

sta_cmdresp.c:1053 mwifiex_create_custom_regdomain() warn: possible memory leak of 'regd'

Indeed, mwifiex_create_custom_regdomain() returns NULL in the
case that channel is missing in the TLV without freeing regd.

Moreover, some other error paths in this function return ERR_PTR
values which are assigned without checking to the regd field in
the mwifiex_adapter struct.  The latter is only null-checked where
used.

Fix by freeing regd in the error path, and only update
priv->adapter->regd if the returned pointer is valid.

Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
Note, compile-tested only.  It might make sense to instead remove
the ERR_PTR stuff if there is no plan to report them further up the
call stack but I just went for the minimal patch here.
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 3344a26..8548027 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1049,8 +1049,10 @@ mwifiex_create_custom_regdomain(struct mwifiex_private *priv,
 		enum nl80211_band band;
 
 		chan = *buf++;
-		if (!chan)
+		if (!chan) {
+			kfree(regd);
 			return NULL;
+		}
 		chflags = *buf++;
 		band = (chan <= 14) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
 		freq = ieee80211_channel_to_frequency(chan, band);
@@ -1116,6 +1118,7 @@ static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(reg->action);
 	u16 tlv, tlv_buf_len, tlv_buf_left;
 	struct mwifiex_ie_types_header *head;
+	struct ieee80211_regdomain *regd;
 	u8 *tlv_buf;
 
 	if (action != HostCmd_ACT_GEN_GET)
@@ -1137,10 +1140,10 @@ static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
 			mwifiex_dbg_dump(priv->adapter, CMD_D, "CHAN:",
 					 (u8 *)head + sizeof(*head),
 					 tlv_buf_len);
-			priv->adapter->regd =
-				mwifiex_create_custom_regdomain(priv,
-								(u8 *)head +
-						sizeof(*head), tlv_buf_len);
+			regd = mwifiex_create_custom_regdomain(priv,
+				(u8 *)head + sizeof(*head), tlv_buf_len);
+			if (!IS_ERR(regd))
+				priv->adapter->regd = regd;
 			break;
 		}
 
-- 
2.9.0
