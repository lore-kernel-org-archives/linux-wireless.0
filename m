Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXJZKgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:36:20 -0400
Subject: [PATCH] softmac: fix wext MLME request reason code endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	stable <stable@kernel.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 22:16:23 +0200
Message-Id: <1193343383.4406.30.camel@johannes.berg> (sfid-20071026_113624_594020_CEB03309)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MLME request reason code is host-endian and our passing
it to the low level functions is host-endian as well since
they do the swapping. I noticed that the reason code 768 was
sent (0x300) rather than 3 when wpa_supplicant terminates.
This removes the superfluous cpu_to_le16() call.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I guess that this bug has been present forever. It's not very critical
but what we're sending is in violation of the IEEE 802.11 specs.

 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-10-25 22:09:03.583252548 +0200
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c	2007-10-25 22:09:09.973254502 +0200
@@ -470,7 +470,7 @@ ieee80211softmac_wx_set_mlme(struct net_
 {
 	struct ieee80211softmac_device *mac = ieee80211_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	u16 reason = cpu_to_le16(mlme->reason_code);
+	u16 reason = mlme->reason_code;
 	struct ieee80211softmac_network *net;
 	int err = -EINVAL;
 


