Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36734 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaDTGGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 02:06:17 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so836862wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 23:06:15 -0700 (PDT)
Message-ID: <535363D5.4070708@gmail.com> (sfid-20140420_080651_369630_3388EB10)
Date: Sun, 20 Apr 2014 09:06:13 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Alexander Monakov <amonakov@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi null pointer dereference
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>	<5350B340.9020201@gmail.com>	<53512D04.5070808@gmail.com>	<CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>	<53513BC4.7020502@gmail.com> <CABtfrpDcZq=Ss=Zv9u0P3vz1D8rmgJ_jXGut-kZ0tkOmDZq9aw@mail.gmail.com>
In-Reply-To: <CABtfrpDcZq=Ss=Zv9u0P3vz1D8rmgJ_jXGut-kZ0tkOmDZq9aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On 04/18/2014 11:33 PM, Alexander Monakov wrote:
> On Fri, Apr 18, 2014 at 6:50 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>> I have to say that this is really strange - I must miss something. It looks like the ISR is called even before it is requested...
>>>> So I definitely want to understand what is happening here before applying the fix.
>>>
>>> Sure, I can help with further investigation.  Would it help if I bisected?
>>>
>>
>> I can't decline such an offer:)
>>
>> Note that the "bad" commit might be in pci too.
>> As a first try, I'd try 3.13.
>> I've made quite a few changes in the ISR for 3.14.
> 
> It bisects to
> 
> commit 2dbc368d7fded35ed221a3751405b15e06eb8925
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Mon Dec 9 11:09:47 2013 +0200
> 
>     iwlwifi: pcie: track interrupt mask in SW
> 

Yeah - ok.
Thank you for this information.
I'll check again later.
