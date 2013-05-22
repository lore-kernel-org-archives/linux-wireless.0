Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:60959 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab3EVMmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 08:42:31 -0400
Date: Wed, 22 May 2013 14:42:24 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"stf_xl@wp.pl" <stf_xl@wp.pl>,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Subject: Re: [PATCH] mac80211: Allow single vif mac address change with
 addr_mask
Message-ID: <20130522144224.4c95fa04@north> (sfid-20130522_144235_248486_26639258)
In-Reply-To: <CAGXE3d_HQzN5NNJ5tbDXhoeFdobpSJnvxrqAP5+T8DfyEoV_Uw@mail.gmail.com>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
	<20130521171018.238056b2@north>
	<CAGXE3d_HQzN5NNJ5tbDXhoeFdobpSJnvxrqAP5+T8DfyEoV_Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 May 2013 10:06:26 +0200, Helmut Schaa wrote:
> On Tue, May 21, 2013 at 5:10 PM, Jakub Kiciński <moorray3@wp.pl> wrote:
> > On Tue, 21 May 2013 14:54:53 +0200, Helmut Schaa wrote:
> >> When changing the MAC address of a single vif mac80211 will check if the new
> >> address fits into the address mask specified by the driver. This only needs
> >> to be done when using multiple BSSIDs. Hence, check the new address only
> >> against all other vifs.
> >
> > Oh, I see that you already posted this patch for review!
> >
> > I think we should also take care of the way addresses for new
> > interfaces are chosen otherwise they'll just pick up
> > perm_addr and we will end up with incompatible MACs.
> 
> Maybe you could send the assign_pem_addr changes as a follow up patch?

I would rather not, I think it would be messy. Or is your
patch already merged somewhere? 

Perhaps you could incorporate the change to assign_pem_addr
into your patch and send v2 adding my Sign-off?

> > @@ -1479,7 +1483,17 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
> >                         break;
> >                 }
> >
> > +               /*
> > +                * Pick address of existing interface in case user changed
> > +                * MAC address manually, default to perm_addr.
> > +                */
> >                 m = local->hw.wiphy->perm_addr;
> > +               list_for_each_entry(sdata, &local->interfaces, list) {
> > +                       if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
> > +                               continue;
> > +                       m = sdata->vif.addr;
> > +                       break;
> > +               }
> >                 start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
> >                         ((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
> >                         ((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
> 
> This is only relevant if the driver registered a addr_mask with mac80211.
> So, maybe you could only select a new address (!=perm_addr) if the
> perm_addr is not covered by the addr_mask?

I'm not sure I understand all the internal logic, but if
driver doesn't set addr_mask it will always get one of
wiphy->addresses or perm_addr and leave on line 1468 [1]
before reaching this code.


[1]http://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/iface.c#n1468

  -- Kuba
