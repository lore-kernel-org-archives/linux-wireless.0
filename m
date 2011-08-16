Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1HPQYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 12:24:55 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 16 Aug 2011 19:23:52 +0300
Subject: RE: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by
 all layers
Message-ID: <4825B8A2C4E264489E57869F0DCFB22344565DF754@hasmsx502.ger.corp.intel.com> (sfid-20110816_182504_476772_DFFDD238)
References: <20110815084355.GB3317@redhat.com>
 <1313414020.15170.32.camel@wwguy-huron> <20110815142144.GA15718@redhat.com>
 <1313416005.15170.35.camel@wwguy-huron> <20110815144359.GA15719@redhat.com>
 <1313417422.15170.39.camel@wwguy-huron> <20110815151231.GB15718@redhat.com>
 <1313422152.15170.43.camel@wwguy-huron> <20110816092610.GB6085@redhat.com>
 <1313503443.6823.9.camel@wwguy-ubuntu> <20110816151256.GA4932@redhat.com>
In-Reply-To: <20110816151256.GA4932@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

First thank you for the helpful review

> 
> Simply by adding to iwl_priv different struct ops/data for each upper
> layer you will have. You need to have the same thing to clue with
> mac80211, whatever upper layer will be. Otherwise, if mac80211 clue
> have to be different, new hardware probably needs different driver.
> 

I would be reluctant to have all the data / ops needed by all the possible HW
all the time in priv. I don't think it is a good idea to have unallocated pointers
for a bus that don't need the rings...
Instead, I think that having a HW specific area that is allocated for each HW is much
nicer and reliable. This is what this patch series is all about.
Furthermore, I don't want the HW layer to dereference iwl_priv, the same way the low level
driver doesn't dereference mac80211's local pointer. This is what the iwl_shared is all about.

Are things clearer now ?
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

