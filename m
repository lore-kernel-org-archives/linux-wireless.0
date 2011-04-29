Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1D2MgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 08:36:08 -0400
Received: by fxm17 with SMTP id 17so2458935fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 05:36:05 -0700 (PDT)
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1304066264.2931.23.camel@alex-2>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356) <1303995368.3558.9.camel@jlt3.sipsolutions.net>
	 <loom.20110429T084118-365@post.gmane.org>
	 (sfid-20110429_085443_970145_470B3272)  <1304061675.3589.1.camel@jlt3.sipsolutions.net>
	 <1304066264.2931.23.camel@alex-2>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 14:36:03 +0200
Message-ID: <1304080563.2931.41.camel@alex-2> (sfid-20110429_143612_006856_91560407)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for replying to myself but i'll try to explain this a little bit
easier:

- If the channel is not *fixed*, the channel type is only advisory.
This means that a merge of two HT40 networks with fixed channels will
only take place if the HT40 configuration equals.

- When merging, the looser will obey the winner's HT configuration if
there is one. If not, keep the old one.

- If HT has been configured through iw and a non-HT network is to be
joined, iw's HT setting is used and announced.

HT configuration within an IBSS may get inhomogeneous as a HT station
may join from a non-HT beacon but there are other HT members.

- When receiving a different HT configuration from another member of our
BSSID, use this configuration (first beacon wins)

Alex


