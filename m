Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f184.google.com ([209.85.212.184]:36090 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbZJXSzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 14:55:06 -0400
Received: by vws14 with SMTP id 14so651484vws.33
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2009 11:55:10 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Oct 2009 20:55:09 +0200
Message-ID: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com>
Subject: [PATCH] mac80211: fix for incorrect sequence number on hostapd
	injected frames
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hostapd injects a frame, e.g. an authentication or association
response, mac80211 looks for a suitable access point virtual interface
to associate the frame with based on its source address. This makes it
possible e.g. to correctly assign sequence numbers to the frames.

A small typo in the ethernet address comparison statement caused a
failure to find a suitable ap interface. Sequence numbers on such
frames where therefore left unassigned causing some clients
(especially windows-based 11b/g clients) to reject them and fail to
authenticate or associate with the access point. This patch fixes the
typo in the address comparison statement.

Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index db4bda6..eaa4118 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1445,7 +1445,7 @@ static void ieee80211_xmit(struct
ieee80211_sub_if_data *sdata,
                                if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
                                        continue;
                                if (compare_ether_addr(tmp_sdata->dev->dev_addr,
-                                                      hdr->addr2)) {
+                                                      hdr->addr2) == 0) {
                                        dev_hold(tmp_sdata->dev);
                                        dev_put(sdata->dev);
                                        sdata = tmp_sdata;
