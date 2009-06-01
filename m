Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49134 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZFAHjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 03:39:42 -0400
Received: by ewy24 with SMTP id 24so7631636ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 00:39:43 -0700 (PDT)
Message-ID: <4A2385FD.1090808@tuffmail.co.uk>
Date: Mon, 01 Jun 2009 08:40:45 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243524688.10632.0.camel@johannes.local>	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>	 <1243778069.5299.0.camel@johannes.local>	 <1243796628.6570.37.camel@localhost.localdomain> <1243841263.5299.2.camel@johannes.local>
In-Reply-To: <1243841263.5299.2.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-05-31 at 21:03 +0200, Marcel Holtmann wrote:
>
>   
>>> Maybe we should add an ioctl that disables rfkill-input if present.
>>>       
>> I am against it. Can we just add a module parameter that allows us to
>> disable it. I am against cluttering a new interface with legacy stuff
>> since we are removing rfkill-input and replacing it by rfkilld anyway in
>> a near future (meaning when I am back from vacation).
>>     
>
> Right. But you'll get a bunch of people get it mixed up. I think I would
> prefer adding the ioctl, but having it only when rfkill-input is
> compiled in, so userspace would always just get -ENOSYS if there's no
> rfkill-input present, which means the "cluttering" of the interface
> occurs only for as long as we have rfkill-input and at some point you
> would just remove that one line of code from rfkilld.
>
> johannes
>   

Yeah, that's much better.  If you had a module parameter then you would 
have to keep it around, even after the removal of the kernel 
rfkill-input.  Otherwise people have to change modprobe.conf _again_ 
when they upgrade the kernel, because rfkill-as-module will refuse to load.

Thanks
Alan
