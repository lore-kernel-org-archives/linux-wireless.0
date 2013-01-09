Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51449 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985Ab3AIRhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:37:00 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so2431929iej.32
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 09:37:00 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] mac80211: set NEED_TXPROCESSING for PERR frames
Date: Wed,  9 Jan 2013 12:34:55 -0500
Message-Id: <1357752896-17497-1-git-send-email-me@bobcopeland.com> (sfid-20130109_183706_323729_79D5D5E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A user reported warnings in ath5k due to transmitting frames with no
rates set up.  The frames were Mesh PERR frames, and some debugging
showed an empty control block with just the vif pointer:

>  [  562.522682] XXX txinfo: 00000000: 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00  ................
>  [  562.522688] XXX txinfo: 00000010: 00 00 00 00 00 00 00 00 54 b8 f2
>  db 00 00 00 00  ........T.......
>  [  562.522693] XXX txinfo: 00000020: 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00  ................

Set the IEEE80211_TX_INTFL_NEED_TXPROCESSING flag to ensure that
rate control gets run before the frame is sent.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_hwmp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f0b384e..e3b3959 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -215,6 +215,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 	skb->priority = 7;
 
 	info->control.vif = &sdata->vif;
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 	ieee80211_set_qos_hdr(sdata, skb);
 }
 
-- 
1.7.10.4

