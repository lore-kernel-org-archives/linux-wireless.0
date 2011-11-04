Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51318 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1KDOtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:49:36 -0400
Received: by qabj40 with SMTP id j40so2139371qab.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 07:49:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Nov 2011 15:49:35 +0100
Message-ID: <CAFED-jmnK5qKG6pMUHC__8CnoJwaBoihV_U5p-JoyAH6VW1rNw@mail.gmail.com> (sfid-20111104_154939_531853_91626D41)
Subject: mac80211: UAPSD - seems MORE_DATA bit is not set in all cases
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Seems we don't set MORE_DATA bit correctly in
ieee80211_sta_ps_deliver_response() fuction.
In case we have more than one frame in struct sk_buff_head frames we
don't set MORE_DATA bit.

Proposed fix:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ce962d2..8eaa746 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1354,12 +1354,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
                         * Use MoreData flag to indicate whether there are
                         * more buffered frames for this STA
                         */
-                       if (!more_data)
-                               hdr->frame_control &=
-                                       cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-                       else
+                       if (more_data || !skb_queue_empty(&frames))
                                hdr->frame_control |=
                                        cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+                       else
+                               hdr->frame_control &=
+                                       cpu_to_le16(~IEEE80211_FCTL_MOREDATA);

                        if (ieee80211_is_data_qos(hdr->frame_control) ||
                            ieee80211_is_qos_nullfunc(hdr->frame_control))


BR
Janusz
