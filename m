Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60674 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDHCcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 22:32:17 -0400
Message-ID: <53435F89.60500@candelatech.com> (sfid-20140408_043238_826769_41F6F095)
Date: Mon, 07 Apr 2014 19:31:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>	<5341F1A9.2030202@candelatech.com> <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com>
In-Reply-To: <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2014 02:11 AM, Michal Kazior wrote:

> These logs are not enough. I'd love to see traces for this to see what
> frames are actually submitted and when tx credits are replenished.
>
> I also wonder if this can be somehow related to your FW changes to
> allow connecting multiple client virtual interfaces to a single AP?

I think it is unlikely due to my firmware changes...little of that touched
the handling of management frames.  It might very well be a basic problem in
either the firmware or driver when using multiple station VIFS.  I think that
aside from my testing that code has not been used much.

Note my followup email that problems started with patch 3/4...not sure you
saw that one or not.  I saw similar failure to associate & get DHCP (and
slow/hung user-space) without the kernel error logs.

I've added the first two patches to my tree and will continue to run
with them since they do not appear to cause problems so far.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

