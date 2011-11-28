Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52889 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1Vi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:38:57 -0500
Received: by vcbfk14 with SMTP id fk14so4064537vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:38:57 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 1/5] cfg80211: clarify set tx power mBm documentation
Date: Mon, 28 Nov 2011 16:38:46 -0500
Message-Id: <1322516330-4007-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223859_939437_38E256AF)
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tons of drivers missed that we use mBm and not dBm...

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/net/cfg80211.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ce6236b..f0e82b2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1402,7 +1402,8 @@ struct cfg80211_gtk_rekey_data {
  *	have changed. The actual parameter values are available in
  *	struct wiphy. If returning an error, no value should be changed.
  *
- * @set_tx_power: set the transmit power according to the parameters
+ * @set_tx_power: set the transmit power according to the parameters,
+ *	the power passed is in mBm, to get dBm use MBM_TO_DBM().
  * @get_tx_power: store the current TX power into the dbm variable;
  *	return 0 if successful
  *
-- 
1.7.4.15.g7811d

