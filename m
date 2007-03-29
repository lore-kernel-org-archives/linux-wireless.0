Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:2274 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934082AbXC2Tqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 15:46:38 -0400
Received: by ug-out-1314.google.com with SMTP id 44so610914uga
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 12:46:37 -0700 (PDT)
Message-ID: <43e72e890703291246p1010770es9d8a81979d03fa72@mail.gmail.com>
Date: Thu, 29 Mar 2007 15:46:36 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1175112213.5151.133.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <1175112213.5151.133.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/28/07, Johannes Berg <johannes@sipsolutions.net> wrote:

> > +     /* if low level driver support 11n fill in 11n IE */
> > +     if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
> > +             pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
> > +             *pos++ = WLAN_EID_HT_CAPABILITY;
> > +             *pos++ = sizeof(struct ieee80211_ht_capability);
> > +             ieee80211_fill_ht_ie(dev,
> > +                                  (struct ieee80211_ht_capability *)pos);
>
> Now that fill_ht_ie is so short maybe it should just be rolled into this
> code.

True, might as well.

  Luis
