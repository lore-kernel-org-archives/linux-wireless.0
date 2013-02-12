Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lizzard.sbs.de ([194.138.37.39]:31101 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab3BLRL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:11:59 -0500
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Dennis H Jensen <dennis.h.jensen@siemens.com>
Subject: [PATCH] nl80211: Don't add empty bands or disabled channels in NL80211_CMD_GET_WIPHY
Date: Tue, 12 Feb 2013 18:00:24 +0100
Message-Id: <1360688424-11514-1-git-send-email-dennis.h.jensen@siemens.com> (sfid-20130212_181205_257844_18A2C50E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch resolves issues where the driver reports too many channels
for them all to fit in one netlink message, as long as some are
disabled, and makes it possible to use non-standard channels and
customized regulatory databases.

Signed-off-by: Dennis H Jensen <dennis.h.jensen@siemens.com>

---
 net/wireless/nl80211.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 807d448..8cd274d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -986,6 +986,15 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		if (!dev->wiphy.bands[band])
 			continue;
 
+		/* don't add band info if all channels are disabled */
+		for (i = 0; i < dev->wiphy.bands[band]->n_channels; i++) {
+			chan = &dev->wiphy.bands[band]->channels[i];
+			if (!(chan->flags & IEEE80211_CHAN_DISABLED))
+				break;
+		}
+		if (i == dev->wiphy.bands[band]->n_channels)
+			continue;
+
 		nl_band = nla_nest_start(msg, band);
 		if (!nl_band)
 			goto nla_put_failure;
@@ -1018,12 +1027,15 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			goto nla_put_failure;
 
 		for (i = 0; i < dev->wiphy.bands[band]->n_channels; i++) {
+			/* don't add disabled frequencies */
+			chan = &dev->wiphy.bands[band]->channels[i];
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
 			nl_freq = nla_nest_start(msg, i);
 			if (!nl_freq)
 				goto nla_put_failure;
 
-			chan = &dev->wiphy.bands[band]->channels[i];
-
 			if (nl80211_msg_put_channel(msg, chan))
 				goto nla_put_failure;
 
-- 
1.7.9.5

