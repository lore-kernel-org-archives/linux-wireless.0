Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.hammerl-bau.at ([213.235.197.82]:53393 "EHLO
	ns2.hammerl-bau.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYATJyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 04:54:01 -0500
Message-ID: <45504.61.115.136.26.1200822830.squirrel@webmail.einfach.org> (sfid-20080120_095407_823292_71F6D37B)
Date: Sun, 20 Jan 2008 19:53:50 +1000 (EST)
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: always extend rx timestamp
     with tsf
From: "bruno randolf" <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: "" Derek Smithies "" <derek@indranet.co.nz>, jirislaby@gmail.com,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 January 2008 17:46:05 Luis R. Rodriguez wrote:
> Yeah thanks, might be more clear for those of us not used to that
> convention, I didn't even know it existed. Where is this "." for 1000
> notation convention used, just so I know :) ?

in german speaking countries at least (i am austrian), don't really know
where else...

> > > You are correct. It should be done within 32.768 ms. On a high end
> > > laptop, it is almost guaranteed that the bottom half will process the
> > > packet within 32 ms. However, on an embedded box (low spec cpu) that
> > > has a temporarily high load, 32 ms is a short time, and the timestamp
> > > may have wrapped around. this is unfortunate.
> >
> > i know that this might happen, and that's why i included this comment. i
> > was just too lazy to make the same act as is done in madwifi (lopping
> > thru all rx descriptors in the interrupt handler). the current code is
> > sufficient for IBSS testing right now.
>
> Thanks for the explanation.
>
> BTW while on the topic of TSF extension, anyone get why we do the tsf
> -= 0x8000 if the hw's tsf's 15 bits value is < the rx descriptor's
> rstamp? This is what ath5k_extend_tsf() does right before the (tsf &
> ~0x7fff) | rstamp.

this is in order to account for situations where the last 15 bit of the
TSF have wrapped around in the mean time, since the rstamp was recorded
with the packet. it is not possible that we received the packet *after*
the current TSF (in the interrupt handler or in the tasklet), so we assume
that the 15bit value has overflown and therefore the time at packet
reception must have been - 0x8000.

> > also even if we move TSF extension into the interrupt handler this will
> > not help in all cases. there are situations in IBSS mode - when a HW
> > merge (= automatic HW TSF update upon receipt of a beacon with a higherr
> > TSF and the same BSSID) happens - where the rx timestamp is apparently
> > based on the old TSF, before the HW TSF is updated. in that case we
> > cannot extend the timestamp in any meaningful way. i'm not sure how we
> > should handle this.
>
> Hmm.. have you seen this with madwifi driver? What do you think is the
> cause? If we don't do proper locking I can see this being an issue on
> the driver side unless this is specifically a hardware issue.

i have seen this in ath5k and other people have seen it in madwifi.
therefore i'm pretty sure it's a HW issue. unfortunately this happens with
ad-hoc beacons where it's most critical to get a correct TSF.

bruno


