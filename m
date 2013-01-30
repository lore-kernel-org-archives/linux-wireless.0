Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33856 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3A3GQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 01:16:16 -0500
Message-ID: <5108BAAD.7070306@candelatech.com> (sfid-20130130_071624_995584_C63CC18E)
Date: Tue, 29 Jan 2013 22:16:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/beacon.c:362 ath9k_beacon_tasklet+0xcc/0x5f0)
References: <5108AD09.9020308@candelatech.com> <20744.44999.48237.463434@gargle.gargle.HOWL> <5108B569.9090005@candelatech.com> <20744.47404.184099.495423@gargle.gargle.HOWL>
In-Reply-To: <20744.47404.184099.495423@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 10:09 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> They were not.  I see the second was queued to stable, should the first one
>> be a stable candidate as well?
>
> Sorry, I meant this one:
>
> commit 1adb2e2b5f85023d17eb4f95386a57029df27c88
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Wed Jan 9 16:16:53 2013 +0100
>
>      ath9k: fix double-free bug on beacon generate failure
>
>      When the next beacon is sent, the ath_buf from the previous run is reused.
>      If getting a new beacon from mac80211 fails, bf->bf_mpdu is not reset, yet
>      the skb is freed, leading to a double-free on the next beacon tx attempt,
>      resulting in a system crash.
>
>      Cc: stable@vger.kernel.org
>      Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>

I did not have this one applied, and it would explain at least one
crash that I've seen.

I'll apply it (and the other you mentioned) now.

Thanks!
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

