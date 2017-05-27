Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36918 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdE0QHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 12:07:35 -0400
Subject: Re: [PATCH] Per chain RSSI reporting
To: Norik Dzhandzhapanyan <norikd@ethertronics.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com> (sfid-20170527_180741_064976_5C2B86C3)
Date: Sat, 27 May 2017 09:07:32 -0700
MIME-Version: 1.0
In-Reply-To: <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At low encoding rates, especially if it switches to a single-chain encoding,
maybe the on-air signal really is stronger?

Have you verified in some other manner than the signals reported by ath10k are
wrong?

Thanks,
Ben


On 05/26/2017 07:09 PM, Norik Dzhandzhapanyan wrote:
> Hi Adrian,
>
> Inserting the smoothing function here is motivated by what we see as 'spikes' in rssi data under weak rssi conditions.  Figured its best to get rid of the 'bogus' data as close to the source as possible. Also to minimize the impact on the changes.
>
> I believe the averaging  that happens at higher levels is based on EWMA macros in net/mac80211/sta_info.c which not wifi card/chipset specific. Didn't want to touch that since other cards seem to not have this spikey behavior. And, it doesnt seem to have an effect on the ath10k data anyway (iw reports the exact same values for both).
>
> I wonder if it would be acceptable to pass a module load time parameter which would indicate an average factor with 0 (as default) to indicate no averaging?
>
> Another option would be to add the chain_signal_avg field to the ieee80211_tx_status struct in mac80211.h to expose the average value up the stack this way? I haven't looked too deep on what this entails though and I didn't want to risk impacting anything else.
>
> So yes.. I am OK with the per-chain RSSI changes first.
>
> Norik
>
>
> From: adrian.chadd@gmail.com <adrian.chadd@gmail.com> on behalf of Adrian Chadd <adrian@freebsd.org>
> Sent: Friday, May 26, 2017 6:12 PM
> To: Norik Dzhandzhapanyan
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] Per chain RSSI reporting
>
> [snip]
>
> hiya,
>
> I have something local that I've been meaning to push up to do this,
> but with no smoothing. Ideally (!) smoothing is done optionally in
> mac80211.
>
> What do you think about just committing the per-chain RSSI stuff to
> mac80211 so it shows up right now, and then we figure out how to
> express the smoothing in mac80211 or further up the layers?
>
> (We care about packet-to-packet RSSI values for "reasons" - mostly
> bring-up and board validation, but also for runtime link checks.)
>
>
> -adrian
>
> The contents of this transmission are Ethertronics Inc. Confidential and may contain proprietary or legally privileged information which may not be disclosed, copied or distributed without the express written consent of Ethertronics Inc. The information is intended to be for the use of the individual or entity named on this transmission. If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately so that we can arrange for the retrieval of the original documents at no cost to you. Alternatively, notify the sender by replying to this transmission and delete the message without disclosing it. Thank you
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
