Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2HAU6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 16:58:50 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 1/2] cfg80211: add channel flag to prohibit OFDM operation
Date: Wed,  1 Aug 2012 15:58:42 -0500
Message-Id: <1343854723-21987-2-git-send-email-seth.forshee@canonical.com> (sfid-20120801_225855_504212_023729E9)
In-Reply-To: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the only way for wireless drivers to tell whether or not OFDM
is allowed on the current channel is to check the regulatory
information. However, this requires hodling cfg80211_mutex, which is not
visible to the drivers.

Other regulatory restrictions are provided as flags in the channel
definition, so let's do similarly with OFDM. This patch adds a new flag,
IEEE80211_CHAN_NO_OFDM, to tell drivers that OFDM on a channel is not
allowed. This flag is set on any channels for which regulatory indicates
that OFDM is prohibited.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/reg.c     |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..3d254e1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -96,6 +96,7 @@ enum ieee80211_band {
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
  * 	is not permitted.
+ * @IEEE80211_CHAN_NO_OFDM: OFDM is not allowed on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -104,6 +105,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_RADAR		= 1<<3,
 	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
 	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..0f3a8a1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -680,6 +680,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_IBSS;
 	if (rd_flags & NL80211_RRF_DFS)
 		channel_flags |= IEEE80211_CHAN_RADAR;
+	if (rd_flags & NL80211_RRF_NO_OFDM)
+		channel_flags |= IEEE80211_CHAN_NO_OFDM;
 	return channel_flags;
 }
 
-- 
1.7.9.5

