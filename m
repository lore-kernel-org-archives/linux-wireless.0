Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60167 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZJ1VsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 17:48:03 -0400
Received: by bwz19 with SMTP id 19so1511663bwz.28
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 14:48:06 -0700 (PDT)
Message-ID: <4AE8BC11.7040301@lwfinger.net>
Date: Wed, 28 Oct 2009 16:48:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [PATCH] b43: Fix DMA TX bounce buffer copying
References: <200910282208.15792.mb@bu3sch.de>
In-Reply-To: <200910282208.15792.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> b43 allocates a bouncebuffer, if the supplied TX skb is in an invalid
> memory range for DMA.
> However, this is broken in that it fails to copy over some metadata to the
> new skb.
> 
> This patch fixes three problems:
> * Failure to adjust the ieee80211_tx_info pointer to the new buffer.
>   This results in a kmemcheck warning.
> * Failure to copy the skb cb, which contains ieee80211_tx_info, to the new skb.
>   This results in breakage of various TX-status postprocessing (Rate control).
> * Failure to transfer the queue mapping.
>   This results in the wrong queue being stopped on saturation and can result in queue overflow.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Tested-by: Christian Casteyde <casteyde.christian@free.fr>
> 
> ---
> 
> Thanks to Johannes for tracking down this hard to find bug and
> thanks to Christian for testing.
> 
> Larry, I think I remember you reported a strange rate control failure on
> one of your cards. Does this patch fix it?
> 
> b43legacy:
> Note that b43legacy has the same bug and also needs fixing.
> Is there a maintainer for b43legacy?

Michael,

There was not really a rate-control problem - just a difficulty with
the operator. I was making a transmit test, then interrogating the
rate from the same console. By that time, the rate was back to 1 Mb/s
for control messages. When I looped the transmit tests, and looked at
the rate in a separate console, the code was doing mostly what it
should. Mostly because the success rate for the LP PHY does not
satisfy the assumptions that mistrel makes. One gets a higher
throughput with a fixed rate, but that will improve as power control
is implemented.

There is no maintainer for b43legacy. I have ported your patch for b43
to legacy and I will be testing and submitting it.

Larry

