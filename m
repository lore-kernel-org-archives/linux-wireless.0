Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab1HRN7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 09:59:20 -0400
Date: Thu, 18 Aug 2011 15:57:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all
 layers
Message-ID: <20110818135705.GA4167@redhat.com> (sfid-20110818_155924_184892_CB5A8041)
References: <1313417422.15170.39.camel@wwguy-huron>
 <20110815151231.GB15718@redhat.com>
 <1313422152.15170.43.camel@wwguy-huron>
 <20110816092610.GB6085@redhat.com>
 <1313503443.6823.9.camel@wwguy-ubuntu>
 <20110816151256.GA4932@redhat.com>
 <4825B8A2C4E264489E57869F0DCFB22344565DF754@hasmsx502.ger.corp.intel.com>
 <20110817151626.GA1552@redhat.com>
 <1313613400.6823.23.camel@wwguy-ubuntu>
 <4825B8A2C4E264489E57869F0DCFB22344565DFFDE@hasmsx502.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4825B8A2C4E264489E57869F0DCFB22344565DFFDE@hasmsx502.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 18, 2011 at 07:49:04AM +0300, Grumbach, Emmanuel wrote:
> > 
> > On Wed, 2011-08-17 at 08:16 -0700, Stanislaw Gruszka wrote:
> > > On Tue, Aug 16, 2011 at 07:23:52PM +0300, Grumbach, Emmanuel wrote:
> > > > > Simply by adding to iwl_priv different struct ops/data for each
> > upper
> > > > > layer you will have. You need to have the same thing to clue with
> > > > > mac80211, whatever upper layer will be. Otherwise, if mac80211
> > clue
> > > > > have to be different, new hardware probably needs different
> > driver.
> > > > >
> > > >
> > > > I would be reluctant to have all the data / ops needed by all the
> > possible HW
> > > > all the time in priv. I don't think it is a good idea to have
> > unallocated pointers
> > > > for a bus that don't need the rings...
> > >
> > > Not sure why there would be any unallocated pointers.
> > >
> > > > Instead, I think that having a HW specific area that is allocated
> > for each HW is much
> > > > nicer and reliable. This is what this patch series is all about.
> > > > Furthermore, I don't want the HW layer to dereference iwl_priv,
There is no reason for prohibiting dereferencing. Especially if that
would make code more complex it should not be done. Look for example
at net_device, it does not prohibit anything, but device drivers don't
use fields that are not intended to use by them i.e ->napi_list, and
use some other fields i.e. ->dev_addr . Note, this is very flexible,
net_device works with all range of different devices from 10Gbit
Ethernet to wifi.

If you want differentiate between layers in iwl_priv, it's enough to use
comments like that: 

struct iwl_priv {
/* upper layer private fields */ 
struct ieee80211_hw *hw;
...
/* public fields, can be used by hw layer and upper layer */
struct mutex mutex;
...
}

> > > We discussed with Wey upper and lower layer, term HW layer confuse me
> > > even more here.
> 
> By HW layers I meant lower layers, since these are HW specific
So this should be handled by something like that:

struct iwl_priv {
	...
	void *hw_priv;
}

Yes, so simple :-)

Stanislaw
