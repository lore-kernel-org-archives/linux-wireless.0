Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:5203 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZG3Q4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:56:39 -0400
Received: by rv-out-0506.google.com with SMTP id f6so453053rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 09:56:39 -0700 (PDT)
Message-ID: <4A71D172.1000306@gmail.com>
Date: Thu, 30 Jul 2009 12:59:30 -0400
From: Roman Macko <rmacko72@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net> 	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com> 	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com> 	<4A719C44.6050208@gmail.com> <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com>
In-Reply-To: <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I tested it. When you place that config file containing "search 
updates built-in" in /etc/depmod.d
directory, it doesn't work. You have to place it in global config file 
/etc/depmod.conf.

How depmod works with config files in /etc/depmod.d directory is a 
mystery for me. I wasn't able to learn
this from manual pages.

And I tested another thing too. When some of config files (either global 
/etc/depmod.conf or one of those in /etc/depmod.d directory)
doesn't contain search command ,
everything works fine, according to manual page for depmod, using 
builtin search string "updates built-in" what  is
what you need. As soon as one of them (either global or one of those in 
/etc/depmod.d directory) contains search command,
then depmod uses this one. It seems seach command in global config file 
(/etc/depmod.conf) has higher priory. But as I say
I really don't know how depmod works with all config files.

roman

Luis R. Rodriguez wrote:
> On Thu, Jul 30, 2009 at 6:12 AM, Roman Macko<rmacko72@gmail.com> wrote:
>   
>> Luis,
>>
>> I used stable version 2.6.30.
>> Anyway I downloaded bleeding edge version and ran script check_depmod.
>> But it created new configuration in /etc/depmod.d directory instead of
>> creating
>> global configuration /etc/depmod.conf what I did. It doesn't work in that
>> way.
>>     
>
> What do you mean it doesn't work that way?
> Do you mean you tested it and that it didn't work?
>
>   
>> I can read in manual pages of depmod.conf that depmod.d directory serves for
>> configuration on per-module basis,
>> so I think you can change the order of proceding directories for particular
>> module only there.
>>     
>
> Nope. Even Ubuntu uses their own file in there for the same purpose:
>
> mcgrof@tux ~ $ cat /etc/depmod.d/ubuntu.conf
> search updates ubuntu built-in
>
>   
>> But I don't know how to name that file or if my thought is right at all.
>>     
>
> The man page needs some updating.
>
>   Luis
>   

