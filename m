Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16876 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaCEJU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 04:20:29 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jouni Malinen <j@w1.fi>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Date: Wed, 5 Mar 2014 09:20:07 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D7871D@HASMSX103.ger.corp.intel.com> (sfid-20140305_102036_348306_42A320DF)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
 <20140305090854.GA3544@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > On Tue, Mar 04, 2014 at 04:50:14PM +0200, Emmanuel Grumbach wrote:
> > > This logic is already implemented in ieee80211_rx_mgmt_beacon.
> > > The purpose is to ignore probe responses that are received on
> > > adjacent channels. This can happen in 2.4GHz since channels overlap.
> >
> > Why would this be done? I can understand not updating signal
> > information, but dropping Probe Response frames completely sounds
> quite undesirable.
> > These can be used to help optimize partial scans and any additional
> > information that can be used without having to change channels sounds
> > helpful to me.
> >
> 
> So I guess you want me to revert the code we currently have in
> ieee80211_rx_mgmt_beacon ;) Don't know really... If you are associated to
> an AP and hear its beacons / probe responses on another channel you really
> have a big problem in your radio?

FWIW: this logic is there since:

commit d91f36db51661018f6d54ff5966e283bcec4c545
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Apr 16 13:17:26 2009 +0200

    mac80211: implement beacon filtering in software

