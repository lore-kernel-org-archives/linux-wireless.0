Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:56326 "EHLO
        smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdARKr2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 05:47:28 -0500
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Adrian Chadd'" <adrian@freebsd.org>,
        "'ath9k-devel'" <ath9k-devel@venema.h4ckr.net>,
        <linux-wireless@vger.kernel.org>
References: <CAJ-Vmo=_apPFE1LQmXj6pn9g1c0bvzAS-gk86Hi7-CX+KuZtrw@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=_apPFE1LQmXj6pn9g1c0bvzAS-gk86Hi7-CX+KuZtrw@mail.gmail.com>
Subject: RE: ath9k/ath10k DFS testing / certification
Date: Wed, 18 Jan 2017 11:26:10 +0100
Message-ID: <009701d27175$499fafc0$dcdf0f40$@acksys.fr> (sfid-20170118_114758_694907_8A4E9F77)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

Also, about ath9k:

I don't know if it's relevant to you, but we had the same problem of
NO_IR/RADAR mismatch in ath9k.
We fixed this in mac80211 layer at that time. Here is the patch. We didn't
send it upstream since
We have no experience with other chipsets, and we didn't know whether it
would be generic enough.

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -598,7 +598,7 @@ static int __ieee80211_start_scan(struct
 		ieee80211_hw_config(local, 0);
 
 		if ((req->channels[0]->flags &
-		     IEEE80211_CHAN_NO_IR) ||
+		     (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)) ||
 		    !req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
@@ -646,7 +646,7 @@ ieee80211_scan_get_channel_time(struct i
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR)
+	if (chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR))
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return local->scan_req->probe_delay_ticks +
local->scan_req->max_channel_time_ticks;
 }
@@ -810,7 +810,7 @@ static void ieee80211_scan_state_set_cha
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids) {
+	if (chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR) ||
!scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
 		return;
--
Diff -u

> -----Message d'origine-----
> De : ath10k [mailto:ath10k-bounces@lists.infradead.org] De la part de
> Adrian Chadd
> Envoyé : dimanche 15 janvier 2017 22:17
> À : ath9k-devel; ath10k@lists.infradead.org
> Objet : ath9k/ath10k DFS testing / certification
> 
> hiya,
> 
> I'm working on a set of things that will involve DFS certification for
> ath9k/ath10k. Initially it'll be for FCC but I'll branch out to the other
> regions shortly afterwards.
> 
> I'd love to hear from anyone else who has done this and what their
> challenges were, including whether they have any local patches / tools
> that haven't yet been upstreamed.
> 
> Thanks!
> 
> 
> -adrian
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
