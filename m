Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:45144 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752548AbeC2LMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 07:12:55 -0400
Received: by mail-qt0-f177.google.com with SMTP id f8so5770341qtg.12
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 04:12:55 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
To: Johannes Berg <johannes@sipsolutions.net>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
 <1512990779.26976.69.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABCCA33.8070501@broadcom.com> (sfid-20180329_131312_679481_E3E6908E)
Date: Thu, 29 Mar 2018 13:12:51 +0200
MIME-Version: 1.0
In-Reply-To: <1512990779.26976.69.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Picking up a somewhat old thread as I did not see a follow-up on this 
patch. I got queried about it over here by our FILS team. So what is 
needed for this patch to pass the bar?

On 12/11/2017 12:12 PM, Johannes Berg wrote:
> On Wed, 2017-10-25 at 14:50 +0530, Vidyullatha Kanchanapally wrote:
>
>> + * @UPDATE_FILS_ERP_INFO: Indicates that FILS connection parameters (realm,
>> + *	username, erp sequence number and rrk) are updated
>> + * @UPDATE_AUTH_TYPE: Indicates that Authentication type is updated
>
> These are new here, but you don't know if they were actually supported:
>
>> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
>> +				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
>
> here.

The description of the FILS_SK_OFFLOAD currently says:

  * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS 
shared key
  *      authentication with %NL80211_CMD_CONNECT.

Are you suggesting a new flag to cover the new update attributes?

Drivers reporting FILS_SK_OFFLOAD *and* WIPHY_FLAG_SUPPORTS_FW_ROAM 
really need this info to have any luck roaming.

>> +	    info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] &&
>> +	    info->attrs[NL80211_ATTR_FILS_ERP_REALM] &&
>> +	    info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] &&
>> +	    info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
> [...]
>> +	} else if (info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] ||
>> +		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
>> +		   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] ||
>> +		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
>> +		return -EINVAL;
>> +	}
>
> This logic is also really odd, why not
>
> if (attrs) {
> 	if (not flag)
> 		return -EINVAL;
> 	/* use attrs etc. */
> }
>
>> +
>> +	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
>> +		u32 auth_type =
>> +			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
>> +		if (!nl80211_valid_auth_type(rdev, auth_type,
>> +					     NL80211_CMD_CONNECT))
>> +			return -EINVAL;
>> +		connect.auth_type = auth_type;
>> +		changed |= UPDATE_AUTH_TYPE;
>> +	}
>
> Again, how do you know the driver will actually look at
> UPDATE_AUTH_TYPE?

If they don't they are broken, right? And if they are broken, the 
connection will drop and regular connect will happen anyway, no?

We could add a new flag to signal driver will handle the extra 
parameters in UPDATE_CONNECT_PARAMS, but it is not clear why it would be 
needed. Seems to me user-space has all the info needed with the existing 
flag(s).

Regards,
Arend
