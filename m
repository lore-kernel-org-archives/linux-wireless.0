Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38399 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbEaJ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:56:31 -0400
Received: by wizo1 with SMTP id o1so71122815wiz.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:56:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556AB128.3050909@gmail.com>
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com> <556AB128.3050909@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 31 May 2015 15:26:09 +0530
Message-ID: <CABPxzYLfddWNw2iED=H8FbRReyAj3v+9GG4QEZDQuE8N9vejxw@mail.gmail.com> (sfid-20150531_115637_299916_AEF39CD2)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2015 at 12:28 PM, Arend van Spriel <aspriel@gmail.com> wrote:
> On 31-05-15 01:28, Chaitanya T K wrote:
>> cfg80211 reuses the skb before asking for a fresh on from genl framework,
>> this works efficiently for smaller messages but NLM_F_DUMP is normally
>> used to transport larger data normally > PAGE_SIZE, so if the message
>> occupies more than GOODSIZE its better to ask for a new, saves couple
>> of hanshakes with the driver.
>>
>> This improves the time to get the DUMP response across to user space.
>> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
>> ---
>> V2: no new line, so commit log was cut off. Updated now.
>> ---
>>  net/wireless/nl80211.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index c264eff..152bd0c 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -7636,6 +7636,10 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
>>               }
>>
>>               genlmsg_end(skb, hdr);
>> +
>> +             /* Don't re-use skb, when we know nla_put fails*/
>
> After reading the commit message this comment is not clear to me. Maybe
> it is just me ;-)
>
>> +             if (skb->len > NLMSG_GOODSIZE / 2)
>
> This definitely does not match the description in the commit message:
> 'message occupies more than GOODSIZE' != (skb->len > NLMSG_GOODSIZE / 2)
We need to find a threshold where smaller messages still get
aggregated in the same
skb where as larger messages save an extra handshake and request for
another skb.

So this threshold would be NLMSG_GOODSIZE/2. Assuming messages are equal size
except for the last one and if one message is > NLMSG_GOODSIE/2, we
cannot fit another
message in the same skb.



-- 
Thanks,
Regards,
Chaitanya T K.
