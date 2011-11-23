Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab1KWPlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:41:13 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so572756vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:41:12 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 3/5] mac80211: add support for NL80211_TX_POWER_REG
Date: Wed, 23 Nov 2011 10:40:56 -0500
Message-Id: <1322062858-15276-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164117_790142_26D61318)
In-Reply-To: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already keeps track of user limits and uses the
regulatory limits properly, all we need to do is kick the
hw config routines so that we can kick the hardware.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/mac80211/cfg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2577c45..188cc7c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1666,6 +1666,12 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 			return -EINVAL;
 		local->user_power_level = MBM_TO_DBM(mbm);
 		break;
+	case NL80211_TX_POWER_REG:
+		/*
+		 * ieee80211_hw_config() already has the proper logic
+		 * to deal with this.
+		 */
+		break;
 	}
 
 	ieee80211_hw_config(local, changes);
-- 
1.7.4.15.g7811d

