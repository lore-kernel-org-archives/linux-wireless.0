Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:34366 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965276AbdDZSpC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 14:45:02 -0400
Received: by mail-qt0-f173.google.com with SMTP id c45so8458605qtb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 11:45:02 -0700 (PDT)
Subject: Re: [PATCH 5/9] cfg80211/nl80211: add authorized flag to roaming
 event
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
References: <20170426075854.13546-1-luca@coelho.fi>
 <20170426075854.13546-6-luca@coelho.fi>
 <30808bad-1f15-20bd-9bfe-0c10ab8555cd@broadcom.com>
Cc: johannes@sipsolutions.net, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>, Jouni Malinen <j@w1.fi>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fd5269e4-18f1-a8cc-961d-33ef54c90539@broadcom.com> (sfid-20170426_204616_305475_1C5EFA46)
Date: Wed, 26 Apr 2017 20:44:58 +0200
MIME-Version: 1.0
In-Reply-To: <30808bad-1f15-20bd-9bfe-0c10ab8555cd@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Jouni

On 26-4-2017 12:05, Arend van Spriel wrote:
> Almost overlooked this one. Thanks for the hint, Johannes.
> 
> On 4/26/2017 9:58 AM, Luca Coelho wrote:
>> From: Avraham Stern <avraham.stern@intel.com>
>>
>> Drivers that initiate roaming while being connected to a network that
>> uses 802.1X authentication need to inform user space if 802.1X
>> authentication is further required after roaming.
>> For example, when using the Fast transition protocol, roaming within
>> the mobility domain does not require new 802.1X authentication, but
>> roaming to another mobility domain does.
> 
> Not sure about the terminology here. Is "mobility domain" the same as
> "ESS" which stands for extended service set as definced in 802.11
> standard. If so, I would prefer use of that term here.
> 
>> In addition, some drivers may not support 802.1X authentication
>> (so it has to be done in user space), while other drivers do.
>>
>> Add a flag to the roaming notification to indicate if user space is
>> required to do 802.1X authentication after the roaming or not.
>> This flag will only be used for networks that use 802.1X
>> authentication. For networks that do not use 802.1X authentication it
>> is assumed that no further action is required from user space after
>> the roaming notification.
>>
>> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
>> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> ---
>>   include/net/cfg80211.h       |  4 ++++
>>   include/uapi/linux/nl80211.h | 14 ++++++++++++++
>>   net/wireless/nl80211.c       |  4 +++-
>>   net/wireless/sme.c           |  1 +
>>   4 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 115f6fc5a34d..f9f4fde2dc09 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -5384,6 +5384,9 @@ cfg80211_connect_timeout(struct net_device *dev,
>> const u8 *bssid,
>>    * @req_ie_len: association request IEs length
>>    * @resp_ie: association response IEs (may be %NULL)
>>    * @resp_ie_len: assoc response IEs length
>> + * @authorized: true if the 802.1X authentication was done by the
>> driver or is
>> + *    not needed (e.g., when Fast Transition protocol was used), false
>> + *    otherwise. Ignored for networks that don't use 802.1X
>> authentication.
> 
> It is not ignored in this patch so it is expected user-space behavior
> you are describing, which is not really needed here in cfg80211 driver api.
> 
>>    */
>>   struct cfg80211_roam_info {
>>       struct ieee80211_channel *channel;
>> @@ -5393,6 +5396,7 @@ struct cfg80211_roam_info {
>>       size_t req_ie_len;
>>       const u8 *resp_ie;
>>       size_t resp_ie_len;
>> +    bool authorized;
>>   };
>>     /**
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 6095a6c4c412..7bdbce7c4147 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -546,6 +546,12 @@
>>    *    well to remain backwards compatible.
>>    * @NL80211_CMD_ROAM: request that the card roam (currently not
>> implemented),
> 
> Do we want to keep this comment about the request scenario. Is it likely
> implemented soon/ever?
> 
>>    *    sent as an event when the card/driver roamed by itself.
>> + *    When used as an event, and the driver roamed in a network that
>> requires
>> + *    802.1X authentication, %NL80211_ATTR_CONNECTION_AUTHORIZED
>> should be set
>> + *    if the 802.1X authentication was done by the driver or if
>> roaming was
>> + *    done using Fast Transition protocol (in which case 802.1X
>> authentication
>> + *    is not needed). If %NL80211_ATTR_CONNECTION_AUTHORIZED is not set,
>> + *    user space is responsible for the 802.1X authentication.
> 
> Would you consider using NL80211_ATTR_PORT_AUTHORIZED instead referring
> to the 802.1X port entities.

In wpa_supplicant the function mlme_event_connect() is used to process
NL80211_CMD_CONNECT and NL80211_CMD_ROAM events. The latter is actually
used for processing QCA vendor specific event, which passes a nlattr
called authorized to the function. It is typed as u8:

	if (authorized && nla_get_u8(authorized)) {
		event.assoc_info.authorized = 1;
		wpa_printf(MSG_DEBUG, "nl80211: connection authorized");
	}

Not really a good argument, but choosing the same type for the new
attribute would make supporting it relatively easy.

Regards,
Arend
