Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36017 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcFBMoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 08:44:07 -0400
Received: by mail-it0-f66.google.com with SMTP id i127so2622512ita.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 05:44:07 -0700 (PDT)
Received: from hash (CPE0018e7fe5281-CM18593342f28f.cpe.net.cable.rogers.com. [99.254.238.186])
        by smtp.gmail.com with ESMTPSA id p132sm372047iod.29.2016.06.02.05.44.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jun 2016 05:44:05 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix misplaced default label in sifs switch
Date: Thu,  2 Jun 2016 08:43:50 -0400
Message-Id: <1464871430-23803-1-git-send-email-me@bobcopeland.com> (sfid-20160602_144412_846293_C6846C53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this switch statement, the default case does not always assign
sifs.  In practice, ah->ah_bwmode cannot take values besides the
other labels, so this is not an actual problem, but it looks odd
and smatch complains thus:

    ath5k_hw_get_default_sifs() warn: missing break? reassigning 'sifs'

Silence the warning by moving default label up a line.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index fc47b70..f23c851 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -219,8 +219,8 @@ ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 		sifs = AR5K_INIT_SIFS_QUARTER_RATE;
 		break;
 	case AR5K_BWMODE_DEFAULT:
-		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
 	default:
+		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
 		if (channel->band == NL80211_BAND_5GHZ)
 			sifs = AR5K_INIT_SIFS_DEFAULT_A;
 		break;
-- 
2.1.4

