Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:32446 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYLCQag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 11:30:36 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1886772nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 08:30:34 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Correctly initialize AID during set_key()
Date: Wed, 3 Dec 2008 17:30:22 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812031729.21220.IvDoorn@gmail.com> <200812031729.48357.IvDoorn@gmail.com>
In-Reply-To: <200812031729.48357.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812031730.22310.IvDoorn@gmail.com> (sfid-20081203_173039_521990_77581E41)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Request the AID from hardware and provide this id
to the driver (in case they need it).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index dded680..38edee5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -487,6 +487,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      struct ieee80211_key_conf *key)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_sta *sta;
 	int (*set_key) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_crypto *crypto,
 			struct ieee80211_key_conf *key);
@@ -537,6 +538,17 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		memcpy(&crypto.key, &key->key[0], key->keylen);
 
 	/*
+	 * Discover the Association ID from mac80211.
+	 * Some drivers need this information when updating the
+	 * hardware key (either adding or removing).
+	 */
+	rcu_read_lock();
+	sta = ieee80211_find_sta(hw, address);
+	if (sta)
+		crypto.aid = sta->aid;
+	rcu_read_unlock();
+
+	/*
 	 * Each BSS has a maximum of 4 shared keys.
 	 * Shared key index values:
 	 *	0) BSS0 key0
-- 
1.5.6.1

