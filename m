Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46148 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbDHSlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 14:41:19 -0400
Message-ID: <1428518469.2809.13.camel@sipsolutions.net> (sfid-20150408_204122_932807_0274A816)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 08 Apr 2015 20:41:09 +0200
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com> (sfid-20150408_202947_061786_034BEB2B)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
	 <552400F4.5010701@candelatech.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
	 (sfid-20150408_202947_061786_034BEB2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-04-08 at 18:29 +0000, Peer, Ilan wrote:

> > I saw a patch on ath10k list that enabled VHT for 2.4Ghz for that
> > driver/firmware...are you sure it is absolutely not supported?

> According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates
> in frequency bands below 6 GHz excluding the 2.4 GHz band", so at
> least the spec. is clear about it. However, I guess it would be
> possible to enable VHT for 2.4 as well to enjoy some of benefits, but
> do you see a reason/use case to enable it also for hwsim?

In addition to this: there's some interest with vendors to enable the
higher MCSes that VHT has on 2.4 GHz, so have only 20/40 MHz bandwidth
but with up to MCS 9. This is a bit problematic as the standard doesn't
really allow this, since as soon as you have VHT IEs you implicitly have
support for 80 MHz.

There's some ongoing analysis in this area to see how vendors would
really want to do this IIRC, but for now I think we should disable it
here in hwsim to match what the real devices are doing, and once we
figure out how we want to handle the higher MCSes in 2.4 GHz we can
enable the same in hwsim.

johannes

