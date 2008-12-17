Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYLQMPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 07:15:09 -0500
Subject: Re: [PATCH] ath9k: Key cache allocation for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081217120559.GB19453@jm.kir.nu>
References: <20081217113217.GB18060@jm.kir.nu>
	 <1229513411.4566.0.camel@localhost>  <20081217120559.GB19453@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 13:00:13 +0100
Message-Id: <1229515213.5175.0.camel@localhost> (sfid-20081217_131514_038449_3C3D8CB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 14:05 +0200, Jouni Malinen wrote:
> On Wed, Dec 17, 2008 at 12:30:11PM +0100, Johannes Berg wrote:
> > On Wed, 2008-12-17 at 13:32 +0200, Jouni Malinen wrote:
> > > +		if (vif->type != NL80211_IFTYPE_AP) {
> > > +			/* Only keyidx 0 should be used with unicast key, but
> > > +			 * allow this for client mode for now. */
> > > +			idx = key->keyidx;
> > 
> > Hey, good point, should we make the check in mac80211 stricter as well?
> > I know we accept non-zero pairwise key idx for some broken pairwise WEP
> > implementations, but that's only relevant for STA as you note.
> 
> Doing that in non-Managed modes in mac80211 sounds reasonable. I don't
> see any point in making it easier for people to make APs that do such a
> silly thing with WEP ;-). I did not look at more details here from the
> mac80211 view point, I just knew it would break the key cache changes I
> was working on for ath9k.

Right. This is what I had in mind:

--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -76,9 +76,12 @@ static int ieee80211_set_encryption(struct ieee80211_sub_if_data *sdata, u8 *sta
 			 * According to the standard, the key index of a
 			 * pairwise key must be zero. However, some AP are
 			 * broken when it comes to WEP key indices, so we
-			 * work around this.
+			 * work around this by allowing to set such keys
+			 * on STA mode interfaces.
 			 */
-			if (idx != 0 && alg != ALG_WEP) {
+			if (idx != 0 &&
+			    (sdata->vif.type != NL80211_IF_TYPE_STATION ||
+			     alg != ALG_WEP))) {
 				ieee80211_key_free(key);
 				err = -EINVAL;
 				goto out_unlock;


