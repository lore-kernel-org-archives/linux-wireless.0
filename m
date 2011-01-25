Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51475 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1AYWBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 17:01:34 -0500
Message-ID: <4D3F4832.4080907@candelatech.com>
Date: Tue, 25 Jan 2011 14:01:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH RESEND 09/11] ath9k: Try all queues when looking for next
 packet to send.
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com> <1294643513-18820-10-git-send-email-greearb@candelatech.com> <20110125213710.GD2927@tuxdriver.com>
In-Reply-To: <20110125213710.GD2927@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2011 01:37 PM, John W. Linville wrote:
> On Sun, Jan 09, 2011 at 11:11:51PM -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> There can be multiple struct ath_atx_ac entries for each
>> txq, so if the first one doesn't have any packets to send
>> now, try the rest of them.  This should help keep xmit
>> going when using multiple stations, especially with AMPDU
>> enabled.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>
> This one doesn't seem to apply any more.  Can I persuade you to rebase
> and resubmit it?

I think this is already taken care of, or at least the important
parts.

Felix did some initial work in this area, and then I
followed on with this one:

ath9k:  Try more than one queue when scheduling new aggregate.


The only ath9k patches I have in my queue that are not upstream
are:

(From Louis Rodriguez)
ath9k: warn when we get a ATH9K_INT_TIM_TIMER and are idle

and my:

ath9k: Implement rx copy-break.

Which appears DOA as folks seem to like paged-skbs instead.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

