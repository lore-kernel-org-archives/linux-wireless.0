Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:58717 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZBPINf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:13:35 -0500
Received: by gxk22 with SMTP id 22so2805998gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 00:13:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234695526.4219.46.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-5-git-send-email-lrodriguez@atheros.com>
	 <1234695526.4219.46.camel@johannes.local>
Date: Mon, 16 Feb 2009 00:13:33 -0800
Message-ID: <43e72e890902160013q48912fa1if1db7155e4fee1f1@mail.gmail.com> (sfid-20090216_091355_894983_518B35CC)
Subject: Re: [PATCH 04/10] nl80211: disallow user requests prior to
	regulatory_init()
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 2:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>> If cfg80211 is built into the kernel there is perhaps a small
>> time window betwen nl80211_init() and regulatory_init() where
>> cfg80211_regdomain hasn't yet been initialized to let the
>> wireless core do its work. During that rare case and time
>> frame (if its even possible) we don't allow user regulatory
>> changes as cfg80211 is working on enabling its first regulatory
>> domain.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/nl80211.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index db973f2..6f4dedb 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -1876,6 +1876,15 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>>       int r;
>>       char *data = NULL;
>>
>> +     /*
>> +      * You should only get this when cfg80211 hasn't yet initialized
>> +      * completely when built-in to the kernel right between the time
>> +      * window between nl80211_init() and regulatory_init(), if that is
>> +      * even possible.
>> +      */
>> +     if (!cfg80211_regdomain)
>> +             return -EINPROGRESS;
>> +
>
> But that variable access here is racy too.

Right.

> It might be ok anyway because
> the variable can never be NULL again after the first assignment

That's what I was going for.

>  but in
> that case the assignment needs to take care to assign something fully
> created ...

Can you elaborate on what you mean?

  Luis
