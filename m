Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33996 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1KDPEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 11:04:35 -0400
Received: by qabj40 with SMTP id j40so2155599qab.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 08:04:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Nov 2011 16:04:35 +0100
Message-ID: <CAFED-jnG8+4U49scyEu8Yd7=WXFKGcrqcWw1EtTtaiVsQpwcdQ@mail.gmail.com> (sfid-20111104_160439_090403_B0BC3F8B)
Subject: mac80211: UAPSD - first release HW buffered frames next also check
 mac80211 buffered frames
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Seems currently we have implementation.

if(!driver_release_tids) {
  ...
} else {
  ...
}

Shouldn't we first release HW buffered frames and next check also SW
buffered frames?

Please check patch:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8eaa746..1303bfd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1328,7 +1328,33 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
                return;
        }

-       if (!driver_release_tids) {
+       /* First release driver buffered frames */
+       if (driver_release_tids){
+               /*
+                * We need to release a frame that is buffered somewhere in the
+                * driver ... it'll have to handle that.
+                * Note that, as per the comment above, it'll also have to see
+                * if there is more than just one frame on the specific TID that
+                * we're releasing from, and it needs to set the more-data bit
+                * accordingly if we tell it that there's no more data. If we do
+                * tell it there's more data, then of course the more-data bit
+                * needs to be set anyway.
+                */
+               drv_release_buffered_frames(local, sta, driver_release_tids,
+                                           n_frames, reason, more_data);
+
+               /*
+                * Note that we don't recalculate the TIM bit here as it would
+                * most likely have no effect at all unless the driver told us
+                * that the TID became empty before returning here from the
+                * release function.
+                * Either way, however, when the driver tells us that the TID
+                * became empty we'll do the TIM recalculation.
+                */
+       }
+
+       /* Now check SW buffered frames */
+       /* This if (found) seems to be not required in final patch */
+       if (found) {
                struct sk_buff_head pending;
                struct sk_buff *skb;
                int num = 0;
@@ -1387,28 +1413,6 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
                ieee80211_add_pending_skbs(local, &pending);

                sta_info_recalc_tim(sta);
-       } else {
-               /*
-                * We need to release a frame that is buffered somewhere in the
-                * driver ... it'll have to handle that.
-                * Note that, as per the comment above, it'll also have to see
-                * if there is more than just one frame on the specific TID that
-                * we're releasing from, and it needs to set the more-data bit
-                * accordingly if we tell it that there's no more data. If we do
-                * tell it there's more data, then of course the more-data bit
-                * needs to be set anyway.
-                */
-               drv_release_buffered_frames(local, sta, driver_release_tids,
-                                           n_frames, reason, more_data);
-

BR
Janusz
