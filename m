Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57487 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYABPWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 10:22:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Strange mac80211 oops
Date: Wed, 2 Jan 2008 16:21:26 +0100
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200712242237.28913.mb@bu3sch.de> <200712291724.23726.mb@bu3sch.de> <1199263731.4172.66.camel@johannes.berg>
In-Reply-To: <1199263731.4172.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801021621.26401.mb@bu3sch.de> (sfid-20080102_152217_868744_0A06ECE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2008 09:48:51 Johannes Berg wrote:
> 
> On Sat, 2007-12-29 at 17:24 +0100, Michael Buesch wrote:
> > This patch fixes RX packet alignment issues in the zd1211rw driver.
> > This is based on a patch by Johannes Berg.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Looks good to me, I guess you tested it.

Yes, works fine.

> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> > Index: wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c
> > ===================================================================
> > --- wireless-2.6.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 17:14:41.000000000 +0100
> > +++ wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 17:15:00.000000000 +0100
> > @@ -623,6 +623,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
> >  	const struct rx_status *status;
> >  	struct sk_buff *skb;
> >  	int bad_frame = 0;
> > +	u16 fc;
> > +	bool is_qos, is_4addr, need_padding;
> >  
> >  	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
> >  	             FCS_LEN + sizeof(struct rx_status))
> > @@ -674,9 +676,22 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
> >  			&& !mac->pass_ctrl)
> >  		return 0;
> >  
> > -	skb = dev_alloc_skb(length);
> > +	fc = le16_to_cpu(*((__le16 *) buffer));
> > +
> > +	is_qos = ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
> > +		 ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_QOS_DATA);
> > +	is_4addr = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
> > +		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
> > +	need_padding = is_qos ^ is_4addr;
> > +
> > +	skb = dev_alloc_skb(length + (need_padding ? 2 : 0));
> >  	if (skb == NULL)
> >  		return -ENOMEM;
> > +	if (need_padding) {
> > +		/* Make sure the the payload data is 4 byte aligned. */
> > +		skb_reserve(skb, 2);
> > +	}
> > +
> >  	memcpy(skb_put(skb, length), buffer, length);
> >  
> >  	ieee80211_rx_irqsafe(hw, skb, &stats);
> > 
> 



-- 
Greetings Michael.
