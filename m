Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37524 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbXHQOQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 10:16:43 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1187308221.23489.91.camel@johannes.berg>
References: <1187151162.3253.18.camel@thinkpad>
	 <1187308221.23489.91.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 10:16:40 -0400
Message-Id: <1187360200.4417.32.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-17 at 01:50 +0200, Johannes Berg wrote:
> On Wed, 2007-08-15 at 00:12 -0400, Volker Braun wrote:
> > 1) Instead of hacking around ieee80211_privacy_mismatch, remove it
> > completely. It serves no useful purpose.
> The purpose seems to be to avoid associating to BSSes that have privacy
> enabled when we don't have any keys nor a tool told us that it's ok

NetworkManager can do that for you, no need to duplicate that in the
driver where you can't give any useful feedback to the user. Maybe you
want to test whether your AP _really_ discards unencrypted data? 

> > -	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
> > +	if (rx->key && rx->u.rx.ra_match) {
> 
> That's just an optimisation, right? (If we have a key, the frame was
> encrypted)

Yes.

> > -	if (is_broadcast_ether_addr(sta_addr)) {
> > +	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
> > +		printk(KERN_DEBUG "%s: set_encrypt - invalid idx = %d\n",
> > +		       dev->name, idx);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (is_multicast_ether_addr(sta_addr)) {
> 
> I still haven't understood why you changed from broadcast to multicast
> here. Nor why you moved the key index check outside the check, if it's a
> not a group key then the key index is irrelevant.

It should be broadcast, you are right.

The key index is saved later on in key->keyidx. So I wanted to be on the
safe side and make sure that a legal value is stored there.

> So wpa_supplicant is actually trying to set a pairwise key with a key
> index that isn't zero? That's really weird and definitely against the
> rules. Is that somehow required? Shouldn't the AP be able to live with
> you setting the key index to zero? Could you try that by forcing the
> index to zero in this case?
> 
> Actually, maybe this is some weird Cisco rule-bending as you said, but
> then I'd rather suspect that it's because of interaction with pre-shared
> WEP keys rather than TKIP. In any case, it seems acceptable to remove
> this restriction even if we then violate the standard.

First of all, we violate the standard by looking at the keyindex in case
of a pairwise key. Now granted, Cisco also violates it, but in a way
that is never visible to standards-compliant STAs. We must set the
keyindex to zero on outgoing pairwise key-encrypted data, but that is
kind of irrelevant since the AP is forced to ignore that key index on
receive.



