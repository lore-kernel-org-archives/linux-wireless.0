Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaCELV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:21:26 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jouni Malinen <j@w1.fi>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Date: Wed, 5 Mar 2014 11:20:44 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D789AA@HASMSX103.ger.corp.intel.com> (sfid-20140305_122130_074637_F05758FB)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
 <20140305090854.GA3544@w1.fi>
 <0BA3FCBA62E2DC44AF3030971E174FB303D7871D@HASMSX103.ger.corp.intel.com>
 <20140305105422.GB32093@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > On Wed, Mar 05, 2014 at 09:20:07AM +0000, Grumbach, Emmanuel wrote:
> > > > So I guess you want me to revert the code we currently have in
> > > > ieee80211_rx_mgmt_beacon ;) Don't know really... If you are
> > > > associated to an AP and hear its beacons / probe responses on
> > > > another channel you really have a big problem in your radio?
> > >
> > > FWIW: this logic is there since:
> > >
> > > commit d91f36db51661018f6d54ff5966e283bcec4c545
> > > Author: Johannes Berg <johannes@sipsolutions.net>
> > > Date:   Thu Apr 16 13:17:26 2009 +0200
> > >
> > >     mac80211: implement beacon filtering in software
> >
> > The frequency related areas in this commit are in a location that has
> > a clear comment about it being for the current BSS. Your patch did not
> > look like it would be for that case. If it is, the commit log should really say
> that clearly.
> >
> 
> V2 with a better commit log on the way - thanks!

Seems that my patch is useless since the because will still be processed by the scan code even when we are associated. So my patch didn't change anything for probes from APs we are not associated to, but it didn't change anything for probes of our AP either...

