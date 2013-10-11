Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3JKMxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 08:53:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: radiotap: fix parsing buffer overrun
Date: Fri, 11 Oct 2013 14:53:02 +0200
Message-Id: <1381495982-28486-1-git-send-email-johannes@sipsolutions.net> (sfid-20131011_145313_711958_FED82D6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When parsing an invalid radiotap header, the parser can overrun
the buffer that is passed in because it doesn't correctly check
 1) the minimum radiotap header size
 2) the space for extended bitmaps

The first issue doesn't affect any in-kernel user as they all
check the minimum size before calling the radiotap function.
The second issue could potentially affect the kernel if an skb
is passed in that consists only of the radiotap header with a
lot of extended bitmaps that extend past the SKB. In that case
a read-only buffer overrun by at most 4 bytes is possible.

Fix this by adding the appropriate checks to the parser.

Cc: stable@vger.kernel.org
Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/radiotap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 7d604c0..6c67926 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -102,6 +102,8 @@ int ieee80211_radiotap_iterator_init(
 		return -EINVAL;
 
 	/* sanity check for allowed length and radiotap length field */
+	if (max_length < sizeof(struct ieee80211_radiotap_header))
+		return -EINVAL;
 	if (max_length < get_unaligned_le16(&radiotap_header->it_len))
 		return -EINVAL;
 
@@ -131,7 +133,8 @@ int ieee80211_radiotap_iterator_init(
 			 */
 
 			if ((unsigned long)iterator->_arg -
-			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_rtheader +
+			    sizeof(uint32_t >
 			    (unsigned long)iterator->_max_length)
 				return -EINVAL;
 		}
-- 
1.8.4.rc3

