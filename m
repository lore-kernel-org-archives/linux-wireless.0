Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0042.outbound.protection.outlook.com ([104.47.34.42]:28016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752892AbeBULZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 06:25:32 -0500
Subject: Re: [PATCH] cfg80211/nl80211: add DFS offload flag
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
References: <20180221105635.5824-1-sergey.matyukevich.os@quantenna.com>
 <5A8D521C.2030502@broadcom.com>
From: Dmitrii Lebed <dlebed@quantenna.com>
Message-ID: <0e3d5af0-bc6b-d98f-02f2-cc4d585e6cd1@quantenna.com> (sfid-20180221_122537_796118_77EECC76)
Date: Wed, 21 Feb 2018 14:25:18 +0300
MIME-Version: 1.0
In-Reply-To: <5A8D521C.2030502@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 21.02.2018 14:03, Arend van Spriel wrote:
> On 2/21/2018 11:56 AM, Sergey Matyukevich wrote:
>> From: Dmitry Lebed <dlebed@quantenna.com>
>>
>> Add wiphy flag to indicate that HW does all DFS actions by itself.
>> User-space functionality already implemented in hostapd using
>> vendor-specific (QCA) OUI to advertise HW support.
>> Need to introduce generic flag to inform about DFS offload support.
>> For deivces with DFS_OFFLOAD flag set user-space will no longer
>> need to issue CAC or do any actions in response to
>> "radar detected" events. HW will do everything by itself and send
>> events to user-space to idicate that CAC was started/finished, etc.
>>
>> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
>> ---
>>   include/net/cfg80211.h       | 7 ++++++-
>>   include/uapi/linux/nl80211.h | 9 +++++++++
>>   net/wireless/nl80211.c       | 7 +++++++
>>   3 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index ed3a28105d6c..b2d17993ae4d 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -3241,6 +3241,11 @@ struct cfg80211_ops {
>>    * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
>>    * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication
>> by routing
>>    *  auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
>> + * @WIPHY_FLAG_DFS_OFFLOAD: Device will do all DFS-related actions
>> by itself,
>> + *   informing user-space about CAC progress, radar detection event,
>> + *   channel change triggered by radar detection event.
>> + *   No need to start CAC from user-space, no need to react to
>> + *   "radar detected" event.
>
> wiphy flags are kinda deprecated. At least no new flags should be added.
> Instead use EXT_FEATURE flag.
>
> Regards,
> Arend
Thanks for clarification, Arend. I'll change it to use new EXT_FEATURE flag=
.
BTW, are there any concerns regarding adding generic DFS_OFFLOAD driver
capability?
I want to add DFS_OFFLOAD support to qtnfmac driver and fix hostapd to
support
generic EXT_FEATURE flag as well as vendor-specific capabilities.

Thanks,
Dmitrii
>
>>    * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming
>> feature in the
>>    *  firmware.
>>    * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
>


This email, including its contents and any attachment(s), may contain confi=
dential information of Quantenna Communications, Inc. and is solely for the=
 intended recipient(s). If you may have received this in error, please cont=
act the sender and permanently delete this email, its contents and any atta=
chment(s).
