Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaAGXPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 07/12] mac80211_hwsim: assign index from separate counter
Date: Wed,  8 Jan 2014 00:15:12 +0100
Message-Id: <1389136517-21216-8-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001537_985584_F59D24C3)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To later allow dynamic registration, assign the index for the
struct device and MAC address from a new free-running counter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 5670ecb..08d8d61 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -217,6 +217,7 @@ static const struct ieee80211_rate hwsim_rates[] = {
 
 static spinlock_t hwsim_radio_lock;
 static struct list_head hwsim_radios;
+static int hwsim_radio_idx;
 
 struct mac80211_hwsim_data {
 	struct list_head list;
@@ -2123,7 +2124,7 @@ static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	}
 };
 
-static int __init mac80211_hwsim_create_radio(int idx)
+static int __init mac80211_hwsim_create_radio(void)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2131,6 +2132,11 @@ static int __init mac80211_hwsim_create_radio(int idx)
 	struct ieee80211_hw *hw;
 	enum ieee80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
+	int idx;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	idx = hwsim_radio_idx++;
+	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (channels > 1)
 		ops = &mac80211_hwsim_mchan_ops;
@@ -2372,7 +2378,7 @@ static int __init init_mac80211_hwsim(void)
 	}
 
 	for (i = 0; i < radios; i++) {
-		err = mac80211_hwsim_create_radio(i);
+		err = mac80211_hwsim_create_radio();
 		if (err)
 			goto out_free_radios;
 	}
-- 
1.8.5.1

