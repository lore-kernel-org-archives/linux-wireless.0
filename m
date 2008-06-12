Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40816 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771AbYFLNqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 09:46:24 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 06:46:22 -0700
Date: Thu, 12 Jun 2008 06:46:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] First CRDA integration work
Message-ID: <20080612134615.GB28315@tesla> (sfid-20080612_154628_277180_A6F6DACB)
References: <20080611040402.GE17936@ruslug.rutgers.edu> <1213260106.19369.15.camel@johannes.berg> <20080612131154.GA28315@tesla> <1213276778.3936.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1213276778.3936.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 06:19:38AM -0700, Johannes Berg wrote:
> 
> > > > + * @NL80211_CMD_GET_REG: Get current regulatory domain, this is a query 
> > > > + * 	to the kernel wireless core, the wireless core returns currently
> > > > + * 	set alpha2 by %NL80211_ATTR_REG_ALPHA2,.
> > > 
> > > Please specify what command it comes in, probably _NEW_REG that you
> > > haven't added.
> > 
> > We can probably not even add this, what do you think?
> 
> Well I think that some userspace programs like network manager want to
> get a notification when for whatever reason the regdomain changes, and
> they want to be able to query which one is currently set, and things
> should be changeable. So you need at least three messages, NEW, GET,
> SET, no?

Then I see us requiring:

SET and GET, but not NEW. If only need to "set" "one" regulatory domain,
not create one and then set one. What do you think?

> > > >  CRDA replies by sending a regulatory domain
> > > > + * 	structure which consists of %NL80211_ATTR_REG_ALPHA set to our current alpha2
> > > > + * 	if it found a match.
> > > 
> > > Why set the alpha2 again? I thought the kernel queried for that?
> > 
> > This is in case we wanted to support letting userspace query the kernel
> > what alpha2 it has set. I'm OK with not supporting this though but it
> > seemed it may have come in handy, hopefully not for abuse for other
> > things.
> 
> Yeah true, we may want to be able to force a certain regdomain.

Huh? I was talking about querying from userspace to the kernel for the
currently set alpha2, in case userspace may want to know what the kernel
last used to ask CRDA for a regdomain.

How did this change to being able to fore a certain regdomain?

Anyway, the only valid case where I see us needing to set a regdomain
manaullay is if an access point doesn't have an 802.11d country
information element. Which BTW -- soon we'll have to decide how we want
to implement, as we could either respect the IE with the channels passed
or just ask CRDA for the alpha2 given.

> > > >  and a regulatory rule. The regulatory
> > > > + * 	rule consists of set of frequency ranges given by
> > > > + * 	%NL80211_ATTR_REG_RULE_FREQ_[START|END] with an attached power rule given
> > > > + * 	by %NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
> > > > + * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP. Each regulatory rule also has 
> > > > + * 	an attached %NL80211_ATTR_REG_RULE_FLAGS.
> > > 
> > > How are these attributes used? Nested in some array?
> > 
> > I wasn't sure yet, I wanted your feedback, but you are giving me this
> > through IRC :)
> 
> Well, as I said, look at how wiphy band info with frequencies works.
> That's how you need to do it with netlink attributes.

OK.

> > > > + * @NL80211_ATTR_REG_RULE_FREQ_START: starting frequencry for the regulatory
> > > > + * 	rule in KHz. This is not a center of frequency but an actual regulatory
> > >                                             ^^ remove
> > > > + * 	band edge.
> > > > + * @NL80211_ATTR_REG_RULE_FREQ_END: ending frequency for the regulatory rule
> > > > + * 	in KHz. This is not a center a frequency but an actual regulatory
> > >                                        ^^ remove
> > > > + * 	band edge.
> > > > + * @NL80211_ATTR_REG_RULE_FREQ_MAX_BW: maximum allowed bandwidth for this
> > > > + * 	frequency range, in KHz.
> > > > + * @NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN: the maximum allowed antenna gain
> > > > + * 	for a given frequency range. The value is in mBi (100 * dBi).
> > > 
> > > Can be left out.
> > 
> > OK.
> 
> I mean, you have to add a note that it can be left out if it's not
> specified in the db.

N/A think right. Yeah sure, I'll update it. Which reminds me I have to
hanlde that in reg.c, I didn't yet.

> > > > @@ -9,137 +10,93 @@
> > > >   */
> > > >  
> > > >  /*
> > > > - * This regulatory domain control implementation is highly incomplete, it
> > > > - * only exists for the purpose of not regressing mac80211.
> > > > - *
> > > > - * For now, drivers can restrict the set of allowed channels by either
> > > > - * not registering those channels or setting the IEEE80211_CHAN_DISABLED
> > > > - * flag; that flag will only be *set* by this code, never *cleared.
> > > > - *
> > > >   * The usual implementation is for a driver to read a device EEPROM to
> > > >   * determine which regulatory domain it should be operating under, then
> > > >   * looking up the allowable channels in a driver-local table and finally
> > > >   * registering those channels in the wiphy structure.
> > > >   *
> > > > - * Alternatively, drivers that trust the regulatory domain control here
> > > > - * will register a complete set of capabilities and the control code
> > > > - * will restrict the set by setting the IEEE80211_CHAN_* flags.
> > > 
> > > I think you shouldn't remove that but just rewrite it to make the driver
> > > trust crda instead of this code.
> > 
> > The EEPROM lets us get a list of supported channels for a product a
> > customer (a vendor's customer, not a regular customer) decided to support.
> > If we trust CRDA we then could potentially trust a different set of channels
> > which the customer may not have tested his products on. They probably
> > will work, but the safer approach is to support only the intended
> > channels.
> > 
> > We can then trust CRDA only to disable channels, not to *enable*.
> 
> That's already covered by the paragraph above it though, "[t]he usual
> implementation is for a driver [...]". Hence, you want to rewrite the
> second paragraph as I mentioned :)

OK.

  Luis
