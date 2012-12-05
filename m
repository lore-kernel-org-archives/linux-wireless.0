Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53042 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2LEFih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 00:38:37 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so7525352ieb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 21:38:36 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 5 Dec 2012 11:08:16 +0530
Message-ID: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com> (sfid-20121205_063853_141170_E3643839)
Subject: [PATCH] mac80211: Moving Zero Len subframe reporting under driver
 capability check.
To: johannes@sipsolutions.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zero Len subframe makes sense only when driver supports the reporting
of zero len subframes.

Signed-off-by: Chaitanya T K<chaitanya.mgit@gmail.com>
---

 net/mac80211/rx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index db343fa..3f1443b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -281,10 +281,11 @@ ieee80211_add_rx_radiotap_header(struct
ieee80211_local *local,
                        cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
                put_unaligned_le32(status->ampdu_reference, pos);
                pos += 4;
-               if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN)
+               if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN) {
                        flags |= IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN;
-               if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
-                       flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
+                        if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
+                             flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
+                }
                if (status->flag & RX_FLAG_AMPDU_LAST_KNOWN)
                        flags |= IEEE80211_RADIOTAP_AMPDU_LAST_KNOWN;
                if (status->flag & RX_FLAG_AMPDU_IS_LAST)
