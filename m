Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46848 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0HCCtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 22:49:04 -0400
Received: by pvc7 with SMTP id 7so1518143pvc.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 19:49:02 -0700 (PDT)
Message-ID: <4C5783AD.4060405@gmail.com>
Date: Mon, 02 Aug 2010 19:49:17 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, j@w1.fi, linville@tuxdriver.com,
	mcgrof@gmail.com
Subject: Re: [PATCH v3]hostap:hostap_ioctl.c Fix variable 'ret' set but not
 	used
References: <1280799971-7091-1-git-send-email-justinmattock@gmail.com> 	<AANLkTimmiraT1wV_=zxUmfKPz7D78uOdY4s67pVXOntA@mail.gmail.com> 	<4C577DB3.4050902@gmail.com> <AANLkTi=ZEKts2eW8KjvkNN0h5ogPkEwjfjbMYHjcjx+s@mail.gmail.com>
In-Reply-To: <AANLkTi=ZEKts2eW8KjvkNN0h5ogPkEwjfjbMYHjcjx+s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2010 07:31 PM, Julian Calaby wrote:
> On Tue, Aug 3, 2010 at 12:23, Justin P. Mattock<justinmattock@gmail.com>  wrote:
>> wait im lost.. looking at your patch looks the same(number wise) except I
>> see different parts of code in there:
>>
>> hostap_set_word(dev, HFA384X_RID_CNFROAMINGMODE,
>>                                 HFA384X_ROAMING_FIRMWARE);
>>
>> -       return 0;
>> +       return ret;
>>
>>
>>
>> mine is:
>>
>> printk(KERN_DEBUG "SCANREQUEST failed\n");
>> -               ret = -EINVAL;
>> +               return ret;
>>
>>
>> The tree Im using is Linus's tree.
>
> I'm using wireless-testing, and the line you're changing is #1692, I'm
> changing #1699.
>
> Thanks,
>


ahh.. so there's two return ret's that need to be added then..
(if so then go ahead and take my patch and add it to yours.. I'm off to 
other things)

cheers,

Justin P. Mattock
