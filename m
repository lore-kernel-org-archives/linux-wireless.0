Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1ECX5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:49 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so260225pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:49 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
Date: Tue,  3 May 2011 16:57:19 -0700
Message-Id: <1304467039-7730-14-git-send-email-javier@cozybit.com> (sfid-20110504_015753_908012_F99D58EF)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh beaconing on ath9k was broken by this commit:

commit 4801416c76a3a355076d6d371c00270dfe332e1c
Author: Ben Greear <greearb@candelatech.com>
Date:   Sat Jan 15 19:13:48 2011 +0000

This patch assigns the right opmode when the device is used in mesh
mode.

Reported-by: Fabrice Deyber fabricedeyber@agilemesh.com
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c3dbf26..8fa07aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1384,7 +1384,9 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 		ath9k_hw_set_tsfadjust(ah, 0);
 		sc->sc_flags &= ~SC_OP_TSF_RESET;
 
-		if (iter_data.nwds + iter_data.nmeshes)
+		if (iter_data.nmeshes)
+			ah->opmode = NL80211_IFTYPE_MESH_POINT;
+		else if (iter_data.nwds)
 			ah->opmode = NL80211_IFTYPE_AP;
 		else if (iter_data.nadhocs)
 			ah->opmode = NL80211_IFTYPE_ADHOC;
-- 
1.7.1

