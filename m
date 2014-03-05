Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40838 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaCEQkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 11:40:11 -0500
Received: by mail-oa0-f47.google.com with SMTP id i11so1276261oag.20
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 08:40:10 -0800 (PST)
Message-ID: <53175368.50009@lwfinger.net> (sfid-20140305_174016_193768_1BA11194)
Date: Wed, 05 Mar 2014 10:40:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thierry Moreau <thierry.moreau@connotech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning
 works
References: <5316C602.8020504@connotech.com> <5316CE44.5060905@lwfinger.net> <5317506B.1080305@connotech.com>
In-Reply-To: <5317506B.1080305@connotech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2014 10:27 AM, Thierry Moreau wrote:
> On 03/05/14 07:12, Larry Finger wrote:
>> On 03/05/2014 12:36 AM, Thierry Moreau wrote:
>>> Hi!
>>>
>>> I am using a kind-of "linux from scratch" (i.e. Crux 3.0, 64 bits
>>> Intel, kernel
>>> 3.10.32) and I am stuck with a EBUSY error return from the wireless
>>> driver I
>>> suspect it comes from the driver behavior since it is consistent
>>> either from the
>>> command
>>>
>>> iw dev wlan1 set channel 2
>>>
>>> or the comand
>>>
>>> iwconfig wlan1 set channel 2
>>>
>>> (it occurred also with "iw" with a kernel where the iwconfig support
>>> emulation
>>> is off -- CONFIG_CFG82011_WEXT). The EBUSY error return occurs as
>>> early as
>>> immediately after the initial module install, and consistently
>>> thereafter. The
>>> wireless scanning works (reporting a nearby beacon on channel 1).
>
>>>  [ ... ... ]
>
>>>
>>> Any suggestion about a next step in troubleshooting? Maybe trying the
>>> latest
>>> kernel release candidate?
>>
>> I use NetworkManager and I never see errors like this.
>>
>> You definitely should use either a newer kernel or the backports
>> sources. There is a recent change that fixes a problem in rtl8192ce that
>> caused interrupts to be disabled for a long time. That fix is in the
>> mainline 3.14-rc5 and in the wireless-testing repo. It is in the process
>> of being applied to the various stable kernels, but it is probably not
>> there yet.
>>
>> If you just want to try that patch, it is available at
>> https://lkml.org/lkml/2014/2/1/15.
>>
>
> Thanks for your reply Larry. I had seen the interrupt latency fix (latest
> release candidate) but since my problem occurs earlier than any wifi protocol
> activity, I abstained from upgrading.
>
> Anyway since you suggested it, I moved to 3.14.0-rc5 and the problem occurs
> exactly as reported earlier (the dmesg indeed reports a different module load
> and init sequence).
>
>  From your suggestions, I should try with tools other than iw and iwconfig. I
> thought the higher level wireless management tools would use the same kernel api.
>
> Any other suggestion?
>
> P.S. Yes, the "ip link set up wlan1" command was given. The EBUSY return applies
> equally before and after this command.

Please give me the exact set of commands you use to get this problem. If 
possible, capture the console output. As I am currently running long-term tests 
of the latest version of rtl8192ce using an RTL8188CE (10ec:8176), it will be a 
perfect time to test.

Larry


