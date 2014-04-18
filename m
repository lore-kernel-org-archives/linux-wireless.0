Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:64593 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaDROus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 10:50:48 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so1622960wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 07:50:46 -0700 (PDT)
Message-ID: <53513BC4.7020502@gmail.com> (sfid-20140418_165057_881109_BD76F08C)
Date: Fri, 18 Apr 2014 17:50:44 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Alexander Monakov <amonakov@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi null pointer dereference
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>	<5350B340.9020201@gmail.com>	<53512D04.5070808@gmail.com> <CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>
In-Reply-To: <CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/18/2014 05:34 PM, Alexander Monakov wrote:
> On Fri, Apr 18, 2014 at 5:47 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>
>> On 04/18/2014 08:08 AM, Emmanuel Grumbach wrote:
>>> Hi,
>>>
>>> On 04/17/2014 11:56 PM, Alexander Monakov wrote:
>>>> Emmanuel,
>>>>
>>>> I'm curious about the plans w.r.t this fix; is it going to
>>>> iwlwifi-next.git?  Thanks again.
>>>>
>>>
>>> It will go to iwlwifi-fixes.
>>>
>>
>> I have to say that this is really strange - I must miss something. It looks like the ISR is called even before it is requested...
>> So I definitely want to understand what is happening here before applying the fix.
> 
> Sure, I can help with further investigation.  Would it help if I bisected?
> 

I can't decline such an offer:)

Note that the "bad" commit might be in pci too.
As a first try, I'd try 3.13.
I've made quite a few changes in the ISR for 3.14.
