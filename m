Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:36865 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbXJ3Q4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 12:56:40 -0400
Received: by py-out-1112.google.com with SMTP id u77so3656086pyb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 09:56:39 -0700 (PDT)
Message-ID: <43e72e890710300956w55740788mc70c63c4bace6d28@mail.gmail.com> (sfid-20071030_165644_794107_83115D0D)
Date: Tue, 30 Oct 2007 12:56:39 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RTS wrong hdrlen computation?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perhaps an oversight, gotta go so can't keep looking, perhaps others will know

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 27203f1..7f7da9c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -188,8 +188,11 @@ int ieee80211_get_hdrlen(u16 fc)
                 *   subtype mask:   0b0000000011110000 (0x00F0)
                 *   ACK subtype:    0b0000000011010000 (0x00D0)
                 *   CTS subtype:    0b0000000011000000 (0x00C0)
+                *   RTS subtype:    0b0000000010110000 (0x00B0) **
                 *   bits that matter:         ^^^      (0x00E0)
                 *   value of those: 0b0000000011000000 (0x00C0)
+                *
+                *   Note: this doesn't work for RTS...
                 */
                if ((fc & 0xE0) == 0xC0)
                        hdrlen = 10;
