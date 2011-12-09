Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64588 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LICoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 21:44:01 -0500
Received: by vbbfc26 with SMTP id fc26so1995451vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 18:44:00 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH] iwlwifi regression in 20111205 merge
Date: Thu,  8 Dec 2011 21:43:39 -0500
Message-Id: <1323398619-19774-1-git-send-email-mar.kolya@gmail.com> (sfid-20111209_034406_425038_0453D615)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  It looks like the regression was introduced between 20111202 and
20111205 (linux-next tree). Symptoms: connection to AP seem to be
established, but no data goes though it in any way. Tested on intel
5300.
  Peek at the changes have shown that it looks like at least part of
the code wasn't merged properly. It was originally committed into
iwl_agn.c but code in question was moved to iwl-mac80211.c.
  This patch puts code in place and my card works again.
  I hope this patch will be reviewed by people developing iwl
driver. Also, it is possible that some other iwl code didn't make it
though 20111205 merge as well, so this probably should be checked too.
  Please let me know if I can provide any more info.
  Thanks!

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 794b735..55308b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -517,6 +517,17 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_CCMP:
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		break;
+	default:
+		break;
+	}
+
 	/*
 	 * We could program these keys into the hardware as well, but we
 	 * don't expect much multicast traffic in IBSS and having keys
-- 
1.7.4.1

