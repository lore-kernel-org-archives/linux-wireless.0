Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2667 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965219Ab3DPVTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 17:19:20 -0400
Message-ID: <516DC04D.9090204@broadcom.com> (sfid-20130416_231924_724087_ACAA5AED)
Date: Tue, 16 Apr 2013 23:19:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V6] cfg80211: introduce critical protocol indication
 from user-space
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
 <1365676794-24717-1-git-send-email-arend@broadcom.com>
 <1366121523.8244.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366121523.8244.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2013 04:12 PM, Johannes Berg wrote:
>
>
>> I reworked the patch based on your comment in this V6. It
>> applies to the master branch on top of commit:
>>
>> 5253ffb mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates
>
> Yep, applies, thanks. I think you missed something, I can fix it but
> wanted to ask:
>
>
>> + * @crit_proto_started: true if crit_proto_start() has been done.
>>    */
>>   struct wireless_dev {
>
>> +	bool crit_proto_started;
>
> This is no longer needed, right?
>

oops. That should go indeed.

>> +	NL80211_CMD_CRIT_PROTOCOL_START,
>> +	NL80211_CMD_CRIT_PROTOCOL_STOP,
>> +	NL80211_CMD_CRIT_PROTOCOL_STOPPED_EVENT,
>
> Why use a separate command ID? Usually we use the same _STOP for the
> event as well, I think? Except maybe scan which you can't stop? Not
> sure ... Anyway I don't mind, just wondering if there was a special
> reason to do this.
>

This is my first nl80211 event :-) I looked at the ft_event thingy. I am 
fine using the _STOP instead.

>> + nla_put_failure:
>> +	if (hdr)
>> +		genlmsg_cancel(msg, hdr);
>
> There's not really a reason to cancel, but we still do most of the time.
> I guess we can keep it, but it doesn't matter :)

If it not really needed it may call for separate patch removing all 
occurrences?

>> --- a/net/wireless/rdev-ops.h
>> +++ b/net/wireless/rdev-ops.h
>> @@ -875,7 +875,7 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
>>   	trace_rdev_stop_p2p_device(&rdev->wiphy, wdev);
>>   	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
>>   	trace_rdev_return_void(&rdev->wiphy);
>> -}					
>> +}
>
> Heh, thanks.

Have to thank my editor, I guess. Trailing whitespace?

Gr. AvS

