Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60960 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0LGVmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:42:14 -0500
Received: by mail-pv0-f174.google.com with SMTP id 4so105423pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 13:42:13 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath5k: Prevent mesh interfaces from being counted as ad-hoc
Date: Tue,  7 Dec 2010 13:36:55 -0800
Message-Id: <1291757815-29867-1-git-send-email-javier@cozybit.com>
In-Reply-To: <20101207205829.GL2700@tuxdriver.com>
References: <20101207205829.GL2700@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This results in an erroneus num_adhoc_vifs count, as the this counter
was incremented but not decremented for mesh interfaces.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6c35730..2bf2e28 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2998,7 +2998,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		sc->bslot[avf->bslot] = vif;
 		if (avf->opmode == NL80211_IFTYPE_AP)
 			sc->num_ap_vifs++;
-		else
+		else if (avf->opmode == NL80211_IFTYPE_ADHOC)
 			sc->num_adhoc_vifs++;
 	}
 
-- 
1.7.1

