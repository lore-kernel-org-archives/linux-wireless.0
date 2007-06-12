Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:56576 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbXFLNPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 09:15:19 -0400
Date: Tue, 12 Jun 2007 15:15:00 +0200
From: David Lamparter <dl@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lamparter <lists@diac24.net>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] {cfg,nl}80211 API
Message-ID: <20070612131458.GA6411@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net> <1181639707.29767.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20070611230434.GA13221@charon.n2.diac24.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

just for fun, I created a graph of wext->nl80211 mappings:
http://git.spaceboyz.net/?p=nl80211/nl80211-meta.git;a=blob_plain;f=nl80211-map.png;hb=865687f294a84d7847ed7a05aa63de5cbb1a0c89
- wext stuff marked red means I have no idea what that ioctl does
- lines marked blue mean I'm not sure whether that's correct
- nl80211 cmds in lowercase and light green aren't outlined yet

So, what's left?
> - more PHY config stuff?
>   - TX power? Should be able to configure a lower value...
>   - antenna selection?
      - antenna diversity, as noted by Holger Schurig
- the entire regulatory stuff

For this, my first idea (included in that graph) would be to have a
GET_REGULATORY_CAPS command which returns whether the device has a fixed
list of regdomains or whether it can load anything. Depending on that,
either SELECT_REGDOMAIN or SET_CHANLIST can be used. For the chanlist,
there would be additional attributes specifying stuff like max power,
active scanning, etc.

Other new:
- {get,set}{mac,radio} for tx power (within regulatory limits), retry
  stuff, antennas?, etc.

What I totally missed is that there also is no rate configuration command
yet (!). Do we want that in SET_CHANNEL? (and rename it to SET_PHY?)

-David

