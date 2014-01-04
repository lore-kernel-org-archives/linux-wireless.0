Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39249 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaADVGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jan 2014 16:06:39 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so16922616pbc.25
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jan 2014 13:06:39 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: Fix the buffer length in debugfs for smps
Date: Sun,  5 Jan 2014 02:36:23 +0530
Message-Id: <1388869583-2767-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140104_220642_756290_12DDADC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was blocking sending SMPS action frames 
through debugfs.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 net/mac80211/debugfs_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 04b5a14..1a8fa5f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -265,7 +265,7 @@ static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_smps_mode mode;
 
 	for (mode = 0; mode < IEEE80211_SMPS_NUM_MODES; mode++) {
-		if (strncmp(buf, smps_modes[mode], buflen) == 0) {
+		if (strncmp(buf, smps_modes[mode], buflen-1) == 0) {
 			int err = ieee80211_set_smps(sdata, mode);
 			if (!err)
 				return buflen;
