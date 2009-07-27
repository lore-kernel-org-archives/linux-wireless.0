Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:47957 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZG0PX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:23:58 -0400
Date: Mon, 27 Jul 2009 16:23:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tim Gardner <timg@tpi.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Fix rfkill state setting
Message-ID: <20090727152356.GA8049@srcf.ucam.org>
References: <20090727144747.E7F4EF891B@sepang.rtg.net> <1248707418.8500.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1248707418.8500.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 05:10:18PM +0200, Johannes Berg wrote:

> Hmm. The previous code was
> 
> -       if (status & (1<<16))
> -               new_state = RFKILL_STATE_SOFT_BLOCKED;
> -
> -       if (status & (1<<bit))
> -               *state = new_state;
> -       else
> -               *state = RFKILL_STATE_UNBLOCKED;
> -
> -       return 0;
> 
> where new_state was initialised to RFKILL_STATE_HARD_BLOCKED.
> 
> So doesn't that mean that 1<<bit is the hard-block bit? Or was the
> previous code just bogus, but happened to work since rfkill didn't
> separate the hard/soft kill concepts?

The previous code may well have been bogus. The code is basically the 
only documentation I have here - bit 16 indicates that the switch is on 
(and thus everything else is hard blocked), while bits 17, 18 and 19 
indicate blocked wifi, bluetooth and wwan respectively. I'd assumed that 
those indicated that they were soft blocked independently of the 
hardware block state, but it may be that the hardware doesn't expose the 
soft state if the hard switch is blocking the devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
