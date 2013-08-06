Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3HFLhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 07:37:01 -0400
Message-ID: <1375789016.8219.14.camel@jlt4.sipsolutions.net> (sfid-20130806_133706_025220_495858A1)
Subject: Re: [PATCH] mac80211: add control port protocol TX control flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 06 Aug 2013 13:36:56 +0200
In-Reply-To: <CAB3XZEeYvi=i5crLsMKNhgbctPhU9BjEF=DTsHdickssRM480A@mail.gmail.com> (sfid-20130806_124006_577783_7F634B61)
References: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeYvi=i5crLsMKNhgbctPhU9BjEF=DTsHdickssRM480A@mail.gmail.com>
	 (sfid-20130806_124006_577783_7F634B61)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 13:40 +0300, Eliad Peller wrote:

> >  static inline bool iwl_trace_data(struct sk_buff *skb)
> >  {
> >         struct ieee80211_hdr *hdr = (void *)skb->data;
> > +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> >
> >         if (ieee80211_is_data(hdr->frame_control))
> > -               return skb->protocol != cpu_to_be16(ETH_P_PAE);
> > +               return info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
> >         return false;
> >  }
> this looks reversed...

Good catch, thanks.

johannes

