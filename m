Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:44176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816AbXC0RLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2007 13:11:46 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1953478uga
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2007 10:11:41 -0700 (PDT)
Message-ID: <43e72e890703271011h47a6177dp32b7c2324ab51423@mail.gmail.com>
Date: Tue, 27 Mar 2007 13:11:39 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: mohamed <mabbas@linux.intel.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <43e72e890703271005u6173567aq2c1c04635da3ce50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <43e72e890703271005u6173567aq2c1c04635da3ce50@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/27/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On 3/26/07, mohamed <mabbas@linux.intel.com> wrote:
>
> > +/* Get 11n capabilties from low level driver */
> > +static void ieee80211_fill_ht_ie(struct net_device *dev,
> > +                                struct ieee80211_ht_capability *ht_capab)
> > +{
> > +       int rc;
> > +       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> > +
> > +       if (!local->ops->get_ht_capab){
> > +               memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> > +               return;
> > +       }
> > +
> > +       rc = local->ops->get_ht_capab(local_to_hw(local), ht_capab);
> > +       if (!rc) {
> > +               memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> > +               return;
> > +       }
> >
> > +       ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
> > +                                       ht_capab->capabilitiesInfo);
> > +       ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
> > +                                       ht_capab->extended_ht_capability_info);
> > +       ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
> > +                                       ht_capab->tx_BF_capability_info);
> > +}
> > +
>
> We should memset to 0 the entire ht_capab to regardless as its coming
> from skb_put() otherwise we'll get random data there if we don't set
> it and we sure as hell don't want to just transmit that :) Also
> ieee80211_send_assoc() is already checking for
> local->ops->get_ht_capab so lets just do a BUG_ON here to capture
> cases where someone else didn't do the proper checking. So how about
> instead something like:
>
> /* Get 11n capabilties from low level driver */
> static void ieee80211_fill_ht_ie(struct net_device *dev,
>                                 struct ieee80211_ht_capability *ht_capab)
> {
>        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>        BUG_ON(!local->ops->get_ht_capab);
>        memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
>        if (!local->ops->get_ht_capab(local_to_hw(local), ht_capab))
>                return;
>        ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
>                                        ht_capab->capabilitiesInfo);
>        ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
>                                        ht_capab->extended_ht_capability_info);
>        ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
>                                        ht_capab->tx_BF_capability_info);
> }
>

On second thought just memset to 0 on ieee80211_send_assoc() right
after the skb_put and remove that from above.

  Luis
