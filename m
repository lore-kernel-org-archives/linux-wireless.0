Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33360 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbcHAJhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 05:37:50 -0400
Message-ID: <1470044267.3389.18.camel@sipsolutions.net> (sfid-20160801_113811_607164_8AC4B3B5)
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver
 for Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
	kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Avinash Patil <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	Sergei Maksimenko <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>
Date: Mon, 01 Aug 2016 11:37:47 +0200
In-Reply-To: <fd6ee9cd-71fd-352a-e1cd-61d36b296057@quantenna.com> (sfid-20160711_205908_991096_A819A9AD)
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1466511726.3170.33.camel@sipsolutions.net>
	 <fd6ee9cd-71fd-352a-e1cd-61d36b296057@quantenna.com>
	 (sfid-20160711_205908_991096_A819A9AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 
> > > +	/* bus private data */
> > > +	char bus_priv[0];
> > You might want to - for future proofing - add some aligned()
> > attribute.
> > Otherwise, if struct mutex doesn't have a size that's a multiple of
> > the
> > pointer size, fields in here will not be aligned right.
> 
> Right, thanks for pointing this out. Probably even better approach
> here would be to take an object-oriented approach and make "bus" a
> base structure with pcie_bus an inheriting structure.

I think both ways to do composition are fine. It depends more on how
your other code is structured. I think in mac80211/cfg80211 we do both,
depending on where/how the allocation is done.

> > > +#define QLINK_HT_MCS_MASK_LEN	10
> > > +#define QLINK_ETH_ALEN		6
> > > +#define QLINK_MAX_SSID_LEN	32
> > These seem a bit strange? Why bother? They are standard values.
> > (not entirely sure what the MCS_MASK_LEN is used for though)
> 
> The idea was to make protocol definition an independent entity, which
> does not depend on actual values which happened to be used in current
> kernel. And so that we can be sure that both sides of protocol 
> communication entities use the same length values.
> 
> We actually had discussions regarding this locally too: it was not
> clear whether we should use existing Linux definitions for standard
> things like MAC length, 802.11 header fields, IEs definitions etc. It
> does make a lot of sense to think that they will never change and can
> not be different on opposite sides of protocol, but we went with
> approach to define everything manually.

Well, I can kinda see the beginning of that argument "we should own
everything to make sure", but it doesn't really work that way. The max
SSID that's passed in, or the ETH_ALEN that's there - you're always
going to rely on the kernel's definition of this in other ways, say
when you alloc_ether_dev() [or whatever it's called], etc.

The end result is that you're never going to be able to change one of
the two and expect the combined system to still work. As a consequence,
I don't see any point in even trying to separate them.

> > > +struct qlink_vht_cap {

> Ok, that makes sense of course. Will discuss this locally.

Same argument applies here too, btw, and you might even have to
translate between this version and the one coming from say cfg80211 -
where the ieee80211.h one is used - and then you can realistically only
do a memcpy(), so you rely on them being the same anyway.

> > > +	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg-
> > > > crypto));
> > This makes no sense at all - you have to convert the format of this
> > somehow to make it work - at least endianness has to be fixed, even
> > if
> > you copied all of the cfg80211 struct.
> 
> In this particular place we're making a local copy of cfg80211 struct
> to  local data structure (per each virtual interface). Conversion
> before  sending to another side is done in qtnf_cmd_send_connect(),
> it is converted into struct qlink_auth_encr.

Ok. Somehow I thought this (bss_cfg) was sent to the device.


johannes
