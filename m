Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33580 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1HQUl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 16:41:29 -0400
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by
 all layers
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110817151626.GA1552@redhat.com>
References: <20110815142144.GA15718@redhat.com>
	 <1313416005.15170.35.camel@wwguy-huron> <20110815144359.GA15719@redhat.com>
	 <1313417422.15170.39.camel@wwguy-huron> <20110815151231.GB15718@redhat.com>
	 <1313422152.15170.43.camel@wwguy-huron> <20110816092610.GB6085@redhat.com>
	 <1313503443.6823.9.camel@wwguy-ubuntu> <20110816151256.GA4932@redhat.com>
	 <4825B8A2C4E264489E57869F0DCFB22344565DF754@hasmsx502.ger.corp.intel.com>
	 <20110817151626.GA1552@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 13:36:40 -0700
Message-ID: <1313613400.6823.23.camel@wwguy-ubuntu> (sfid-20110817_224148_115600_F45873DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-17 at 08:16 -0700, Stanislaw Gruszka wrote:
> On Tue, Aug 16, 2011 at 07:23:52PM +0300, Grumbach, Emmanuel wrote:
> > > Simply by adding to iwl_priv different struct ops/data for each upper
> > > layer you will have. You need to have the same thing to clue with
> > > mac80211, whatever upper layer will be. Otherwise, if mac80211 clue
> > > have to be different, new hardware probably needs different driver.
> > > 
> > 
> > I would be reluctant to have all the data / ops needed by all the possible HW
> > all the time in priv. I don't think it is a good idea to have unallocated pointers
> > for a bus that don't need the rings...
> 
> Not sure why there would be any unallocated pointers.
> 
> > Instead, I think that having a HW specific area that is allocated for each HW is much
> > nicer and reliable. This is what this patch series is all about.
> > Furthermore, I don't want the HW layer to dereference iwl_priv,
> 
> We discussed with Wey upper and lower layer, term HW layer confuse me
> even more here. 
> 
> >  the same way the low level
> > driver doesn't dereference mac80211's local pointer. This is what the iwl_shared is all about.
> 
> Yes ieee80211_local is hidden from drivers, but IMHO this is because
> it is very big structure and we needed separate it logically into
> smaller structures. Most structures like net_device or Scsi_Host don't
> do any hiding from lower layers and are just fine.
> 
> > Are things clearer now ?
> 
> Unfortunately no. Perhaps you could describe all these layers in same
> schematic. Explain what for they are, show how they will be clued
> together and list they particular implementations.
> 
> Particularly is interesting how do you want to clue driver with mac80211
> having different iwl_priv structures. Also, what for are separate
> iwl_trans_pcie and iwl_bus_pcie instead of one thing that talk
> to pcie bus.
> 
> I would not care what you do with iwlwifi driver, but what I learnt
> from the past you are develop driver in the way that is very hard to
> debug and support it. On the same time, what is the most disappointing,
> you are ignoring majority of users bug reports, not leaving other choice
> that fix bugs by themselves. Hence is important to have driver as clean
> designed as possible, without any needles layers, abstractions and
> structures.
> 

Regarding your last point, we are working very hard and try to fix the
bugs and deliver new features with very limited resources.
We understand the issues and we will try to move as much focus as
possible to address the bugs being report by the community and hope you
will see improvement very soon.

Wey


