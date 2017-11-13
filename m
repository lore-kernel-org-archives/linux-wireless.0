Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:50034 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbdKMVac (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 16:30:32 -0500
Received: by mail-oi0-f43.google.com with SMTP id r190so3229872oie.6
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 13:30:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3045d677-8f24-b258-0eaf-ee8dae5ecd4c@lwfinger.net>
References: <CAMRc=Mf92X2t8wjmE+xkXrA0QKY06uFeXhMY-97Ka=_UxuQbjw@mail.gmail.com>
 <CAMRc=Mf-4HnRXLxoiPrzZVjeCpfY5+Q2Ydmee0GkViejk8nzaQ@mail.gmail.com> <3045d677-8f24-b258-0eaf-ee8dae5ecd4c@lwfinger.net>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 13 Nov 2017 22:30:31 +0100
Message-ID: <CAMRc=Mf-sy79yoJiyZC8pOtHTo4P7SpHPsTmuHxEBfbc8xa+Uw@mail.gmail.com> (sfid-20171113_223038_305862_85A89108)
Subject: Re: Fwd: linux v4.14 causes firmware iwlwifi errors on Lenovo
 Thinkpad T440s
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-11-13 21:45 GMT+01:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/13/2017 02:22 PM, Bartosz Golaszewski wrote:
>>
>> Forwarding here too as I messed up the address the last time.
>> --
>>
>> Hi,
>>
>> I noticed my wireless interface can't get up with linux v4.14 and the
>> kernel log is flooded with firmware errors:
>>
>> iwlwifi 0000:03:00.0: Firmware error during reconfiguration - reprobe!
>> iwlwifi 0000:03:00.0: FW error in SYNC CMD DQA_ENABLE_CMD
>>
>> and
>>
>> ieee80211 phy63: Hardware restart was requested.
>>
>> The wireless controller is: Intel Corporation Wireless 7260 (rev 83)
>> Firmware used is: iwlwifi-7260-17
>>
>> Everything works fine with v4.13.12.
>>
>> I didn't have time today to bisect for the offending commit. Full log
>> uploaded[1].
>>
>> Best regards,
>> Bartosz Golaszewski
>>
>> [1] https://pastebin.com/jksqxvS6
>
>
> Your log shows "iwlwifi 0000:03:00.0: loaded firmware version 17.228510.0
> op_mode iwlmvm"
>
> Mine, where the 7260 works, shows "iwlwifi 0000:04:00.0: loaded firmware
> version 17.459231.0 op_mode iwlmvm".
>
> It seems as if you need newer firmware. A detailed file listing shows
> "-rw-r--r-- 1 root root 1049340 Oct  9 12:03
> /lib/firmware/iwlwifi-7260-17.ucode". That date is likely when I installed
> the updated kernel firmware package from my distro. The md5sum for the file
> is 73a217f55c47d3a70bb5dbbe1d676423.
>
> Larry
>

Ok so it seems the version in linux-firmware is outdated. The file
you're using is available on github[1] and fixed the issue for me.

Thanks!
Bartosz Golaszewski

[1] https://github.com/OpenELEC/iwlwifi-firmware
