Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:35207 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZGaVQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:16:59 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1247710qwh.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 14:16:59 -0700 (PDT)
Message-ID: <4A735FF8.7000503@gmail.com>
Date: Fri, 31 Jul 2009 17:19:52 -0400
From: Roman Macko <rmacko72@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net> 	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com> 	<1248904631.1216.1027.camel@rc-desk> <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com> 	<4A719C44.6050208@gmail.com> <43e72e890907300743nd3a80eck2153d01f4e99ddf9@mail.gmail.com> 	<4A71D172.1000306@gmail.com> <43e72e890907301006p200032e0i11fdb40fc33fa6d0@mail.gmail.com> 	<4A7246D0.1040200@gmail.com> <43e72e890907301831ped2ea3wd5173b95be54f912@mail.gmail.com>
In-Reply-To: <43e72e890907301831ped2ea3wd5173b95be54f912@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040509070505010802090508"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040509070505010802090508
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luis,

here is promised patch

roman

Luis R. Rodriguez wrote:
> On Thu, Jul 30, 2009 at 6:20 PM, Roman Macko<rmacko72@gmail.com> wrote:
>   
>> Hi Luis,
>>
>> I have version 3.6 of module-init-tools and this version reads /etc/depmod.d
>> directory too.
>>
>> But I wanted to understand how depmod reads config files, so I looked into
>> source codes (both version 3.6 and 3.10)
>> and finally found out how it works.
>>
>> Assume depmod is run without -C or --config option
>>
>> Version 3.6 reads firstly /etc/depmod.conf file and then it reads config
>> files in directory /etc/depmod.d.
>> Files in directory /etc/depmod.d are read and parsed in unpredictable order
>> by readdir function (this function uses
>> raw directory structures of filesystem)
>>
>> Version 3.10 reads /etc/depmod.conf firstly as well, but this config file is
>> considered as deprecated in this version
>> and prints out warning about that. Then it reads config files in directory
>> /etc/depmod.d by readdir function as well, but before it starts
>> to parse them, it sorts them accord to filename, so you know the order in
>> which they are going to be parsed
>> and this is very improtant!!! This behavior should be from version 3.7
>>
>> The same for both versions:
>> 1) List of directories to be searched is created from search commands from
>> all config files in order how particular
>> search commands are found in config files (so order of parsed config files
>> is important). If no search command is found,
>> updates directory is added before "built-in" directory.
>>
>> 2) As for override command, the last one found for particular module and
>> kernel in all config files wins,
>> so again the order of parsed config files is important.
>>
>> From this is evident, that both versions can work differently which depends
>> on the order of parsed config files from
>> /etc/depmod.d directory that is different in both versions.
>>
>> So solution would be:
>> 1) if there is no search command in any of config files (in /etc/depmod.conf
>>  or those in /etc/depmod.d directory), do nothing.
>> 2) if there is a search command in any of config files and does not contain
>> updates directory before built-in add search command
>>   "search updates" in
>>  a) if system has version >=3.7, create config file in /etc/depmod.d
>> directory which name is alphabeticaly less than all you will find
>>     in that directory
>>  b) if system has version <=3.6 add search command "search updates" at the
>> begining of /etc/depmod.conf file
>>
>> But such adding of "search updates" can break depmod configuration in some
>> systems or it is not desirable to make search in
>> updates directory at all. So maybe it would be better to use another name
>> for directory than updates
>>
>> Or it would be also interesting to use override command for all modules
>> compiled in compat-wireless
>> and put it all to configuration file /etc/depmod.d/compat-wireless.conf and
>> not bothering with version of depmod nor
>> finding the search command in all configuration files, e.g
>>
>> compat-wireless.conf
>> ======================================
>> override iwlagn * updates/drivers/net/wireless/iwlwifi
>> override iwlcore * updates/drivers/net/wireless/iwlwifi
>> ....
>> ....
>> ....
>> ======================================
>>
>> it can make problem only when some other config file in /etc/depmod.d
>> directory contains override command for
>> any module from compat-wireless
>>
>>
>> I hope this help you
>>     
>
> Thanks, since you have read this and can read code, mind putting
> together a patch for the script on compat-wireless?
>
>   Luis
>   


--------------040509070505010802090508
Content-Type: text/plain;
 name="check_depmod.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="check_depmod.patch"

