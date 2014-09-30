Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3699 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaI3OFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 10:05:21 -0400
Message-ID: <542AB893.9090201@broadcom.com> (sfid-20140930_160527_245481_91DF6F84)
Date: Tue, 30 Sep 2014 16:05:07 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	<linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: allow to configure dynamic PS timeout
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com> <542AB859.5080008@broadcom.com>
In-Reply-To: <542AB859.5080008@broadcom.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-09-14 16:04, Arend van Spriel wrote:
> On 30-09-14 15:18, Stanislaw Gruszka wrote:
>> Dynamic power save timeout value is suppose to be configurable via
>> wext, but due to iwconfig bug is not possible to set it using that tool.
>>
>> Allow to configure PS timeout via nl80211 - add NL80211_ATTR_PS_TIMEOUT
>> attribute which become timeout stated in ms.
>>
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> ---
>>  include/uapi/linux/nl80211.h |  2 ++
>>  net/wireless/nl80211.c       | 21 +++++++++++++++++----
>>  2 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 4b28dc0..600d47b 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -1990,6 +1990,8 @@ enum nl80211_attrs {
>>  
>>  	NL80211_ATTR_SMPS_MODE,
>>  
>> +	NL80211_ATTR_PS_TIMEOUT,
>> +
> 
> Isn't there some doxygen comment where this new attribute should be
> described?

Uuuhmm, I mean kerneldoc, of course!

> Regards,
> Arend
> 

