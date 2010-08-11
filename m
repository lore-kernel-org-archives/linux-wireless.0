Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22627 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0HKMNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 08:13:54 -0400
Subject: Re: [PATCH 3/5] mac80211: remove unused status flag checks
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1281527495.6475.160.camel@wimaxnb.nmp.nokia.com>
References: <20100810074637.034583799@sipsolutions.net>
	 <20100810074700.385206959@sipsolutions.net>
	 <1281527495.6475.160.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 15:12:45 +0300
Message-ID: <1281528765.6475.163.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-11 at 13:51 +0200, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> On Tue, 2010-08-10 at 09:46 +0200, ext Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The decryption code verifies whether or not
> > a given frame was decrypted and verified by
> > hardware. This is unnecessary, as the crypto
> > RX handler already does it long before the
> > decryption code is even invoked, so remove
> > that code to avoid confusion.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/wpa.c |   26 ++++++--------------------
> >  1 file changed, 6 insertions(+), 20 deletions(-)
> > 
> 
> This patch for some reason seems to break wl1271 WPA - association
> succeeds but encrypted data transfer fails.
> 
> I still don't know why, but I'm looking into it.
> 

It appears, that in function ieee80211_rx_h_decrypt we go here:

	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
		rx->key = stakey;
		/* Skip decryption if the frame is not protected. */
		if (!ieee80211_has_protected(hdr->frame_control))
			return RX_CONTINUE;

And here, as the frame is protected, we go out of the if, and end up in
tkip_decrypt, which with this patch no longer checks whether the frame
is already decrypted.

The frame then ends up dropped.


> -Juuso
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


