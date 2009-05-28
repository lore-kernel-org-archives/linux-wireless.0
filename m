Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:4943 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbZE1Isx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 04:48:53 -0400
Date: Thu, 28 May 2009 12:48:36 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	slapin@ossfans.org, maxim.osipov@siemens.com,
	dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Subject: Re: [PATCH 2/5] net: add IEEE 802.15.4 partial implementation
Message-ID: <20090528084836.GA6793@doriath.ww600.siemens.net>
References: <20090526112157.GA19976@doriath.ww600.siemens.net> <1243336988-20109-1-git-send-email-dbaryshkov@gmail.com> <1243336988-20109-2-git-send-email-dbaryshkov@gmail.com> <1243480131.16597.174.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243480131.16597.174.camel@deadeye>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 04:08:51AM +0100, Ben Hutchings wrote:
> On Tue, 2009-05-26 at 15:23 +0400, Dmitry Eremin-Solenikov wrote:
> [...]
> > diff --git a/include/net/ieee802154/af_ieee802154.h b/include/net/ieee802154/af_ieee802154.h
> > new file mode 100644
> > index 0000000..6eb7f51
> > --- /dev/null
> > +++ b/include/net/ieee802154/af_ieee802154.h
> [...]
> > +#ifdef __KERNEL__
> > +#include <linux/skbuff.h>
> > +#include <linux/netdevice.h>
> 
> The struct declarations would be sufficient.

Do you mean just:
struct sk_buff;
struct net_device;

> 
> > +extern struct proto ieee802154_raw_prot;
> > +extern struct proto ieee802154_dgram_prot;
> > +void ieee802154_raw_deliver(struct net_device *dev, struct sk_buff *skb);
> > +int ieee802154_dgram_deliver(struct net_device *dev, struct sk_buff *skb);
> > +#endif
> > +
> > +#endif

> > --- /dev/null
> > +++ b/include/net/ieee802154/const.h
> [...]
> > +/* Time related constants, in microseconds.
> > + *
> > + * The 1SYM_TIME values are shown how much time is needed to transmit one
> > + * symbol across media.
> > + * The callculation is following:
> > + * For a 2450 MHZ radio freq rate is 62,5 ksym/sec. A byte (8 bit) transfered
> > + * by low 4 bits in first symbol, high 4 bits in next symbol. So, to transmit
> > + * 1 byte in 2450Mhz freq 2 symbols are needed. Therefore we have 31,25 kbyte/sec
> > + * rate. 1 symbol transfered in 16*10^(-6) sec, or 16 microseconds.
> > + * For a 868Mhz and 915Mhz, 1 symbol is equal to 1 byte. So, we have 20kbyte/sec
> > + * and 40 kbyte/sec respectively. And 5*10^(-5) sec and 2,5*10(-5) sec,
> > + * or 50 and 25 microseconds respectively for 868Mhz and 915Mhz freq.
> > + */
> 
> This is so verbose as to be unhelpful.  Since the following constants
> only refer to symbol time, it should be sufficient to refer to the
> specified symbol rates.

const.h was inherited from the previous implementation of our stack.
I somehow missed that it needs a bit of polishing. A great bit.

> > +#endif /* IEEE802154_CONST_H */
> > diff --git a/include/net/ieee802154/crc.h b/include/net/ieee802154/crc.h
> > new file mode 100644
> > index 0000000..5b37218
> > --- /dev/null
> > +++ b/include/net/ieee802154/crc.h
> > @@ -0,0 +1,38 @@
> > +/*
> > + * based on crc-itu-t.c.
> > + * Basically it's CRC-ITU-T but with inverted bit numbering
> 
> This can probably be handled by crc_itu_t_bitreversed():
> 
> http://svn.debian.org/wsvn/kernel/dists/trunk/linux-2.6/debian/patches/features/all/lib-crcitut-bit-reversed.patch
> 
> (That patch hasn't gone anywhere yet as Greg K-H is dragging his heels
> over actually fixing his crap, but feel free to resubmit it as part of
> your own patch series.)

Fine, I'll use this patch.

> [...]
> > --- /dev/null
> > +++ b/include/net/ieee802154/nl.h
> [...]
> > +/* commands */
> > +/* REQ should be responded with CONF
> > + * and INDIC with RESP
> > + */
> > +enum {
> > +	__IEEE802154_COMMAND_INVALID,
> > +
> > +	IEEE802154_ASSOCIATE_REQ,
> > +	IEEE802154_ASSOCIATE_CONF,
> > +	IEEE802154_DISASSOCIATE_REQ,
> > +	IEEE802154_DISASSOCIATE_CONF,
> > +	IEEE802154_GET_REQ,
> > +	IEEE802154_GET_CONF,
> > +/* 	IEEE802154_GTS_REQ, */
> > +/* 	IEEE802154_GTS_CONF, */
> 
> Why are some of these commented out?  Since they're apparently exposed
> to user-space you can't insert them later.

Those are not implemented yet. We planned on appending them later to the
end of this enum. Most probably I'll just uncomment them and add simple
stubs returning an error instead.

> 
> [...]
> > --- /dev/null
> > +++ b/net/ieee802154/beacon.c
> [...]
> > +	/* TODO GTS */
> > +	gts = 0;
> > +
> > +	if (flags & IEEE802154_BEACON_FLAG_GTSPERMIT)
> > +		gts |= IEEE802154_BEACON_GTS_PERMIT;
> > +	memcpy(skb_put(skb, sizeof(gts)), &gts, sizeof(gts));
> > +
> > +	/* FIXME pending address */
> > +	addr16_cnt = 0;
> > +	addr64_cnt = 0;
> > +#if 0
> > +	/* need more thinking about this */
> > +	list_for_each_entry(l, al->list, list) {
> > +		struct ieee802154_addr *s = container_of(l, struct list_head, list);
> > +		if (s->addr_type == IEEE802154_ADDR_LONG)
> > +			addr16_cnt++;
> > +
> > +		if (s->addr_type == IEEE802154_ADDR_SHORT)
> > +			addr64_cnt++;
> > +	}
> > +#endif
> 
> This all looks very unfinished - as do several other sections with
> FIXME, #if 0, commented-out code...

As I said, the code is in early stage of development. 

> 
> [...]
> > +#define IEEE802154_FETCH_U64(skb, var)			\
> > +	do {						\
> > +		if (skb->len < IEEE802154_ADDR_LEN)	\
> 
> I see what you did there...

???

> > +			goto exit_error;		\
> > +		fetch_skb_u64(skb, &var);		\
> > +	} while (0)
> [...]


-- 
With best wishes
Dmitry

