Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYLJFEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 00:04:10 -0500
Message-ID: <493F4DC5.9090801@trash.net> (sfid-20081210_060414_951498_875D97D4)
Date: Wed, 10 Dec 2008 06:04:05 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jiri Slaby <jirislaby@gmail.com>, mickflemm@gmail.com,
	mcgrof@gmail.com, me@bobcopeland.com
Subject: [RFC]: atk5k: fix FCS corruption for ACKs
Content-Type: multipart/mixed;
 boundary="------------050603010209020501060100"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050603010209020501060100
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

When running a monitor interface with ath5k, the FCS of ACK
frames is two bytes short. The reason is that unlike the
payload, the FCS doesn't seem to aligned to a 4 byte boundary
by the chip, the attempt to remove the padding corrupts it.

This patch checks whether there actually is any payload after
the header (besides the FCS) before removing the padding.

This might not be fully correct or not handle other cases where
this can occur, but it doesn't seem too hackish and fixes the
problem for me :)

http://bugzilla.kernel.org/show_bug.cgi?id=12101


--------------050603010209020501060100
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 8c1d598338077d397aed25fe4840e4d4b51ba79c
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Dec 9 21:52:00 2008 +0100

    atk5k: fix FCS corruption for ACKs
    
    The trailing FCS value is not aliged when no payload is present. Don't try
    to remove padding to avoid corrupting it.

    Kernel Bugzilla #12101
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d9e1980..940c724 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1752,7 +1752,7 @@ accept:
 		 * not multiples of 4 - remove it
 		 */
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		if (hdrlen & 3) {
+		if (hdrlen & 3 && hdrlen != rs.rs_datalen - FCS_LEN) {
 			pad = hdrlen % 4;
 			memmove(skb->data + pad, skb->data, hdrlen);
 			skb_pull(skb, pad);

--------------050603010209020501060100--
