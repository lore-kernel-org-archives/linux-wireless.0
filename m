Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57630 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3BPSm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 13:42:26 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so1049876pbc.5
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2013 10:42:26 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] mac80211: don't spam mesh probe response messages
Date: Sat, 16 Feb 2013 10:41:06 -0800
Message-Id: <1361040066-5771-3-git-send-email-thomas@cozybit.com> (sfid-20130216_194229_654147_69699B11)
In-Reply-To: <1361040066-5771-1-git-send-email-thomas@cozybit.com>
References: <1361040066-5771-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If mesh plink debugging is enabled, this gets annoying in
a crowded environment, fast.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b022332..29ce2aa 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -925,7 +925,6 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
 	memcpy(hdr->da, mgmt->sa, ETH_ALEN);
-	mpl_dbg(sdata, "sending probe resp. to %pM\n", hdr->da);
 	IEEE80211_SKB_CB(presp)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, presp);
 out:
-- 
1.7.10.4

