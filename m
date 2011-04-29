Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32887 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1D2Ihs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 04:37:48 -0400
Received: by bwz15 with SMTP id 15so2942458bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 01:37:47 -0700 (PDT)
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1304061675.3589.1.camel@jlt3.sipsolutions.net>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
	 <loom.20110429T084118-365@post.gmane.org>
	 (sfid-20110429_085443_970145_470B3272)  <1304061675.3589.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 10:37:44 +0200
Message-ID: <1304066264.2931.23.camel@alex-2> (sfid-20110429_103754_241147_337C7358)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah it would be an option to just always join as HT if HT is available,
> but not create as HT unless asked.
Ok. I just had a few thoughts about this:
This way an ht ibss has to be created from a (patched) mac80211 HT
hardware. There would be no way to "convert" an existing g network into
n.
Additionally, if a non-ht implementation joins the network, it will
advertise it as non-ht. If a second ht-station joins from one of these
beacons, it won't use ht.

This way a single non-ht station could destroy a ht ibss.


I Think the best way to go would be to obey HT information when joining
HT but using the HT iw parameter when joining non-ht.

Then we could have the following scenario: Non-HT station A creates
non-HT.
HT station B joins and sets HT- (from iw). HT station C joins from A but
doesn't see B. It's iw parameter says ht+.
But when B comes closer to C do a "HT merge", comparing TSFs.

Conclusion:
- Create an ibss with the iw parameter
- When joining a ht ibss, use its parameters
- When joining non-ht, add ht from iw parameter
- When encounter a different ht config, do a ht merge.


