Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51371 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041Ab3BLH4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 02:56:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] nl80211: minor correction in sample wowlan mask calculation
Date: Mon, 11 Feb 2013 23:56:40 -0800
Message-Id: <1360655802-21515-1-git-send-email-bzhao@marvell.com> (sfid-20130212_085700_217555_97ECE36A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The match 00:xx:00:00:xx:00:00:00:00:xx:xx:xx (where xx indicates
"don't care") should be represented by a pattern of twelve zero
bytes, and a mask of "0xed,0x01", not "0xed,0x07".

mask_len = (pat_len + 7) / 8 = (12 + 7) / 8 = 2
Hence the mask will be of 2 bytes.
Replace each valid byte in pattern by 1 and don't care byte by 0:
10110111 1000 (0000)

1st byte of pattern corresponds to lower order bit in first byte
of mask. And 9th byte of pattern corresponds to lower order bit
in second byte of mask. With this logic the mask will be
11101101 00000001 = 0xed 0x01

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/uapi/linux/nl80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a2ecdc..b233211 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2906,7 +2906,7 @@ enum nl80211_tx_power_setting {
  *	corresponds to the lowest-order bit in the second byte of the mask.
  *	For example: The match 00:xx:00:00:xx:00:00:00:00:xx:xx:xx (where
  *	xx indicates "don't care") would be represented by a pattern of
- *	twelve zero bytes, and a mask of "0xed,0x07".
+ *	twelve zero bytes, and a mask of "0xed,0x01".
  *	Note that the pattern matching is done as though frames were not
  *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
  *	first (including SNAP header unpacking) and then matched.
-- 
1.8.0

