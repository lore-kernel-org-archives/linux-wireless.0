Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45901 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbYFPPfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 11:35:24 -0400
Date: Mon, 16 Jun 2008 18:34:21 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Management frame protection and packet injection from hostapd
Message-ID: <20080616153421.GC18479@jm.kir.nu> (sfid-20080616_173530_185979_E0963D91)
References: <20080616143308.GB18479@jm.kir.nu> <1213627991.3803.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213627991.3803.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 04:53:11PM +0200, Johannes Berg wrote:

> So just for me, BIP processing is done with the same IGTK? Unicast
> frames are handled by the per-station key, and as such work correctly,
> I'd guess?

Yes, as long as the STA entry is found (and it should, in this case),
the pairwise CCMP key is used both for data and management frames. I
haven't done full testing yet, but I would expect this to work even when
the unicast management frames comes from hostapd.

Broadcast/multicast management frames are protected with BIP using IGTK.
This is similar to how GTK is used with TKIP/CCMK for broadcast data
frames, i.e., there is a default TX key index that the AP uses for the
frames. Indexes 1..3 are used for data frames and 802.11w is using 4..5
for BIP (even though the key index space is actually completely separate
from the one used with data frames).

> Yeah that sounds like a hack. I guess it should work just like when we
> submit a unicast frame via monitor with the radiotap flag to indicate
> that we want encryption, only we should add logic to look up the default
> key to use if there is no peer/unicast key by the outgoing MAC address?

Yes, we already look for STA entry for unicast and that should work as
long as the STA table is not per netdev, i.e., both data and monitor
interface end using the same STA table. If no STA entry is found
(multicast/broadcast), we look for a default TX key, but this is only
done for the netdev that was used to send the frame (which is different
between normal data interface and packet injection via monitor
interface).

If the monitor interface were to look for the default key (or well,
keys, since there are now two; one for data, one for mgmt) from the data
interface (somehow bound to the monitor iface?), that should work here.

> OTOH, that would break for multi-SSID/single-BSSID scenarios I guess, so
> we probably need a way to indicate "this frame belongs to interface
> index N"?

Yes, either the frame or maybe more easily the monitor interface would
need to be bound to the interface that is used for key configuration.

> I don't see any such problems, but if I were to venture a guess it's
> because of configuring keys on a monitor interface. It sounds like
> something sticks around within the netdev:mon.wlan0 subdirectory, then
> the code tries to delete the directory and only afterwards is the entry
> removed, leaving the directory (and the parent, of course) hanging
> there.

Yes, that sounds likely since the changes I did for debugfs were very
trivial copies from CCMP/data-default-key processing. I'll debug this
more and try to figure if there is need to re-order something or make
the debugfs entry removal able to handle such a case.

-- 
Jouni Malinen                                            PGP id EFC895FA
