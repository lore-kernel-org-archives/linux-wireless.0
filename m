Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-da02.mx.aol.com ([205.188.105.144]:49500 "EHLO
	imr-da02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1K2Sy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 13:54:28 -0500
Message-ID: <4ED52A56.3030804@aol.com> (sfid-20111129_195432_069669_C3C4FBA4)
Date: Tue, 29 Nov 2011 13:54:14 -0500
From: AndrewL733 <AndrewL733@aol.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Making Progress Re: Trouble with Macbook Pro 8,2 (broadcom 4331)
 and latest b43
References: <4ED3A6E8.4050000@aol.com> <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com> <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com> <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com> <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com> <4ED51DB5.5090202@aol.com>
In-Reply-To: <4ED51DB5.5090202@aol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> Hi,
>>>
>>> Thanks for the suggestions.  Nothing solving the problem so far.
>>>
>>> I meant
>>> find /lib/modules -name "b43.ko"
>>>
>>>
>>> What is the point of looking for b43.ko?  It exists for my running 
>>> kernel.
>> I believe b43.ko from compat-wireless should be put in some specific
>> subdirectory, probably "extra". AFAIR it's
>> /lib/modules/SOMEKERNEL/extra/...
>>
>> If you can see only default b43.ko, it means compat-wireless didn't
>> install successfully.
>>
> Thanks for your reply.
>
> You are absolutely right.  My Mandriva kernel's name is 
> 3.1.2-1.1-desktop but the compat-wireless "make install" is installing 
> everything in the directory /lib/modules/3.1.2-1-desktop/updates.  The 
> install path is missing the ".1" before the "-desktop".
> .....
>
> How can I instruct "make install" to put the drivers in the correct 
> path?  I'm going to try to just copy everything to the correct place 
> and run depmod  and see what happens.  Maybe that'll work??
>
> Andy
Okay, I copied the contents of /lib/modules/3.1.2-1-desktop/updates to 
/lib/modules/3.1.2-1.1-desktop/.  I then renamed "updates" to "extra" 
and ran depmod.  Now when I run "modinfo b43" it points to the new 
compat-wireless version of b43 instead of pointing to the distro 
version.   When I LOAD b43, iwconfig shows a wlan0.  So, we are making 
progress.

But now, to do things the "Mandriva way", I am supposed to launch the 
"Mandriva Control Center"  (drakconf), go to the "Manage you network 
devices" section and "add" the wlan0 interface to my system. (The idea 
is to then allow Network Manager to manage the connection moving 
forward, but first you have to enable the connection.) When I try to add 
wlan0 to my network configuration, I get a dialog box asking me which 
firmware file to use?  Basically, it wants me to navigate to 
/lib/firmware/b43/ and select one of the "ucode" files.  With the 
previous Macbook Pro 8,2, I think I selected ucode13.fw and it worked 
fine.  But what is the correct way to select the proper firmware without 
guessing?

When I was trying to load the "distro b43" driver, dmesg was telling me 
the driver needed "FW13".  Does that mean anything?

Andy
