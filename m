Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38578 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaDRUdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 16:33:14 -0400
Received: by mail-ie0-f175.google.com with SMTP id to1so1919684ieb.6
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 13:33:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53513BC4.7020502@gmail.com>
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>
	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>
	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com>
	<CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com>
	<5350B340.9020201@gmail.com>
	<53512D04.5070808@gmail.com>
	<CABtfrpB440bsy7xDu1pdTu2zM+ZJHLDQKb4MLaMRf4hnVXBsNQ@mail.gmail.com>
	<53513BC4.7020502@gmail.com>
Date: Sat, 19 Apr 2014 00:33:13 +0400
Message-ID: <CABtfrpDcZq=Ss=Zv9u0P3vz1D8rmgJ_jXGut-kZ0tkOmDZq9aw@mail.gmail.com> (sfid-20140418_223340_662750_77D47C4C)
Subject: Re: iwlwifi null pointer dereference
From: Alexander Monakov <amonakov@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2014 at 6:50 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> I have to say that this is really strange - I must miss something. It looks like the ISR is called even before it is requested...
>>> So I definitely want to understand what is happening here before applying the fix.
>>
>> Sure, I can help with further investigation.  Would it help if I bisected?
>>
>
> I can't decline such an offer:)
>
> Note that the "bad" commit might be in pci too.
> As a first try, I'd try 3.13.
> I've made quite a few changes in the ISR for 3.14.

It bisects to

commit 2dbc368d7fded35ed221a3751405b15e06eb8925
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Mon Dec 9 11:09:47 2013 +0200

    iwlwifi: pcie: track interrupt mask in SW
