Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:60282 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXKVOtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 09:49:12 -0500
Received: by nf-out-0910.google.com with SMTP id g13so2462571nfb
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 06:49:11 -0800 (PST)
Message-ID: <c85cb4470711220649vd83b72lf0e6ae537b359c93@mail.gmail.com> (sfid-20071122_144915_980264_B0AD34B8)
Date: Thu, 22 Nov 2007 16:49:10 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195732107.6323.84.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
	 <1195732107.6323.84.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Looking into the eapol handling in more detail, I found another bug with
> your patch. Namely, in the RX path, you have:
>
> > -     if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
> > +     if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb, hdrlen) &&
>
> at which point the frame is already reframed to 802.3.
>
> However,
>
> > -int ieee80211_is_eapol(const struct sk_buff *skb)
> > +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen)
> >  {
>
> >       if (unlikely(skb->len >= hdrlen + sizeof(eapol_header) &&
> >                    memcmp(skb->data + hdrlen, eapol_header,
> >                           sizeof(eapol_header)) == 0))
>
> here checks the full 802.2 LLC header which was removed by the
> reframing, thus this check will always be false.
>
> I think we should, instead, have the ieee80211_data_to_8023 function set
> skb->protocol correctly, and leave the skb's data pointer pointing to
> the payload rather than the ethernet header, like eth_type_trans() would
> do. In fact, I think we can just call it after we've reframed the frame.
> Then, we can check skb->protocol for EAPOL which is a much cheaper check
> too.
>
> The thing I'm not entirely sure about is what happens with
> eth_type_trans() and the pulling of the ethernet header. Wouldn't that
> cause us problems with the skb->data[] accesses in
> ieee80211_subif_start_xmit() once the frame arrives back there?

excellent catch, you are right.
let me suggest an alternative, which makes use of current ieee80211_is_eapol.
in regular Rx data frames, code will look like this:

+     ieee80211_drop_802_1x_pae(rx, size of current 802.11 hdr);
+     ieee80211_drop_unencrypted(rx, size of current 802.11 hdr);
      ieee80211_data_to_8023(rx)
-     ieee80211_drop_802_1x_pae(rx, size of 802.3 hdr);
-     ieee80211_drop_unencrypted(rx, size of 802.3 hdr);

while in A-MSDU frames code will look like this:

     ieee80211_data_to_8023(rx)
for each internal frame (that is any how in 802.2 form):
+     ieee80211_drop_802_1x_pae(rx, 0);
+     ieee80211_drop_unencrypted(rx, 0);
       move from 802.2 to 802.3
-     ieee80211_drop_802_1x_pae(rx, size of 802.3 hdr);
-     ieee80211_drop_unencrypted(rx, size of 802.3 hdr);

I thought it makes good use of the infrastructure we made so far, what
do you think?

> johannes
>
>
