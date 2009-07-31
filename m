Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:46296 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGaBbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 21:31:23 -0400
Received: by ywh13 with SMTP id 13so1304341ywh.15
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 18:31:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7246D0.1040200@gmail.com>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
	<4A719C44.6050208@gmail.com> <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com>
	<4A71D172.1000306@gmail.com> <43e72e890907301006p200032e0i11fdb40fc33fa6d0@mail.gmail.com>
	<4A7246D0.1040200@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jul 2009 18:31:03 -0700
Message-ID: <43e72e890907301831ped2ea3wd5173b95be54f912@mail.gmail.com>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
To: Roman Macko <rmacko72@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 6:20 PM, Roman Macko<rmacko72@gmail.com> wrote:
> Hi Luis,
>
> I have version 3.6 of module-init-tools and this version reads /etc/depmod.d
> directory too.
>
> But I wanted to understand how depmod reads config files, so I looked into
> source codes (both version 3.6 and 3.10)
> and finally found out how it works.
>
> Assume depmod is run without -C or --config option
>
> Version 3.6 reads firstly /etc/depmod.conf file and then it reads config
> files in directory /etc/depmod.d.
> Files in directory /etc/depmod.d are read and parsed in unpredictable order
> by readdir function (this function uses
> raw directory structures of filesystem)
>
> Version 3.10 reads /etc/depmod.conf firstly as well, but this config file is
> considered as deprecated in this version
> and prints out warning about that. Then it reads config files in directory
> /etc/depmod.d by readdir function as well, but before it starts
> to parse them, it sorts them accord to filename, so you know the order in
> which they are going to be parsed
> and this is very improtant!!! This behavior should be from version 3.7
>
> The same for both versions:
> 1) List of directories to be searched is created from search commands from
> all config files in order how particular
> search commands are found in config files (so order of parsed config files
> is important). If no search command is found,
> updates directory is added before "built-in" directory.
>
> 2) As for override command, the last one found for particular module and
> kernel in all config files wins,
> so again the order of parsed config files is important.
>
> From this is evident, that both versions can work differently which depends
> on the order of parsed config files from
> /etc/depmod.d directory that is different in both versions.
>
> So solution would be:
> 1) if there is no search command in any of config files (in /etc/depmod.conf
>  or those in /etc/depmod.d directory), do nothing.
> 2) if there is a search command in any of config files and does not contain
> updates directory before built-in add search command
>   "search updates" in
>  a) if system has version >=3.7, create config file in /etc/depmod.d
> directory which name is alphabeticaly less than all you will find
>     in that directory
>  b) if system has version <=3.6 add search command "search updates" at the
> begining of /etc/depmod.conf file
>
> But such adding of "search updates" can break depmod configuration in some
> systems or it is not desirable to make search in
> updates directory at all. So maybe it would be better to use another name
> for directory than updates
>
> Or it would be also interesting to use override command for all modules
> compiled in compat-wireless
> and put it all to configuration file /etc/depmod.d/compat-wireless.conf and
> not bothering with version of depmod nor
> finding the search command in all configuration files, e.g
>
> compat-wireless.conf
> ======================================
> override iwlagn * updates/drivers/net/wireless/iwlwifi
> override iwlcore * updates/drivers/net/wireless/iwlwifi
> ....
> ....
> ....
> ======================================
>
> it can make problem only when some other config file in /etc/depmod.d
> directory contains override command for
> any module from compat-wireless
>
>
> I hope this help you

Thanks, since you have read this and can read code, mind putting
together a patch for the script on compat-wireless?

  Luis
