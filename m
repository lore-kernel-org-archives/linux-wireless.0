Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:26268 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYHHRbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 13:31:09 -0400
Received: by an-out-0708.google.com with SMTP id d40so176720and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2008 10:31:07 -0700 (PDT)
Message-ID: <43e72e890808081031g150fa096n89215b86269046a9@mail.gmail.com> (sfid-20080808_193114_264474_04C30BD6)
Date: Fri, 8 Aug 2008 10:31:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: N protocol on 802.11a freq signal strength
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890808080949l1ee7a392m784fe06a3611e9ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080808141616.GA26224@bromo.msbb.uc.edu>
	 <43e72e890808080949l1ee7a392m784fe06a3611e9ba@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 8, 2008 at 9:49 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Aug 8, 2008 at 7:16 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>>    After replacing my Linksys WRT150N wireless router with an
>> Apple Airport Extreme Gigabit ethernet wireless router, configured
>> for using the N protocols on the 802.11a wireless frequencies, I
>> can confirm that the ath9k git from last week connects to this
>> configuration. I have noticed one oddity though. The reported
>> signal strength (in the NetworkManager menu bar icon) is significantly
>> lower than that shown under Mac OS X 10.5.
>
> The link quality we report right now should be lower than the real
> one. We will enhance this later but rest assured its the same.
>
>> Also, I notice under Mac OS X
>> 10.5, by holding the option key on the Finder's Airport icon, that the
>> transmit speed is 300 Mbps when the MacBook Pro is in the same room as
>> the wireless router but only 108 Mbps when a couple rooms away. Should
>> the ath9k report such dynamic changes in transmit speed? Under Mac OS X
>> that transmit speed changes as I move the portable back and forth
>> between the two locations. Thanks in advance for any information.
>
> Keep in mind 2.6.27 has aggregation disabled right now due to the new
> TX MQ changes so you won't be able to get aggregation going for any
> 11n wireless device. That said, I am not familiar with the Mac OS X
> option key thingy to compute throughput. If you can provide technical
> details as to how it computes it or where it does this (AP or STA) it
> can help.

OK it just seems its calculated based on the HT params (HT40, short
guard interval) and the rate used. So in your case its probably just
that a lower rate is being used by the rate control algorithm. Is
suspect we'll get better performance at longer distances once ANI is
integrated which is on our TODO list.

  Luis
