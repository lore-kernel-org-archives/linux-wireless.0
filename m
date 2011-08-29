Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1H2Ny5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:54:57 -0400
Subject: Re: [RFC 0/3] enable HT in a mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1314212539-23669-1-git-send-email-thomas@cozybit.com> (sfid-20110824_210302_952778_D17D74DB)
References: <1314212539-23669-1-git-send-email-thomas@cozybit.com>
	 (sfid-20110824_210302_952778_D17D74DB)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:54:57 +0200
Message-ID: <1314626097.8959.16.camel@jlt3.sipsolutions.net> (sfid-20110829_155500_493939_92C5B194)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 12:02 -0700, Thomas Pedersen wrote:
> Hi I'm adding HT support for mesh.
> 
> This patchset is pretty basic, and relies on Alexander Simon's HT IE helper
> funtions.

Ok. I'm pretty happy with those, but haven't seen the latest version of
the IBSS parts.

> No channel type negotiation takes place, and the HT info IE from the
> peer is not even read.

That seems odd.

> In practice, nodes with mismatched channel types seem to communicate fine,
> although throughput is affected (TX from HT40 -> HT20 is the worst case).

That would highly depend on rate control? Or do we do some HT
capability/operation IE stuff and figure this out? Still seems a little
strange.

> We measured these data rates in our (widely uncontrolled) office environment
> using the ath9k_htc driver:
> 
>         A\B           NO HT             HT20                  HT40+           
>        NO HT        r: 54Mb/s         r: MCS 13             r: MCS 13         
>                     D: 20Mb/s         D: 16Mb/s             D: 16Mb/s         
>        HT20         r: 54Mb/s         r: MCS 13             r: MCS 13         
>                    D: 22.5Mb/s       D: 18.5Mb/s            D: 15Mb/s         
>        HT40+        r: 54Mb/s         r: MCS 0          r: MCS 12 @ 40Mhz     
>                     D: 22Mb/s        D: 5.1Mb/s             D: 20Mb/s  
> 
> 	r: rate reported by minstrel.
> 	D: TX throughput (A -> B using 'iperf -c <B> -u -b400M')
> 
> Is it odd that even HT40+ -> HT40+ is not any better than the non-HT case? Are
> we doing something wrong? Are you surprised that mismatched channel types work
> at all?

Not surprised, but won't be efficient, especially when some device uses
a dumber rate control than minstrel :)

> So currently, our channel type is always just whatever the user configured
> through iw. The path selection algorithm should be able to compensate by
> detecting faster links and adjusting the respective mpaths accordingly.
> 
> If this is completely wrong, I would appreciate any suggestions on the right
> way to handle mesh peers with different channel types.

I have no idea. The channel type stuff seems a little fishy though.

johannes

