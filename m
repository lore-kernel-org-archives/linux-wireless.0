Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46432 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1AFXxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 18:53:18 -0500
Message-ID: <4D2655E6.3020304@candelatech.com>
Date: Thu, 06 Jan 2011 15:53:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Michael Guntsche <mike@it-loops.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ath9k] skbuff alloc of size 3872 failed
References: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
In-Reply-To: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2010 11:22 AM, Matt Turner wrote:
> With the ath9k driver, I get "skbuff alloc of size 3872 failed"
>
> I hit this again today after not using wireless for quite sometime. It
> looks like it was originally reported against 2.6.35-rc1. Eric Dumazet
> provided a patch which fixed the issue, but apparently it's still not
> upstream. Why is this?
>
> If it is suitable for upstream inclusion, please take my Tested-by:
> Matt Turner<mattst88@gmail.com>
>
> https://patchwork.kernel.org/patch/104271/

I applied this patch and it seems to work fine, but there
were some questions by Eric in the patchwork thread that should probably
be answered by ath9k folks.

For instance:

IEEE80211_MAX_MPDU_LEN being 3840 + somebits is suspect, since it doesnt
match 802.11 specs.

It should be more close of 2304 + MAC header (32bytes) + FCS (4 bytes) ?


Eric:  If the patch is fine as is, and if you are too busy to
submit it, I can do so with your Signed-off-by if you want.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

