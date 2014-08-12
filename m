Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51021 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHLIYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 04:24:03 -0400
Message-ID: <53E9CF20.8030500@broadcom.com> (sfid-20140812_102408_520308_1C425EB9)
Date: Tue, 12 Aug 2014 10:24:00 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
References: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1407769025.9844.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1407769025.9844.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2014 04:57 PM, Johannes Berg wrote:
> On Mon, 2014-08-11 at 03:29 -0700, Vladimir Kondratiev wrote:
>> In the cfg80211_rx_mgmt(), parameter @gfp was used for the memory allocation.
>> But, memory get allocated under spin_lock_bh(), this implies atomic context.
>> So, one can't use GFP_KERNEL, only variants with no __GFP_WAIT. Actually, in all
>> occurrences GFP_ATOMIC is used (wil6210 use GFP_KERNEL by mistake),
>> and it should be this way or warning triggered in the memory allocation code.
>>
>> Remove @gfp parameter as no actual choice exist, and use hard coded
>> GFP_ATOMIC for memory allocation.

When I saw the patch I quickly checked and noticed brcmfmac using 
GFP_ATOMIC. However, looking at bit closer into this it turns out that 
the cfg80211_rx_mgmt() call could be done with GFP_KERNEL flag in 
brcmfmac. I leave it to you what to do here :-p

> Applied, thanks.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

