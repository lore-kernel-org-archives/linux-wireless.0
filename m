Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45621 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933447AbXBEUnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 15:43:35 -0500
Date: Mon, 5 Feb 2007 21:43:33 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Message-ID: <20070205214333.4e77948e@griffin.suse.cz>
In-Reply-To: <200702041344.19117.mb@bu3sch.de>
References: <200702041344.19117.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 4 Feb 2007 13:44:18 +0100, Michael Buesch wrote:
> We need the phase1 for bcm43xx. We need to upload it to
> card memory and we need to pass it on every TX on the DMA.
> 
> So, currently we receive the phase1 key on the first
> encrypted TX. That's too late, as we already receive encrypted
> packets before that. bcm43xx needs the phase1 key (and the iv32)
> on RX. It uses the one uploaded into the card memory. But it
> is not uploaded, yet, as we did not TX any encrypted packet.
> 
> I'd say the only solution to this is to implement the earlier
> suggested way of having a library function call to generate
> the keys. Of course, that needs some bookkeeping about the IVs
> and stuff.
> That library function would be called by bcm43xx before any
> traffic to get an initial phase1 key (and iv32) uploaded.

What if the key is changed by the user space? You won't know that and
won't call the library function then. I think it needs to be designed
in the opposite way - the stack will call a driver's callback.

Or am I missing something?

 Jiri

-- 
Jiri Benc
SUSE Labs
