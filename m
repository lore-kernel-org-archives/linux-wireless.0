Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:19285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965689AbXC1TLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 15:11:15 -0400
Received: by ug-out-1314.google.com with SMTP id 44so307721uga
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2007 12:11:09 -0700 (PDT)
Message-ID: <43e72e890703281211s6793af26pe14d9d9fdfa91095@mail.gmail.com>
Date: Wed, 28 Mar 2007 15:11:08 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: mohamed <mabbas@linux.intel.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1175148244.4237.4.camel@dell-4965.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <43e72e890703271005u6173567aq2c1c04635da3ce50@mail.gmail.com>
	 <43e72e890703271011h47a6177dp32b7c2324ab51423@mail.gmail.com>
	 <43e72e890703271029q169c3fdo6d410f272eaf791@mail.gmail.com>
	 <1175148244.4237.4.camel@dell-4965.jf.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/29/07, mohamed <mabbas@linux.intel.com> wrote:
> On Tue, 2007-03-27 at 13:29 -0400, Luis R. Rodriguez wrote:
> > On 3/27/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > > On 3/27/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > > > On 3/26/07, mohamed <mabbas@linux.intel.com> wrote:
> > > >
> > > > > +/* Get 11n capabilties from low level driver */
> > > > > +static void ieee80211_fill_ht_ie(struct net_device *dev,
> > > > > +                                struct ieee80211_ht_capability *ht_capab)
> > > > > +{
> > > > > +       int rc;
> > > > > +       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> > > > > +
> > > > > +       if (!local->ops->get_ht_capab){
> > > > > +               memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       rc = local->ops->get_ht_capab(local_to_hw(local), ht_capab);
> > > > > +       if (!rc) {
> > > > > +               memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> > > > > +               return;
> > > > > +       }
> > > > >
> > > > > +       ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
> > > > > +                                       ht_capab->capabilitiesInfo);
> > > > > +       ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
> > > > > +                                       ht_capab->extended_ht_capability_info);
> > > > > +       ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
> > > > > +                                       ht_capab->tx_BF_capability_info);
> > > > > +}
> > > > > +
> > > >
> > > > We should memset to 0 the entire ht_capab to regardless as its coming
> > > > from skb_put() otherwise we'll get random data there if we don't set
> > > > it and we sure as hell don't want to just transmit that :)
> I will memset to 0 before using the structure. I will change the patch
> to reflect this.

Thanks

> > Also
> > > > ieee80211_send_assoc() is already checking for
> > > > local->ops->get_ht_capab so lets just do a BUG_ON here to capture
> > > > cases where someone else didn't do the proper checking. So how about
> > > > instead something like:
> make sense.

Thanks

> > > > /* Get 11n capabilties from low level driver */
> > > > static void ieee80211_fill_ht_ie(struct net_device *dev,
> > > >                                 struct ieee80211_ht_capability *ht_capab)
> > > > {
> > > >        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> > > >        BUG_ON(!local->ops->get_ht_capab);
> > > >        memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> > > >        if (!local->ops->get_ht_capab(local_to_hw(local), ht_capab))
> > > >                return;
> > > >        ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
> > > >                                        ht_capab->capabilitiesInfo);
> > > >        ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
> > > >                                        ht_capab->extended_ht_capability_info);
> > > >        ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
> > > >                                        ht_capab->tx_BF_capability_info);
> > > > }
> > > >
> > >
> > > On second thought just memset to 0 on ieee80211_send_assoc() right
> > > after the skb_put and remove that from above.
> > >
> > >   Luis
> > >
> >
> > Last few comments:
> >
> > I. In struct ieee80211_ops you added your hunk after the TSF comment,
> > but before  u64 (*get_tsf)(struct ieee80211_hw *hw) was listed. Please
> > move the hunk after get_tsf or before the comment.
> >
> > II. In ieee80211_fill_ht_ie() you do cpu_to_le* on the same fields.. I
> > take it the driver's get_ht_capab() is supposed to fill these. Since
> > you already defined them as little endian in the struct
> > ieee80211_ht_capability, how about just leaving that up to the driver
> > developer to make sure they do this? That's would be 6 lines less of
> > code in ieee80211_fill_ht_ie().

And how about regarding the above comment (II)? We can just expect
driver developers to follow proper endianness. That cleans that
routine a bit more too.

  Luis
