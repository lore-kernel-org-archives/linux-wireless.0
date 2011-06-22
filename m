Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab1FVSyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 14:54:05 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com> (sfid-20110620_204449_827132_DD43A304)
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 (sfid-20110620_204449_827132_DD43A304)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 20:54:00 +0200
Message-ID: <1308768840.29571.23.camel@jlt3.sipsolutions.net> (sfid-20110622_205409_792141_54533F58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 14:44 -0400, Andrew Lutomirski wrote:
> On 3.0-git today, I get:
> 
> [   40.142872] DRHD: handling fault status reg 2
> [   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
> [   40.142896] DMAR:[fault reason 05] PTE Write access is not set

Reinette also said she saw this and kindly let me use one of her systems
to track it down.

It looks like this:

iwl_enqueue_hcmd : mapping 1 at ffce2000
dmar_fault : DMAR:[DMA Write] Request device [02:00.0] fault addr ffce2000 
DMAR:[fault reason 05] PTE Write access is not set

So it's really due to my command changes, and the device is attempting
to write back to at least some commands. I see it doing that for PHY
calibration data, but I think on Reinette's system it was probably for
other commands as well since it happened a lot...

I think we have to map commands BIDI, even if I don't really understand
why.

johannes

