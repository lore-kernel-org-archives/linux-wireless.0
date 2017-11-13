Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:44465 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdKMWXF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 17:23:05 -0500
Subject: Re: Fwd: linux v4.14 causes firmware iwlwifi errors on Lenovo
 Thinkpad T440s
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <CAMRc=Mf92X2t8wjmE+xkXrA0QKY06uFeXhMY-97Ka=_UxuQbjw@mail.gmail.com>
 <CAMRc=Mf-4HnRXLxoiPrzZVjeCpfY5+Q2Ydmee0GkViejk8nzaQ@mail.gmail.com>
 <3045d677-8f24-b258-0eaf-ee8dae5ecd4c@lwfinger.net>
 <CAMRc=Mf-sy79yoJiyZC8pOtHTo4P7SpHPsTmuHxEBfbc8xa+Uw@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <10da37f3-a018-7568-49a8-3a8ed86ef64c@lwfinger.net> (sfid-20171113_232314_911359_B9E550C5)
Date: Mon, 13 Nov 2017 16:23:03 -0600
MIME-Version: 1.0
In-Reply-To: <CAMRc=Mf-sy79yoJiyZC8pOtHTo4P7SpHPsTmuHxEBfbc8xa+Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2017 03:30 PM, Bartosz Golaszewski wrote:
> 2017-11-13 21:45 GMT+01:00 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 11/13/2017 02:22 PM, Bartosz Golaszewski wrote:
>>>
>>> Forwarding here too as I messed up the address the last time.
>>> --
>>>
>>> Hi,
>>>
>>> I noticed my wireless interface can't get up with linux v4.14 and the
>>> kernel log is flooded with firmware errors:
>>>
>>> iwlwifi 0000:03:00.0: Firmware error during reconfiguration - reprobe!
>>> iwlwifi 0000:03:00.0: FW error in SYNC CMD DQA_ENABLE_CMD
>>>
>>> and
>>>
>>> ieee80211 phy63: Hardware restart was requested.
>>>
>>> The wireless controller is: Intel Corporation Wireless 7260 (rev 83)
>>> Firmware used is: iwlwifi-7260-17
>>>
>>> Everything works fine with v4.13.12.
>>>
>>> I didn't have time today to bisect for the offending commit. Full log
>>> uploaded[1].
>>>
>>> Best regards,
>>> Bartosz Golaszewski
>>>
>>> [1] https://pastebin.com/jksqxvS6
>>
>>
>> Your log shows "iwlwifi 0000:03:00.0: loaded firmware version 17.228510.0
>> op_mode iwlmvm"
>>
>> Mine, where the 7260 works, shows "iwlwifi 0000:04:00.0: loaded firmware
>> version 17.459231.0 op_mode iwlmvm".
>>
>> It seems as if you need newer firmware. A detailed file listing shows
>> "-rw-r--r-- 1 root root 1049340 Oct  9 12:03
>> /lib/firmware/iwlwifi-7260-17.ucode". That date is likely when I installed
>> the updated kernel firmware package from my distro. The md5sum for the file
>> is 73a217f55c47d3a70bb5dbbe1d676423.
>>
>> Larry
>>
> 
> Ok so it seems the version in linux-firmware is outdated. The file
> you're using is available on github[1] and fixed the issue for me.
> 
> Thanks!
> Bartosz Golaszewski
> 
> [1] https://github.com/OpenELEC/iwlwifi-firmware

Interesting. Using md5sum of the git repo for linux-firmware gets
73a217f55c47d3a70bb5dbbe1d676423  iwlwifi-7260-17.ucode.

That is the file I'm using.

Larry
