Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0HKMjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 08:39:21 -0400
Subject: Re: [PATCH 3/5] mac80211: remove unused status flag checks
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1281528765.6475.163.camel@wimaxnb.nmp.nokia.com>
References: <20100810074637.034583799@sipsolutions.net>
	 <20100810074700.385206959@sipsolutions.net>
	 <1281527495.6475.160.camel@wimaxnb.nmp.nokia.com>
	 <1281528765.6475.163.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 14:39:16 +0200
Message-ID: <1281530356.3674.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-11 at 15:12 +0300, Juuso Oikarinen wrote:

> > > The decryption code verifies whether or not
> > > a given frame was decrypted and verified by
> > > hardware. This is unnecessary, as the crypto
> > > RX handler already does it long before the
> > > decryption code is even invoked, so remove
> > > that code to avoid confusion.
> > > 
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > ---
> > >  net/mac80211/wpa.c |   26 ++++++--------------------
> > >  1 file changed, 6 insertions(+), 20 deletions(-)
> > > 
> > 
> > This patch for some reason seems to break wl1271 WPA - association
> > succeeds but encrypted data transfer fails.
> > 
> > I still don't know why, but I'm looking into it.
> > 
> 
> It appears, that in function ieee80211_rx_h_decrypt we go here:
> 
> 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
> 		rx->key = stakey;
> 		/* Skip decryption if the frame is not protected. */
> 		if (!ieee80211_has_protected(hdr->frame_control))
> 			return RX_CONTINUE;
> 
> And here, as the frame is protected, we go out of the if, and end up in
> tkip_decrypt, which with this patch no longer checks whether the frame
> is already decrypted.
> 
> The frame then ends up dropped.

Err, you're right, sorry about that. There are too many paths here. How
about this patch?

johannes

--- wireless-testing.orig/net/mac80211/rx.c	2010-08-11 14:37:13.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-08-11 14:38:13.000000000 +0200
@@ -873,6 +873,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
 		rx->key = stakey;
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
 		/* Skip decryption if the frame is not protected. */
 		if (!ieee80211_has_protected(fc))
 			return RX_CONTINUE;


