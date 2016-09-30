Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41908 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933300AbcI3KCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 06:02:13 -0400
Message-ID: <1475229714.17481.18.camel@sipsolutions.net> (sfid-20160930_120218_154135_19EA9F2D)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Fri, 30 Sep 2016 12:01:54 +0200
In-Reply-To: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few more things:

First of all - there's nothing specific to "AP interfaces", which you
say in the subject, as far as I can tell? That should be removed?

On Wed, 2016-09-28 at 17:14 +0200, Michael Braun wrote:
> When using WPA security, the station and thus the required key is
> identified by its mac address when packets are received. So a
> station usually cannot spoof its source mac address.
> 
> But when a station sends an A-MSDU frame, port control and crypto
> is done using the outer mac address, while the packets delivered
> and forwarded use the inner mac address.
> 
> IEEE 802.11-2012 mandates that the outer source mac address should
> match the inner source address (section 8.3.2.2). For the
> destination mac address, matching is not required (section 10.23.15).

I think this is wrong. As we do not support DMS (yet), we should adhere
to 8.3.2.2 and only accept matching TA/SA and DA/RA.

And even when we add DMS, we should also restrict it to multicast
addresses, but that's future work anyway.

> > -			if (ieee80211_data_to_8023(pkt, vif->addr, vif->type))
> > +			if (ieee80211_data_to_8023(pkt, NULL, vif->addr,
> > +			    vif->type))

indentation is bad here - consider running checkpatch

>  static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
> > -					  struct sk_buff *skb)
> > +					  struct sk_buff *skb,
> > +					  const u8 *ta)

[... more mwifiex changes ...]

It's great that you're doing this, but I think this patch should only
carry the bare minimum change for mwifiex to keep it compiling, with a
follow-up patch that actually implements the correct checks. That way,
should any issues arise, it's easier to determine where the problem is
and to fix/revert it.

> diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
> index 150dabc..38ba7dd 100644
> --- a/drivers/staging/rtl8723au/core/rtw_recv.c
> +++ b/drivers/staging/rtl8723au/core/rtw_recv.c
> @@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
> >  	skb_pull(skb, prframe->attrib.hdrlen);
> >  	__skb_queue_head_init(&skb_list);
>  
> > -	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, false);
> > +	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, pattrib->ta);

A bit debatable here, but I'd actually also prefer you add NULL here
first and then submit a separate patch that puts the right thing.

Not that it actually matters, since this driver has been removed
already... since you have to resubmit anyway though, I'd prefer you
just put NULL, and then not worry about it from there on.

> > -	if (has_80211_header) {
> > -		err = __ieee80211_data_to_8023(skb, &eth, addr, iftype);
> > -		if (err)
> > -			goto out;
> > -	}

Good approach to split that :)

> > +		if (unlikely(ta &&
> > +			     (iftype == NL80211_IFTYPE_AP ||
> > +			      iftype == NL80211_IFTYPE_AP_VLAN) &&
> > +			     !ether_addr_equal(ta, eth.h_source)
> > +		   ))
> > +			goto purge;

Coding style here is very odd. All those closing parens should be on
the line before.

Thanks,
johannes
