Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbbHRH6k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/26] iwlwifi: out-of-bounds access in iwl_init_sband_channels
Date: Tue, 18 Aug 2015 10:57:34 +0300
Message-Id: <1439884656-18146-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100110_153336_5F0AAE17)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adrien Schildknecht <adrien+dev@schischi.me>

KASan error report:
==================================================================
BUG: KASan: out of bounds access in iwl_init_sband_channels+0x207/0x260 [iwlwifi] at addr ffff8800c2d0aac8
Read of size 4 by task modprobe/329
==================================================================

Both loops of this function compare data from the 'chan' array and then
check if the index is valid.

The 2 conditions should be inverted to avoid an out-of-bounds access.

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 21302b6..acc3d18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -713,12 +713,12 @@ int iwl_init_sband_channels(struct iwl_nvm_data *data,
 	struct ieee80211_channel *chan = &data->channels[0];
 	int n = 0, idx = 0;
 
-	while (chan->band != band && idx < n_channels)
+	while (idx < n_channels && chan->band != band)
 		chan = &data->channels[++idx];
 
 	sband->channels = &data->channels[idx];
 
-	while (chan->band == band && idx < n_channels) {
+	while (idx < n_channels && chan->band == band) {
 		chan = &data->channels[++idx];
 		n++;
 	}
-- 
2.1.4

