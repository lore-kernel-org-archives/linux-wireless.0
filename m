Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:33835 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab1EDGrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 02:47:45 -0400
Date: Tue, 3 May 2011 22:45:16 -0700
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Fix set_key regression with some drivers
Message-ID: <20110504054516.GA10455@jm.kir.nu> (sfid-20110504_084750_955414_29AE4B1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit dbd2fd656f2060abfd3a16257f8b51ec60f6d2ed added a mechanism for
user space to indicate whether a default key is being configured for
only unicast or only multicast frames instead of all frames. This
commit added a driver capability flag for indicating whether separate
default keys are supported and validation of the set_key command based
on that capability.

However, this single capability flag is not enough to cover possible
difference based on mode (AP/IBSS/STA) and the way this change was
introduced resulted in a regression with drivers that do not indicate
the new capability (i.e.., more or less any non-mac80211 driver using
cfg80211) when using a recent wpa_supplicant snapshot.

Fix the regression by removing the new check which is not strictly
speaking needed. The new separate default key functionality is needed
only for RSN IBSS which has a separate capability indication.

Cc: stable@kernel.org
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2011-05-03 09:51:44.718988609 -0700
+++ wireless-testing/net/wireless/nl80211.c	2011-05-03 09:52:27.114455629 -0700
@@ -1682,14 +1682,6 @@
 		if (err)
 			goto out;
 
-		if (!(rdev->wiphy.flags &
-				WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS)) {
-			if (!key.def_uni || !key.def_multi) {
-				err = -EOPNOTSUPP;
-				goto out;
-			}
-		}
-
 		err = rdev->ops->set_default_key(&rdev->wiphy, dev, key.idx,
 						 key.def_uni, key.def_multi);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
