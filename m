Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33062 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab1KWP1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:27:32 -0500
Received: by vcbfk14 with SMTP id fk14so426522vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:27:32 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 1/5] cfg80211: clarify set tx power mBm documentation
Date: Wed, 23 Nov 2011 10:27:20 -0500
Message-Id: <1322062044-14831-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_162736_399987_B03D67E4)
In-Reply-To: <1322062044-14831-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322062044-14831-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tons of drivers missed that we use mBm and not dBm...

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/net/cfg80211.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e1891..a992782 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1399,7 +1399,8 @@ struct cfg80211_gtk_rekey_data {
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

