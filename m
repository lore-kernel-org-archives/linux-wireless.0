Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47128 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGZOqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2014 10:46:35 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so2346622wiw.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2014 07:46:34 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: mac80211: trace.h:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:48:00 +0200
Message-Id: <1406386080-4062-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140726_164639_060281_AFF6ACC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/mac80211/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index cfe1a06..e475a29 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1445,7 +1445,7 @@ TRACE_EVENT(drv_switch_vif_chanctx,
 
 				SWITCH_ENTRY_ASSIGN(vif.vif_type, vif->type);
 				SWITCH_ENTRY_ASSIGN(vif.p2p, vif->p2p);
-				strncpy(local_vifs[i].vif.vif_name,
+				strlcpy(local_vifs[i].vif.vif_name,
 					sdata->name,
 					sizeof(local_vifs[i].vif.vif_name));
 				SWITCH_ENTRY_ASSIGN(old_chandef.control_freq,
-- 
1.7.10.4

