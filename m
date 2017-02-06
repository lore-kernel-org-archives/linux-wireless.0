Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35988 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbdBFNxM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 08:53:12 -0500
Received: by mail-lf0-f67.google.com with SMTP id h65so4016078lfi.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 05:53:12 -0800 (PST)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] Print text for disassociation reason.
Date: Mon, 6 Feb 2017 14:53:08 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201702061453.08816.a.miskiewicz@gmail.com> (sfid-20170206_145427_070606_3E88921A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi.

Don't know why it wasn't printed there with ieee80211_get_reason_code_strin=
g in first
place. Works for me:

kernel: wlan0: disassociated from 04:b0:20:33:ff:1f (Reason: 34=3DDISASSOC_=
LOW_ACK)

ps. can't send patch in normal way due to postmaster@vger weirdness, so ins=
erted
below

=46rom c9b55bb44fe0b902f376a41fa930c9a67a438511 Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Arkadiusz=3D20Mi=3DC5=3D9Bkiewicz?=3D <arekm@maven.pl>
Date: Mon, 6 Feb 2017 14:45:15 +0100
Subject: [PATCH] Print text for disassociation reason.
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

When disassociation happens only numeric reason is printed
in ieee80211_rx_mgmt_disassoc(). Add text variant, too.

Signed-off-by: Arkadiusz Mi=C5=9Bkiewicz <arekm@maven.pl>
=2D--
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 098ce9b179ee..fcf8d0aa66ec 100644
=2D-- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2801,8 +2801,9 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee802=
11_sub_if_data *sdata,
=20
 	reason_code =3D le16_to_cpu(mgmt->u.disassoc.reason_code);
=20
=2D	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
=2D		   mgmt->sa, reason_code);
+	sdata_info(sdata, "disassociated from %pM (Reason: %u=3D%s)\n",
+		   mgmt->sa, reason_code,
+		   ieee80211_get_reason_code_string(reason_code));
=20
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
=20
=2D-=20
2.11.0


=2D-=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )
