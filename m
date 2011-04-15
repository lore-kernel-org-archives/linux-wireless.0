Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59729 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1DOIsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 04:48:02 -0400
Date: Fri, 15 Apr 2011 14:10:06 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
Message-ID: <20110415084005.GC11576@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302850527.3572.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2011 at 11:55:27PM -0700, Johannes Berg wrote:
> On Fri, 2011-04-15 at 10:23 +0530, Yogesh Ashok Powar wrote:
> > When drivers use HW crypto, reservation for tail room is not needed for
> > any crypto suite. Do not reserve tail room in such cases, this helps in
> > optimizing the transmit path.
> > 
> > Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> NACK.
> 
> >  	/*
> > -	 * This could be optimised, devices that do full hardware
> > -	 * crypto (including TKIP MMIC) need no tailroom... But we
> > -	 * have no drivers for such devices currently.
> > +	 * When full HW crypto is being used by the driver,
> > +	 * no tail room is needed. Hence do not ask for tail room
> > +	 * in such cases. This will avoid copying the skb in
> > +	 * pskb_expand_head.
> >  	 */
> > -	if (may_encrypt) {
> > +	if (!(local->hw.flags & IEEE80211_HW_CRYPTO_ENABLED) && may_encrypt) {
> 
> There's no need for this as a HW flag, and in its present form it is
> EXTREMELY likely to be misused completely. And realise that even drivers
> that implement HW crypto may need the extra tailroom for TKIP MMIC, so
> your description of the flag is completely bogus.
> 
> You can implement the performance feature, but only by keeping track of
> which keys need tailroom and skipping the code here once they are all
> programmed into the device which will handle them including MMIC.

Thanks for the information. 

Just for my understanding before I attempt patch set V2, please let me
know if the approach given below makes sense.

Define a flag say IEEE80211_CRYPTO_NO_TAILROOM_NEEDED per key. Drivers
need to set this flag in set_key handler for the keys which requires no
extra tailroom. Then Skip the code which expands the skb iff
IEEE80211_CRYPTO_NO_TAILROOM_NEEDED is set and the key is programmed
into the hardware (checking KEY_FLAG_UPLOADED_TO_HARDWARE).

Thanks
Yogesh 
> 
> johannes
> 
