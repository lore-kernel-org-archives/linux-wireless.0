Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13582 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaLWPel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:34:41 -0500
Message-ID: <54998B8E.3020002@broadcom.com> (sfid-20141223_163444_962175_85375E39)
Date: Tue, 23 Dec 2014 16:34:38 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Avinash Patil <patila@marvell.com>,
	<linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <janusz.dziedzic@tieto.com>
Subject: Re: [PATCH] cfg80211: check for carrier state only when offchanel
 CAC supported
References: <1419365159-6577-1-git-send-email-patila@marvell.com> <1419346405.6091.6.camel@sipsolutions.net>
In-Reply-To: <1419346405.6091.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/14 15:53, Johannes Berg wrote:
> On Wed, 2014-12-24 at 01:35 +0530, Avinash Patil wrote:
>> Checking for carrier state during start_radar_detection is needed
>> only for devices which support offchannel CAC.
>> This patch adds one more condition while checking for carrier state
>> to see if offchanel CAC is supported, else we need not check carrier
>> state.
>>
>> Signed-off-by: Avinash Patil<patila@marvell.com>
>> ---
>>   include/net/cfg80211.h | 2 ++
>>   net/wireless/nl80211.c | 3 ++-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 4ebb816..1b80302 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -2740,6 +2740,7 @@ struct cfg80211_ops {
>>    * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
>>    * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
>>    *	beaconing mode (AP, IBSS, Mesh, ...).
>> + * @WIPHY_FLAG_OFFCHAN_CAC: Device supports offchannel CAC.
>
> I think this should be an nl80211 feature flag, so that userspace can
> also know whether or not this is supported.
>
> However, we've run out of nl80211 feature flags. Arend is working on
> adding more, see here:
> http://mid.gmane.org/1418935344-22159-1-git-send-email-arend@broadcom.com
> (ignore the 4-way-HS offload bit he's defining)
>
> I'm not sure how to proceed here - in a sense your feature flag is far
> less controversial and work-intensive than Arend's (who needs a lot more
> than just that patch) so I guess you could pick up his patch, but I
> expect him to also have fixed already. He's probably also on vacation
> for about the same time though...

Not on vacation just yet. I indeed reworked the patch, but I was waiting 
for wpa_supplicant patches so I can verify it works with brcmfmac. I can 
submit the reworked feature flag patch with empty enum if that would work.

Regards,
Arend

> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

