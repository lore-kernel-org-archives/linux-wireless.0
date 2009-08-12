Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:38253 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHLSP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:15:29 -0400
Received: by rv-out-0506.google.com with SMTP id f6so67731rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:15:31 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: David Woo <xinhua_wu@realsil.com.cn>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 2/2] mac80211: Fix invalid length passed to IE parser for PLINK CONFIRM frames
Date: Wed, 12 Aug 2009 11:03:44 -0700
Message-Id: <1250100224-23832-3-git-send-email-javier@cozybit.com>
In-Reply-To: <1250100224-23832-2-git-send-email-javier@cozybit.com>
References: <4A82639F.6000908@realsil.com.cn>
 <1250100224-23832-1-git-send-email-javier@cozybit.com>
 <1250100224-23832-2-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woo <xinhua_wu@realsil.com.cn>

The length of the fixed portion of plink confirm frames is 4 bytes longer than
the other plink_action frames.  This path corrects an error in the length
adjustment done for these type of frames.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_plink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7c49c95..3575fe3 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -415,7 +415,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
 	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
 		baseaddr += 4;
-		baselen -= 4;
+		baselen += 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
 	if (!elems.peer_link) {
-- 
1.5.4.3

