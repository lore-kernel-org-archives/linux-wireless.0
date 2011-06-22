Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54661 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1FVLyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 07:54:03 -0400
Received: by qyk29 with SMTP id 29so2643339qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 04:54:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308736869.3883.13.camel@jlt3.sipsolutions.net>
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	<BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	<1308736869.3883.13.camel@jlt3.sipsolutions.net>
Date: Wed, 22 Jun 2011 13:54:02 +0200
Message-ID: <BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com> (sfid-20110622_135408_414922_FA4B1621)
Subject: Re: about RCU programming
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your answer. I have actually read some articles like this ones:

http://lwn.net/Articles/262464/
http://lwn.net/Articles/263130/

I think I understood how I should normally use it, but not how it
really works. I found lots of code snippets in internet and it seems
to be very easy to use, but when I try to get more information it gets
more complicated. Although the code is wrong, do you think it could be
possible what I want to do? I mean, could it be possible in theory to
"shift" the header in order to make a ring buffer.

Anyway I will try to get more information about the linked list and
RCU. I have a lot of things to learn!! :)

Best regards and thank you again



2011/6/22 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2011-06-22 at 11:15 +0200, Manuel Sáez wrote:
>
>> and the read side:
>> rcu_read_lock();
>> rcu_derreference(sdata->u.ap.polling_list->sta);
>> copy_sta(sdata->u.ap.polling_list->sta);
>> rcu_read_unlock();
>>
>> sdata->u.ap.polling_list = sdata.u.ap.polling_list->next;
>
> This code snippet makes no sense at all. I suggest you read up on how
> RCU works first.
>
> johannes
>
>
