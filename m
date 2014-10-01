Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43828 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAQnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 12:43:07 -0400
Message-ID: <542C2F19.4080609@candelatech.com> (sfid-20141001_184312_207055_28FF1D0B)
Date: Wed, 01 Oct 2014 09:43:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  support configuring vdev mac addr on create.
References: <1412102605-3638-1-git-send-email-greearb@candelatech.com> <542BBCD6.4030208@broadcom.com>
In-Reply-To: <542BBCD6.4030208@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2014 01:35 AM, Arend van Spriel wrote:
> On 09/30/14 20:43, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This is useful when creating virtual-stations, and probably
>> APs and other devices as well.  Keeps udev from mucking with
>> things it shouldn't, since the default MAC is never seen
>> by udev when specified on the cmd-line during creation.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>   include/net/cfg80211.h       | 6 +++---
>>   include/uapi/linux/nl80211.h | 3 +++
>>   net/mac80211/iface.c         | 5 ++++-
>>   net/mac80211/main.c          | 1 +
>>   net/wireless/nl80211.c       | 2 +-
>>   5 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index e1641e6..de9a67f 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -319,9 +319,9 @@ struct ieee80211_supported_band {
>>   /**
>>    * struct vif_params - describes virtual interface parameters
>>    * @use_4addr: use 4-address frames
>> - * @macaddr: address to use for this virtual interface. This will only
>> - *     be used for non-netdevice interfaces. If this parameter is set
>> - *     to zero address the driver may determine the address as needed.
>> + * @macaddr: address to use for this virtual interface.
>> + *     If this parameter is set to zero address the driver may
>> + *    determine the address as needed.
>>    */
>>   struct vif_params {
>>          int use_4addr;
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 4b28dc0..fd14703 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -4042,6 +4042,8 @@ enum nl80211_ap_sme_features {
>>    *    multiplexing powersave, ie. can turn off all but one chain
>>    *    and then wake the rest up as required after, for example,
>>    *    rts/cts handshake.
>> + * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
>> + *    the vdev's MAC address upon creation.
>>    */
>>   enum nl80211_feature_flags {
>>       NL80211_FEATURE_SK_TX_STATUS            = 1<<  0,
>> @@ -4070,6 +4072,7 @@ enum nl80211_feature_flags {
>>       NL80211_FEATURE_ACKTO_ESTIMATION        = 1<<  23,
>>       NL80211_FEATURE_STATIC_SMPS            = 1<<  24,
>>       NL80211_FEATURE_DYNAMIC_SMPS            = 1<<  25,
>> +    NL80211_FEATURE_MAC_ON_CREATE            = 1<<  26,
> 
> Hi Ben,
> 
> It is unclear to me why this should be ap_sme feature flag. As your description indicates this is a device feature/capability so it seems more appropriate that
> this would be a wiphy flag.

I think that is just patch getting confused, the actual change is to
this enum:   nl80211_feature_flags

>>           ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
>> -        memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
>> +        if (params&&  !is_zero_ether_addr(params->macaddr))
> 
> I would expect checkpatch will complain on these whitespace errors. Also would be better to use is_valid_ether_addr() to assure it is not a multicast/broadcast
> address.

I do not see that whitespace problem in the patch I posted.

I will change it to is_valid_ether_addr as you suggested.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