LS0tIGNvbXBhdC13aXJlbGVzcy0yMDA5LTA3LTMxL3NjcmlwdHMvY2hlY2tfZGVwbW9kCTIw
MDktMDctMzEgMTA6NDI6NTIuMDAwMDAwMDAwIC0wNDAwCisrKyBjb21wYXQtd2lyZWxlc3Mt
cGF0Y2gvc2NyaXB0cy9jaGVja19kZXBtb2QJMjAwOS0wNy0zMSAxNjozMDoyMi4wMDAwMDAw
MDAgLTA0MDAKQEAgLTcsNTAgKzcsNzcgQEAKICMgU2VlbXMgTWFuZHJpdmEgaGFzIGFuICRE
RVBNT0RfRElSIGJ1dCBpdCBkb2Vzbid0IGhhdmUgYW55IGZpbGVzLAogIyBzbyBsZXRzIGRl
YWwgd2l0aCB0aG9zZSBkaXN0cmlidXRpb25zLgogREVQTU9EX0NPTkY9Ii9ldGMvZGVwbW9k
LmNvbmYiCitERVBNT0RfQ09ORl9UTVA9IiRERVBNT0RfQ09ORi5jb21wYXQtd2lyZWxlc3Mu
b2xkIgogREVQTU9EX0RJUj0iL2V0Yy9kZXBtb2QuZC8iCiBDT01QQVRfREVQTU9EX0ZJTEU9
Y29tcGF0LXdpcmVsZXNzLmNvbmYKK0dSRVBfUkVHRVhfVVBEQVRFUz0iXltbOnNwYWNlOl1d
KnNlYXJjaC4qW1s6c3BhY2U6XV11cGRhdGVzXChbWzpzcGFjZTpdXVx8JFwpIgorR1JFUF9S
RUdFWF9TRUFSQ0g9Il5bWzpzcGFjZTpdXSpzZWFyY2hbWzpzcGFjZTpdXS5cKyQiCitERVBN
T0RfQ01EPSJkZXBtb2QiCiAKIGZ1bmN0aW9uIGFkZF9jb21wYXRfZGVwbW9kX2NvbmYgewog
CWVjaG8gIk5PVEU6IFlvdXIgZGlzdHJpYnV0aW9uIGxhY2tzIGFuICRERVBNT0RfRElSIGRp
cmVjdG9yeSB3aXRoICIKLQllY2hvICJ1cGRhdGVzLyBkaXJlY3RvcnkgYmVpbmcgcHJpb3Jp
dGl6ZWQgZm9yIG1vdWxkZXMsIHdlJ3JlIGFkZGluZyAiCisJZWNobyAidXBkYXRlcy8gZGly
ZWN0b3J5IGJlaW5nIHByaW9yaXRpemVkIGZvciBtb2R1bGVzLCB3ZSdyZSBhZGRpbmcgIgog
CWVjaG8gIm9uZSBmb3IgeW91LiIKIAlta2RpciAtcCAkREVQTU9EX0RJUgotCWVjaG8gInNl
YXJjaCB1cGRhdGVzIGV4dHJhIGJ1aWx0LWluIiA+ICRERVBNT0RfRElSLyRDT01QQVRfREVQ
TU9EX0ZJTEUKKwlGSVJTVF9GSUxFPSQobHMgJERFUE1PRF9ESVJ8aGVhZCAtMSkKKwlbIC1u
ICIkRklSU1RfRklMRSIgXSAmJiB3aGlsZSBbWyAkRklSU1RfRklMRSA8ICRDT01QQVRfREVQ
TU9EX0ZJTEUgXV07IGRvCisJCUNPTVBBVF9ERVBNT0RfRklMRT0iMCRDT01QQVRfREVQTU9E
X0ZJTEUiCisJZG9uZQorCWVjaG8gInNlYXJjaCB1cGRhdGVzIiA+ICRERVBNT0RfRElSLyRD
T01QQVRfREVQTU9EX0ZJTEUKIH0KIAotZnVuY3Rpb24gZGVwbW9kX3VwZGF0ZXNfb2sgewot
CWVjaG8gImRlcG1vZCB3aWxsIHByZWZlciB1cGRhdGVzLyBvdmVyIGtlcm5lbC8gLS0gT0sh
IgorZnVuY3Rpb24gYWRkX2dsb2JhbF9kZXBtb2RfY29uZiB7CisJZWNobyAiTk9URTogWW91
ciBkaXN0cmlidXRpb24gbGFja3MgdXBkYXRlcy8gZGlyZWN0b3J5IGJlaW5nIgorIAllY2hv
ICJwcmlvcml0aXplZCBmb3IgbW9kdWxlcywgd2UncmUgYWRkaW5nIGl0IHRvICRERVBNT0Rf
Q09ORi4iCisJcm0gLWYgJERFUE1PRF9DT05GX1RNUAorCVsgLWYgJERFUE1PRF9DT05GIF0g
JiYgY3AgLWYgJERFUE1PRF9DT05GICRERVBNT0RfQ09ORl9UTVAKKwllY2hvICJzZWFyY2gg
dXBkYXRlcyIgPiAkREVQTU9EX0NPTkYKKwlbIC1mICRERVBNT0RfQ09ORl9UTVAgXSAmJiBj
YXQgJERFUE1PRF9DT05GX1RNUCA+PiAkREVQTU9EX0NPTkYKIH0KIAotZnVuY3Rpb24gY2hl
Y2tfZGVwbW9kX2NvbmYgewotCWlmIFsgLWYgJERFUE1PRF9DT05GIF07IHRoZW4KLQkJZ3Jl
cCAtcSB1cGRhdGVzICRERVBNT0RfQ09ORgotCQlyZXR1cm4gJD8KLQlmaQotCXJldHVybiAx
CitmdW5jdGlvbiBkZXBtb2RfdXBkYXRlc19vayB7CisJZWNobyAiZGVwbW9kIHdpbGwgcHJl
ZmVyIHVwZGF0ZXMvIG92ZXIga2VybmVsLyAtLSBPSyEiCiB9CiAKLWZ1bmN0aW9uIGFkZF9k
ZXBtb2RfY29uZl9pZl9taXNzaW5nIHsKLQljaGVja19kZXBtb2RfY29uZgotCWlmIFtbICQ/
IC1uZSAwIF1dOyB0aGVuCi0JCWFkZF9jb21wYXRfZGVwbW9kX2NvbmYKK2Z1bmN0aW9uIGFk
ZF9kZXBtb2RfY29uZiB7CisJaWYgWyAtZiAiJERFUE1PRF9DT05GIiBdOyB0aGVuCisJCWFk
ZF9nbG9iYWxfZGVwbW9kX2NvbmYKIAllbHNlCi0JCWRlcG1vZF91cGRhdGVzX29rCisJCURF
UE1PRF9WRVJTSU9OPSQoJERFUE1PRF9DTUQgLS12ZXJzaW9uIHwgY3V0IC1kIiAiIC1mMiB8
IHNlZCAicy9cLi8vIikKKwkJaWYgW1sgJERFUE1PRF9WRVJTSU9OIC1ndCAzNiBdXTsgdGhl
bgorCQkJYWRkX2NvbXBhdF9kZXBtb2RfY29uZgorCQllbHNlCisJCQlhZGRfZ2xvYmFsX2Rl
cG1vZF9jb25mCisJCWZpCiAJZmkKIH0KIAorIyA9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQor
IyA9PT0gTUFJTiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQorIyA9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQor
CitHUkVQX0ZJTEVTPSIiCitbIC1mICRERVBNT0RfQ09ORiBdICYmIEdSRVBfRklMRVM9IiRE
RVBNT0RfQ09ORiIKIGlmIFsgLWQgJERFUE1PRF9ESVIgXTsgdGhlbgogCURFUE1PRF9GSUxF
X0NPVU5UPSQobHMgJERFUE1PRF9ESVIgfCB3YyAtbCkKLQlpZiBbWyAkREVQTU9EX0ZJTEVf
Q09VTlQgLWVxIDAgXV07IHRoZW4KLQkJYWRkX2RlcG1vZF9jb25mX2lmX21pc3NpbmcKLQll
bHNlCi0JCWdyZXAgLXEgdXBkYXRlcyAkREVQTU9EX0RJUi8qCi0JCWlmIFtbICQ/IC1uZSAw
IF1dOyB0aGVuCi0JCQlhZGRfZGVwbW9kX2NvbmZfaWZfbWlzc2luZwotCQllbHNlCisJW1sg
JERFUE1PRF9GSUxFX0NPVU5UIC1ndCAwIF1dICYmIEdSRVBfRklMRVM9IiRHUkVQX0ZJTEVT
ICRERVBNT0RfRElSLyoiCitmaQorCitpZiBbIC1uICIkR1JFUF9GSUxFUyIgXTsgdGhlbgor
CWdyZXAgLXEgIiRHUkVQX1JFR0VYX1NFQVJDSCIgJEdSRVBfRklMRVMKKwlpZiBbWyAkPyAt
ZXEgMCBdXTsgdGhlbgorCQlncmVwIC1xICIkR1JFUF9SRUdFWF9VUERBVEVTIiAkR1JFUF9G
SUxFUworCQlpZiBbWyAkPyAtZXEgMCBdXTsgdGhlbgogCQkJZGVwbW9kX3VwZGF0ZXNfb2sK
KwkJZWxzZQorCQkJYWRkX2RlcG1vZF9jb25mCiAJCWZpCisJZWxzZQorCQlkZXBtb2RfdXBk
YXRlc19vawogCWZpCiBlbHNlCi0JYWRkX2RlcG1vZF9jb25mX2lmX21pc3NpbmcKKwlkZXBt
b2RfdXBkYXRlc19vawogZmkKKworZXhpdCAwCisK
--------------040509070505010802090508--
