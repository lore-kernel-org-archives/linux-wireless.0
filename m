Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZERR4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 13:56:44 -0400
Subject: [PATCH] cfg80211: allow wext to remove keys that don't exist
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 19:56:36 +0200
Message-Id: <1242669396.29049.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some applications using wireless extensions expect to be able to
remove a key that doesn't exist. One example is wpa_supplicant
which doesn't actually change behaviour when running into an
error while trying to do that, but it prints an error message
which users interpret as wpa_supplicant having problems.

The safe thing to do is not change the behaviour of wireless
extensions any more, so when the driver reports -ENOENT let
the wext bridge code return success to userspace. To guarantee
this, also document that drivers should return -ENOENT when the
key doesn't exist.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    5 +++--
 net/wireless/wext-compat.c |    7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-05-18 19:49:55.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-05-18 19:50:53.000000000 +0200
@@ -778,10 +778,11 @@ enum wiphy_params_flags {
  * @get_key: get information about the key with the given parameters.
  *	@mac_addr will be %NULL when requesting information for a group
  *	key. All pointers given to the @callback function need not be valid
- *	after it returns.
+ *	after it returns. This function should return an error if it is
+ *	not possible to retrieve the key, -ENOENT if it doesn't exist.
  *
  * @del_key: remove a key given the @mac_addr (%NULL for a group key)
- *	and @key_index
+ *	and @key_index, return -ENOENT if the key doesn't exist.
  *
  * @set_default_key: set the default key on an interface
  *
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-18 19:48:29.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-05-18 19:49:52.000000000 +0200
@@ -504,6 +504,13 @@ static int cfg80211_set_encryption(struc
 			else if (idx == wdev->wext.default_mgmt_key)
 				wdev->wext.default_mgmt_key = -1;
 		}
+		/*
+		 * Applications using wireless extensions expect to be
+		 * able to delete keys that don't exist, so allow that.
+		 */
+		if (err == -ENOENT)
+			return 0;
+
 		return err;
 	} else {
 		if (addr)


