Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:50357 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbXIFCGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 22:06:31 -0400
Date: Wed, 5 Sep 2007 19:06:11 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] per-sta reassembly buffers
Message-ID: <20070906020611.GJ5273@jm.kir.nu>
References: <1188988102.9942.89.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188988102.9942.89.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2007 at 12:28:22PM +0200, Johannes Berg wrote:

> I was looking through the defragmentation code and noticed that we only
> allow four fragmented frames to be in flight at the same time. It seems
> that in a somewhat contended QoS network where fragmentation is enabled
> this is far from enough since as far as I can tell from the standard
> each source STA may be sending fragmented frames in the various access
> categories (think starting in background and then preempting by best
> effort etc.)

I would have expected STAs to transmit only one MSDU at a time to any
given destination STA. This was the way it was done before QoS and I did
not find any clear point in QoS changes that would have changed the
behavior. The changes in the duplicate detection are, though, implicitly
pointing out that there may actually be separate fragmentation for each
TID.

> We could easily increase this by using per-sta reassembly buffers at no
> CPU cost [1] but that has the obvious disadvantage of having much higher
> worst-case memory usage. Thoughts?

The main reason for the original design was in being conservative with
memory use. After all, this was used for embedded devices with very
limited memory capabilities and the AP was actually allowing up to 2007
STAs to be associated. If each associated STA were to use fragmentation
and if there were large number of lost (un-ACK'ed) frames, the total
memory buffers needed for the frames could go quite high.

Since fragments are commonly sent out in a burst that includes the full
MSDU, the number of pending fragments from unfinished MSDUs is often
quite a bit smaller than the worst case.

Anyway, I would be fine with changing this as long as there is a way of
enforcing the total number of buffered frames to be below a reasonable
(and preferably configurable) limit.

-- 
Jouni Malinen                                            PGP id EFC895FA
