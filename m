Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35342 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbFUGWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 02:22:45 -0400
Received: by lbbwc1 with SMTP id wc1so92638341lbb.2
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2015 23:22:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5585E8EE.2000005@gmail.com>
References: <5585B209.3040406@gmail.com>
	<CANUX_P0DYFVqxVHg6B8ZXLiLv97Gu8JuiXcUEA8rvPMW8+Jb2Q@mail.gmail.com>
	<5585E8EE.2000005@gmail.com>
Date: Sun, 21 Jun 2015 09:22:44 +0300
Message-ID: <CANUX_P1b-Up9AOkRryd1iVcW8GqGShaS6PEr31tX7FTLXQ4V2Q@mail.gmail.com> (sfid-20150621_082249_560979_9701EC62)
Subject: Re: "No association and the time event is over already..."
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Blue Glacier <blueglacier414@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 21, 2015 at 1:27 AM, Blue Glacier <blueglacier414@gmail.com> wrote:
> Hello,
>
> yes, already tried to disable and re-enable WiFi. Didn't help.
>
> I guess AP means Access Point. It is a "FRITZ!Box 6360 Cable (um)". I tried
> to reboot it. 15 minutes later it suddenly worked - but only for two hours.
> Now the connection is broken again.

This seems to point to an AP problem... We've had lots of issues with
the FRITZ!Box Access Points. Would you be able to take a sniffer
capture of its beacon in the bad and good case?

>
> While ping times out, I sometimes seem to be able to load websites - but it
> takes almost 10 minutes and many elements are missing. I am also repeatedly
> asked for my WiFi-password, which worked until yesterday.
>

As a debug step, you can try to disable power save:
iw wlan0 set power_save off

> I compared the md5 hash sums of the driver image (iwlwifi-7265-9.ucode) that
> I have installed and the one that is available through the link you gave me,
> and the sums are equal. Therefore, I think it doesn't make sense to try the
> other image.

-9.ucode is fairly old and we won't release any new version of it. I
recommend you install the backport version of the driver and try
-13.ucode. To install a  coherent version of the driver / firmware
combo, please check
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release.

Since it might confuse you, let me explain the release model of the
firmware. The X in -X.ucode is the major version of the firmware which
usually includes new features etc... Without changing the X, we
sometimes release new versions with bug fixes. So you seem to have the
latest version of the -9.ucode, but that firmware is missing lots of
bug fixes that won't be backported.

>
> I don't know if it is a good idea to install a different kernel on Debian
> Stable.

Right - this is why I suggested the backport solution.

>
> Jens
>
>
> Am 20.06.2015 um 22:01 schrieb Emmanuel Grumbach:
>>
>> On Sat, Jun 20, 2015 at 9:33 PM, Blue Glacier <blueglacier414@gmail.com>
>> wrote:
>>>
>>> Hello,
>>>
>>> my Intel Wireless 7265 chip suddenly stopped working. The Network Manager
>>> shows that I am connected, but I cannot even ping to my home router. I
>>> didn't change anything on my system.
>>
>> What is your AP? Can you reproduce consistently? If you disable WiFi
>> and re-enable WiFi from the Network Manager, does it help?
>>
>>> The output of dmesg looks interesting:
>>>
>>> [  507.737606] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
>>> [  507.806070] cfg80211: Calling CRDA for country: DE
>>> [  508.379770] cfg80211: Calling CRDA for country: DE
>>> [  511.332818] wlan0: authenticate with c0:25:06:ce:d2:e9
>>> [  511.338625] wlan0: send auth to c0:25:06:ce:d2:e9 (try 1/3)
>>> [  511.341600] wlan0: authenticated
>>> [  511.343813] wlan0: associate with c0:25:06:ce:d2:e9 (try 1/3)
>>> [  511.350128] wlan0: RX AssocResp from c0:25:06:ce:d2:e9 (capab=0x431
>>> status=0 aid=8)
>>> [  511.353700] wlan0: associated
>>> [  511.645582] iwlwifi 0000:03:00.0: No association and the time event is
>>> over already...
>>> [  511.645642] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
>>> [  511.688174] cfg80211: Calling CRDA to update world regulatory domain
>>>
>>> (repeated numerous times)
>>>
>>> I am using Debian 8 Jessie (stable) together with the firmware from your
>>> server (iwlwifi-7265-9.ucode). The Kernel Version is 3.16.0-4-amd64.
>>
>> Can you try a more recent kernel with a more recent firmware?
>> You can check
>> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release
>> if you want to update your driver without changing your kernel.
>>
>>> Any idea how to fix this?
>>
>>
>>> Jens
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
