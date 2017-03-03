Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63413 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdCCMPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 07:15:10 -0500
From: <mpubbise@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFCv2 1/2] mac80211: Add provision for 802.11 encap offload
Date: Fri, 3 Mar 2017 17:03:26 +0530
Message-ID: <1488540807-27415-2-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170303_131617_155944_76B851FD)
In-Reply-To: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Drivers can have the capability to offload 802.11 encap
to firmware or hardware for data frames. This patch adds a new
hw_flag for driver to advertise the offload support.
Transmit path offloading 802.11 header (including cipher headers)
encap for data frames will be implemented in a separate patch.

Drivers advertising this capability should also implement other
functionalities which deal with 802.11 frame format like below

        - Hardware encryption
        - Aggregation of A-MSDU offload
        - Fragmentation offload

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/debugfs.c |    1 +
 2 files changed, 5 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3edb469..0239b7d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2049,6 +2049,9 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_SUPPORTS_80211_ENCAP: Hardware/driver supports 802.11
+ *	encap for data frames.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2091,6 +2094,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_SUPPORTS_80211_ENCAP,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001..b97ffb4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -211,6 +211,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(SUPPORTS_80211_ENCAP),
 #undef FLAG
 };
 
-- 
1.7.9.5
