Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:36838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZFCM2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 08:28:01 -0400
Date: Wed, 3 Jun 2009 16:27:44 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	sfr@canb.auug.org.au, slapin@ossfans.org
Subject: Re: [PATCH 4/6] net: add NL802154 interface for configuration of
	802.15.4 devices
Message-ID: <20090603122744.GC20508@doriath.ww600.siemens.net>
References: <1244021629-18409-4-git-send-email-dbaryshkov@gmail.com> <1244021629-18409-5-git-send-email-dbaryshkov@gmail.com> <1244021964.10665.5.camel@johannes.local> <20090603.030911.162861804.davem@davemloft.net> <20090603105256.GB20508@doriath.ww600.siemens.net> <1244027110.1693.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244027110.1693.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2009 at 01:05:10PM +0200, Johannes Berg wrote:
> On Wed, 2009-06-03 at 14:52 +0400, Dmitry Eremin-Solenikov wrote:
> > +#define IEEE802154_ATTR_MAX (__IEEE802154_ATTR_MAX - 1)
> > +#define NLA_HW_ADDR	NLA_U64
> > +#define NLA_GET_HW_ADDR(attr, addr) do { u64 _temp = nla_get_u64(attr); memcpy(addr, &_temp, 8); } while (0)
> > +#define NLA_PUT_HW_ADDR(msg, attr, addr) do { u64 _temp; memcpy(&_temp, addr, 8); NLA_PUT_U64(msg, attr, _temp); } while (0)
> 
> I really don't like this namespace pollution.
> 
> > +#ifdef IEEE802154_NL_WANT_POLICY
> > +static struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
> 
> Ho humm. This shouldn't be in a header file. Not even with an #ifdef
> that exactly one C file then sets.
> 
> > +	[IEEE802154_ATTR_DURATION] = { .type = NLA_U8, },
> > +#ifdef __KERNEL__
> > +	[IEEE802154_ATTR_ED_LIST] = { .len = 27 },
> > +#else
> 
> Ick.

We'd like to share the policy declaration between kernel and user space
as a single file. I'll move this from header to the source file though.

> 
> > +/* commands */
> > +/* REQ should be responded with CONF
> > + * and INDIC with RESP
> > + */
> > +enum {
> 
> kernel-doc explaining the commands would be immensely helpful.

What explanations whould you like to see? These commands are described
in the IEEE 802.15.4 standard.

> 
> 
> > +	IEEE802154_GTS_REQ, /* Not supported yet */
> > +	IEEE802154_GTS_INDIC, /* Not supported yet */
> > +	IEEE802154_GTS_CONF, /* Not supported yet */
> > +	IEEE802154_RX_ENABLE_REQ, /* Not supported yet */
> > +	IEEE802154_RX_ENABLE_CONF, /* Not supported yet */
> 
> Just leave it out then. You're fixing ABI here.

Thas is the desired thing: the ABI is modelled after the subroutines in
IEEE 802.15.4 standard. So we'd like to fix the numbers for the commands
from the start.

> > +#ifdef __KERNEL__
> > +struct net_device;
> > +
> > +int ieee802154_nl_assoc_indic(struct net_device *dev, struct ieee802154_addr *addr, u8 cap);
> > +int ieee802154_nl_assoc_confirm(struct net_device *dev, u16 short_addr, u8 status);
> > +int ieee802154_nl_disassoc_indic(struct net_device *dev, struct ieee802154_addr *addr, u8 reason);
> > +int ieee802154_nl_disassoc_confirm(struct net_device *dev, u8 status);
> > +int ieee802154_nl_scan_confirm(struct net_device *dev, u8 status, u8 scan_type, u32 unscanned,
> > +		u8 *edl/*, struct list_head *pan_desc_list */);
> > +int ieee802154_nl_beacon_indic(struct net_device *dev, u16 panid, u16 coord_addr); /* TODO */
> > +#endif
> 
> Why not just use two header files, one in net/ and one in linux/?

What would you suggest to put into the linux/ header and what in the
net/ one?

> > +static int ieee802154_nl_put_failure(struct sk_buff *msg)
> > +{
> > +	void *hdr = genlmsg_data(NLMSG_DATA(msg->data)); /* XXX: nlh is right at the start of msg */
> > +	genlmsg_cancel(msg, hdr);
> > +	nlmsg_free(msg);
> > +	return -ENOBUFS;
> > +}
> 
> This seems weird.

Why?

> > +static int ieee802154_associate_req(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	struct net_device *dev;
> > +	struct ieee802154_addr addr;
> > +	int ret = -EINVAL;
> > +
> > +	if (!info->attrs[IEEE802154_ATTR_CHANNEL]
> > +	 || !info->attrs[IEEE802154_ATTR_COORD_PAN_ID]
> > +	 || (!info->attrs[IEEE802154_ATTR_COORD_HW_ADDR] && !info->attrs[IEEE802154_ATTR_COORD_SHORT_ADDR])
> > +	 || !info->attrs[IEEE802154_ATTR_CAPABILITY])
> > +		return -EINVAL;
> 
> That's some odd coding style.

Could you please elaborate this? What seems odd to you?

-- 
With best wishes
Dmitry

