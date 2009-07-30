Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:26158 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZG3NJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 09:09:46 -0400
Received: by qw-out-2122.google.com with SMTP id 8so775170qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 06:09:46 -0700 (PDT)
Message-ID: <4A719C44.6050208@gmail.com>
Date: Thu, 30 Jul 2009 09:12:36 -0400
From: Roman Macko <rmacko72@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net> 	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com> 	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
In-Reply-To: <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

I used stable version 2.6.30.
Anyway I downloaded bleeding edge version and ran script check_depmod.
But it created new configuration in /etc/depmod.d directory instead of 
creating
global configuration /etc/depmod.conf what I did. It doesn't work in 
that way.

I can read in manual pages of depmod.conf that depmod.d directory serves 
for configuration on per-module basis,
so I think you can change the order of proceding directories for 
particular module only there.
But I don't know how to name that file or if my thought is right at all.

Roman





Luis R. Rodriguez wrote:
> On Wed, Jul 29, 2009 at 2:57 PM, reinette
> chatre<reinette.chatre@intel.com> wrote:
>   
>> On Wed, 2009-07-29 at 14:53 -0700, Luis R. Rodriguez wrote:
>>     
>>> On Wed, Jul 29, 2009 at 2:45 PM, Linux
>>> Wireless<johannes@sipsolutions.net> wrote:
>>>       
>>>> Dear Wiki user,
>>>>
>>>> You have subscribed to a wiki page or wiki category on "Linux Wireless" for change notification.
>>>>
>>>> The "en/users/Download" page has been changed by ReinetteChatre:
>>>> http://wireless.kernel.org/en/users/Download?action=diff&rev1=93&rev2=94
>>>>
>>>>  }}}
>>>>  '''Install''':
>>>>
>>>> - We use the updates/ directory so your distribution's drivers are left intact.
>>>> + We use the updates/ directory so your distribution's drivers are left intact. By default depmod will search this directory first, but if you find that it does not then check that your depmod.conf file lists the search order correctly with ''updates'' appearing first (before ''built-in'').
>>>>         
>>> Hm, so compat-wireless now actually checks this for you and if its not
>>> there it adds it for you. Was there an issue with a particular user on
>>> this?
>>>       
>> Yes, a madriva user ran into this problem. See
>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2061#c6
>>     
>
> Roman, I added a little check for this, specifically since another
> user reported the same issue. Did you use bleeding edge
> compat-wireless?
>
> The script is in:
>
> scripts/check_depmod
>
> We run this at make install time.
>
> Can you run that manually?
>
>   Luis
>   

