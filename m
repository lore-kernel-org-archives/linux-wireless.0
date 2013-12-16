Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3LPLHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 06:07:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13] radiotap: fix bitmap-end-finding buffer overrun
Date: Mon, 16 Dec 2013 12:06:58 +0100
Message-Id: <1387192018-32680-1-git-send-email-johannes@sipsolutions.net> (sfid-20131216_120714_834532_0259C130)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Evan Huus found (by fuzzing in wireshark) that the radiotap
iterator code can access beyond the length of the buffer if
the first bitmap claims an extension but then there's no
data at all. Fix this.

Cc: stable@vger.kernel.org
Reported-by: Evan Huus <eapache@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/radiotap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index a271c27..722da61 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -124,6 +124,10 @@ int ieee80211_radiotap_iterator_init(
 	/* find payload start allowing for extended bitmap(s) */
 
 	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+		if ((unsigned long)iterator->_arg -
+		    (unsigned long)iterator->_rtheader + sizeof(uint32_t) >
+		    (unsigned long)iterator->_max_length)
+			return -EINVAL;
 		while (get_unaligned_le32(iterator->_arg) &
 					(1 << IEEE80211_RADIOTAP_EXT)) {
 			iterator->_arg += sizeof(uint32_t);
-- 
1.8.5.1

