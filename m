Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:32843 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbbGNMcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:32:15 -0400
Received: by ietj16 with SMTP id j16so10056358iet.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:32:14 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 2/5] mac80211: add missing length check for confirm frames
Date: Tue, 14 Jul 2015 08:31:56 -0400
Message-Id: <1436877119-17577-3-git-send-email-me@bobcopeland.com> (sfid-20150714_143219_590927_15FC051D)
In-Reply-To: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although mesh_rx_plink_frame() already checks that frames have enough
bytes for the action code plus another two bytes for capability/reason
code, it doesn't take into account that confirm frames also have an
additional two-byte aid.  As a result, a corrupt frame could cause a
subsequent subtraction to wrap around to ill effect.  Add another
check for this case.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

v3: newly introduced

 net/mac80211/mesh_plink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 956384087e12..ac1029f28133 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -1123,6 +1123,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 						WLAN_SP_MESH_PEERING_CONFIRM) {
 		baseaddr += 4;
 		baselen += 4;
+
+		if (baselen > len)
+			return;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
 	mesh_process_plink_frame(sdata, mgmt, &elems);
-- 
2.1.4

