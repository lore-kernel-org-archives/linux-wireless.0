Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:35080 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbZKEEzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 23:55:06 -0500
Received: by qyk4 with SMTP id 4so3709674qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 20:55:10 -0800 (PST)
Message-ID: <4AF25AA6.60606@gmail.com>
Date: Wed, 04 Nov 2009 23:55:02 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	"John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <200911041630.20122.chunkeey@googlemail.com> <20091104164938.GG12965@tuxdriver.com> <200911042214.54230.herton@mandriva.com.br> <4AF239A6.5050406@lwfinger.net>
In-Reply-To: <4AF239A6.5050406@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 11/04/2009 06:14 PM, Herton Ronaldo Krzesinski wrote:
>   
>> Hi, I checked here and the code above in led_classdev_unregister is the same in
>> 2.6.31, so I think the patch from Larry should also be applied/sent to 2.6.31.x
>> stable, as the bug could happen there too.
>>     
>
> Herton,
>
> Technically you are correct; however, I did extensive testing of
> 2.6.31 and _NEVER_ got the failure. The sequencing is a bug waiting to
> happen, but something in the post 2.6.31 merge actually enabled the
> bug to happen. I tried bisection to determine which change actully did
> that, but was not successful.
>
>   
Using kernel 2.6.29 and compat-wireless-stable 2.6.31* I am able to make 
it flake.  I may be the only one lucky enough to make this explode with 
a high degree of accuracy but I can't see why we wouldn't fix what we 
know is a bug waiting to happen.  My vote is to add this patch to 
2.6.31.x as well.

Thanks,
Rick Farina
> My feeling is that stable can be left alone. Of course, if bug reports
> of kernel panics on unload of rtl8187 start occurring, we will know
> how to fix it.
>
> Larry
>
>   

