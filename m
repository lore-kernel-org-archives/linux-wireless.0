Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:62392 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZGaBR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 21:17:28 -0400
Received: by qyk34 with SMTP id 34so1276423qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 18:17:28 -0700 (PDT)
Message-ID: <4A7246D0.1040200@gmail.com>
Date: Thu, 30 Jul 2009 21:20:16 -0400
From: Roman Macko <rmacko72@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net> 	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com> 	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com> 	<4A719C44.6050208@gmail.com> <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com> 	<4A71D172.1000306@gmail.com> <43e72e890907301006p200032e0i11fdb40fc33fa6d0@mail.gmail.com>
In-Reply-To: <43e72e890907301006p200032e0i11fdb40fc33fa6d0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

I have version 3.6 of module-init-tools and this version reads 
/etc/depmod.d directory too.

But I wanted to understand how depmod reads config files, so I looked 
into source codes (both version 3.6 and 3.10)
and finally found out how it works.

Assume depmod is run without -C or --config option

Version 3.6 reads firstly /etc/depmod.conf file and then it reads config 
files in directory /etc/depmod.d.
Files in directory /etc/depmod.d are read and parsed in unpredictable 
order by readdir function (this function uses
raw directory structures of filesystem)

Version 3.10 reads /etc/depmod.conf firstly as well, but this config 
file is considered as deprecated in this version
and prints out warning about that. Then it reads config files in 
directory /etc/depmod.d by readdir function as well, but before it starts
to parse them, it sorts them accord to filename, so you know the order 
in which they are going to be parsed
and this is very improtant!!! This behavior should be from version 3.7

The same for both versions:
1) List of directories to be searched is created from search commands 
from all config files in order how particular
search commands are found in config files (so order of parsed config 
files is important). If no search command is found,
updates directory is added before "built-in" directory.

2) As for override command, the last one found for particular module and 
kernel in all config files wins,
 so again the order of parsed config files is important.

 From this is evident, that both versions can work differently which 
depends on the order of parsed config files from
/etc/depmod.d directory that is different in both versions.

So solution would be:
1) if there is no search command in any of config files (in 
/etc/depmod.conf  or those in /etc/depmod.d directory), do nothing.
2) if there is a search command in any of config files and does not 
contain updates directory before built-in add search command
    "search updates" in
   a) if system has version >=3.7, create config file in /etc/depmod.d 
directory which name is alphabeticaly less than all you will find
      in that directory
   b) if system has version <=3.6 add search command "search updates" at 
the begining of /etc/depmod.conf file

But such adding of "search updates" can break depmod configuration in 
some systems or it is not desirable to make search in
updates directory at all. So maybe it would be better to use another 
name for directory than updates

Or it would be also interesting to use override command for all modules 
compiled in compat-wireless
and put it all to configuration file /etc/depmod.d/compat-wireless.conf 
and not bothering with version of depmod nor
finding the search command in all configuration files, e.g

compat-wireless.conf
======================================
override iwlagn * updates/drivers/net/wireless/iwlwifi
override iwlcore * updates/drivers/net/wireless/iwlwifi
....
....
....
======================================

it can make problem only when some other config file in /etc/depmod.d 
directory contains override command for
any module from compat-wireless


I hope this help you

Regards

Roman

Luis R. Rodriguez wrote:
> On Thu, Jul 30, 2009 at 9:59 AM, Roman Macko<rmacko72@gmail.com> wrote:
>   
>> Yes, I tested it. When you place that config file containing "search updates
>> built-in" in /etc/depmod.d
>> directory, it doesn't work.
>>     
>
> OK you probably have an old version of depmod. depmod is provided by
> module-init-tools, what version of module-init-tools do you have?
>
> I have 3.10 (as on Ubuntu Karmic)
>
>   
>> You have to place it in global config file
>> /etc/depmod.conf.
>>     
>
> If this is an old depmod thing we will have to check the version of
> depmod and do this for that case.
>
>   
>> How depmod works with config files in /etc/depmod.d directory is a mystery
>> for me.
>>     
>
> Its not that tricky, the new version reads /etc/depmod.conf and if
> that is not found then moves on to check /etc/depmod.d/* files.
>
>   
>> I wasn't able to learn
>> this from manual pages.
>>     
>
> That's probably because your version doesn't use depmod.d dir.
>
>   
>> And I tested another thing too. When some of config files (either global
>> /etc/depmod.conf or one of those in /etc/depmod.d directory)
>> doesn't contain search command ,
>> everything works fine, according to manual page for depmod, using builtin
>> search string "updates built-in" what  is
>> what you need.
>>     
>
> Right, built-in will use /lib/modules/$(uname -r)/kernel/ for modules,
> chances are if no depmod.conf file or depmod.d dir is present default
> may be to use built-in.
>
>   
>> As soon as one of them (either global or one of those in
>> /etc/depmod.d directory) contains search command,
>> then depmod uses this one. It seems seach command in global config file
>> (/etc/depmod.conf) has higher priory. But as I say
>> I really don't know how depmod works with all config files.
>>     
>
> I believe this is built-in by default, then read depmod.conf first, if
> that is not present read depmod.d dir.
>
>   Luis
>   

