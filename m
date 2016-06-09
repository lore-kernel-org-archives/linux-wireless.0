Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34870 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbcFIIgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:36:06 -0400
Received: by mail-wm0-f51.google.com with SMTP id v199so96485249wmv.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2016 01:36:04 -0700 (PDT)
Subject: Re: [PATCH] nl80211: avoid possible memleak on nl80211_set_reg
To: Johannes Berg <johannes@sipsolutions.net>,
	Eduardo Abinader <eabinader@ocedo.com>,
	linux-wireless@vger.kernel.org
References: <1465224967-26892-1-git-send-email-eduardo.abinader@riverbed.com>
 <1465459080.3442.2.camel@sipsolutions.net>
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a961b2ee-b4fa-dec9-72ed-f9b600fa51b2@broadcom.com> (sfid-20160609_103615_018102_7539095F)
Date: Thu, 9 Jun 2016 10:36:00 +0200
MIME-Version: 1.0
In-Reply-To: <1465459080.3442.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9-6-2016 9:58, Johannes Berg wrote:
> On Mon, 2016-06-06 at 16:56 +0200, Eduardo Abinader wrote:
>> Setting NULL just after freeing regdomain.
>>
>> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
>> ---
>>  net/wireless/nl80211.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index d120449..39d107d 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -5839,10 +5839,11 @@ static int nl80211_set_reg(struct sk_buff
>> *skb, struct genl_info *info)
>>  
>>  	r = set_regdom(rd, REGD_SOURCE_CRDA);
>>  	/* set_regdom took ownership */
>> -	rd = NULL;
>>  
>>   bad_reg:
>>  	kfree(rd);
>> +	rd = NULL;
> 
> To this I can only say: what?

The patch is bad, but the confusion starts with the original code
(ab)using kfree() behaviour by setting rd to NULL. Personally, I do not
like it, but prefer it over bugs ;-)

Regards,
Arend
