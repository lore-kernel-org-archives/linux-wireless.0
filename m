Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3EFPoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 11:44:15 -0400
Message-ID: <1367855046.8434.16.camel@jlt4.sipsolutions.net> (sfid-20130506_174445_603426_ECA77462)
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Date: Mon, 06 May 2013 17:44:06 +0200
In-Reply-To: <1367854279.8434.13.camel@jlt4.sipsolutions.net> (sfid-20130506_173141_669857_04689481)
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	 <20130506123805.GA1602@redhat.com>
	 <20130506083759.556dac76@chukar.edge2.net>
	 <20130506153044.GB1602@redhat.com>
	 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
	 (sfid-20130506_173141_669857_04689481)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-06 at 17:31 +0200, Johannes Berg wrote:

> > But if so, I would also see
> > the breakage on my setup, but I don't - it works quite well here. 
> 
> Are you testing on a passive channel? Try with a large beacon interval.

I think most likely what happens is that it's on a passive channel, and
the firmware drops the TX packet with a bad status. Before the patch,
we'd just wait sitting on the channel for HZ/5 (200ms) before trying
again, with the patch we immediately retransmit the packet, which will
fail again and again until the firmware received a beacon.

If you look at iwlwifi/dvm/, it has some passive_no_rx workaround for
this, which I don't see in iwlegacy.

I think the best way to solve this would be to do such a thing in
iwlegacy as well, but until then and for stable maybe we should
introduce another HW flag to restore the previous mac80211 behaviour?

johannes

