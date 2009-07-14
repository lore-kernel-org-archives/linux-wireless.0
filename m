Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4875 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZGNB7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 21:59:04 -0400
Date: Mon, 13 Jul 2009 21:57:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: proski@gnu.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.31] ath5k: temporarily disable crypto for AP mode
Message-ID: <20090714015739.GA28490@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin reported some issues with using AP mode without
nohwcrypt=1.  Most likely this is similar to the problem fixed
some time ago in ath9k by 3f53dd64f192450cb331c0fecfc26ca952fb242f,
"ath9k: Fix hw crypto configuration for TKIP in AP mode."

That only affects TKIP but it's easiest to just disable that and
WEP too until we get a proper fix in.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Pavel, this ok with you for now?

 drivers/net/wireless/ath/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 20ba6fa..7db32ce 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2980,6 +2980,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
+	if (sc->opmode == NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
 	switch (key->alg) {
 	case ALG_WEP:
 	case ALG_TKIP:
-- 
1.6.2.5

-- 
Bob Copeland %% www.bobcopeland.com

