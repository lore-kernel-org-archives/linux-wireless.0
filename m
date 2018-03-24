Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo69.mail-out.ovh.net ([46.105.50.32]:33193 "EHLO
        7.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeCXLHD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 07:07:03 -0400
Received: from player687.ha.ovh.net (unknown [10.109.120.203])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id D11609966
        for <linux-wireless@vger.kernel.org>; Sat, 24 Mar 2018 11:29:46 +0100 (CET)
From: Alexander Wetzel <alexander.wetzel@web.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander.wetzel@web.de>
Subject: [PATCH] mac80211: Fix wlan freezes under load at rekey
Date: Sat, 24 Mar 2018 11:29:21 +0100
Message-Id: <20180324102921.9814-1-alexander.wetzel@web.de> (sfid-20180324_120707_602854_78A3B9EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying a pairwise key with encryption offload and only keyid 0 has two
potential races which can freeze the wlan conection till rekeyed again:

 1) For incomming packets:
    If the local STA installs the key prior to the remote STA we still
    have the old key active in the hardware for a short time after
    mac80211 switched to the new key.
    The card can still hand over packets decoded with the old key to
    mac80211, bumping the new PN (IV) value to an incorrect high number and
    tricking the local replay detection to drop all packets really sent
    with the new key.

 2) For outgoing packets:
    If mac80211 is providing the PN (IV) and hands over the cleartext
    packets for encryption to the hardware immediately prior to a key
    change the driver/card may process the queued packets after
    switching to the new key.
    This will immediatelly bump the PN (IV) value on the remote STA to
    an incorrect high number, also freezing the connection.

Both issues can be prevented by deleting the key from the hardware prior
to switching to the new key in mac80211, falling back to software
encryption/decryption till the switch to the new key is completed.

Signed-off-by: Alexander Wetzel <alexander.wetzel@web.de>
---
 net/mac80211/key.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index aee05ec3f7ea..266ea0b507e7 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -332,10 +332,15 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
-	if (old)
+	if (old) {
 		idx = old->conf.keyidx;
-	else
+		/* Make sure the card can't encrypt/decrypt packets with
+		 * the old key prior to switching to new key in mac80211.
+		 */
+		ieee80211_key_disable_hw_accel(old);
+	} else {
 		idx = new->conf.keyidx;
+	}
 
 	if (sta) {
 		if (pairwise) {
-- 
2.16.2
