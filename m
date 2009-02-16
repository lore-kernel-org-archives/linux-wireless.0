Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:41269 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZBPJsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:48:02 -0500
Received: by gxk22 with SMTP id 22so2840772gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:48:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234696212.4219.60.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
	 <1234696212.4219.60.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:48:00 -0800
Message-ID: <43e72e890902160148n5a383a96t8e20dc4bc9d10687@mail.gmail.com> (sfid-20090216_104807_928808_018CB341)
Subject: Re: [PATCH 09/10] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 3:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -396,6 +396,7 @@ enum environment_cap {
>>   *   country IE
>>   * @country_ie_env: lets us know if the AP is telling us we are outdoor,
>>   *   indoor, or if it doesn't matter
>> + * @list: used to insert into a linked list
>
> I wouldn't mind it explaining which list ;)
>
>> +static LIST_HEAD(reg_requests_list);
>> +static DEFINE_MUTEX(reg_mutex);
>> +
>> +static void reg_process_pending_hints(void);
>
> can you reorder the code in a way that doesn't require forward
> declarations?
>
>> +/* This currently only processes user and driver regulatory hints */
>> +static int reg_process_hint(struct regulatory_request *reg_request)
>> +{
>
> why bother offloading _user_ hints to a workqueue? That seems a little
> pointless since we can sleep there and do whatever.

True, I'd like to use the workqueue for all reg requests though.

> OTOH, maybe _all_
> should be offloaded so the order is correct?

Yeah I think this would be better but regulatory_hint_11d() wasn't so
trivial to move to it so I think as a first step moving these two is a
good start. You do have a good point about the order but since the
only other case that could be out of order is when we process 11d I
don't see it that bad to process a reg hint during association over a
user hint -- for now. Unless that trade off is unacceptable.

>> +static void reg_process_pending_hints(void)
>> +     {
>> +     struct regulatory_request *reg_request, *tmp;
>> +     int r;
>> +
>> +     mutex_lock(&reg_mutex);
>> +     list_for_each_entry_safe(reg_request, tmp, &reg_requests_list, list) {
>> +             r = reg_process_hint(reg_request);
>> +             if (r)
>> +                     printk(KERN_ERR "cfg80211: wiphy_idx %d sent a "
>> +                             "regulatory hint but now has gone fishing, "
>> +                             "ignoring request\n", reg_request->wiphy_idx);
>
> pointless warning, it'll happen if somebody just inserts/unplugs very
> quickly on a loaded system.

How about under REG_DEBUG?

>> +             list_del(&reg_request->list);
>> +             kfree(reg_request);
>> +     }
>> +     mutex_unlock(&reg_mutex);
>> +}
>
> Are you sure the mutex order reg_mutex --> cfg80211_mutex is a good
> idea? Is there a need for two locks at all?

I think so. So reg_mutex would prevent any new requests to be added
into the queue, that's the only thing that mutex protects. Once you
are sure you have no one adding requests to the queue you then need to
ensure no one is processing a regulatory request and hence the
cfg80211_mutex.

We need to protect the queue from additions to the queue from having
the workqueue process it.

  Luis
