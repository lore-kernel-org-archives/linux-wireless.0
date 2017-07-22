Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33393 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdGVMvW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 08:51:22 -0400
Received: by mail-oi0-f66.google.com with SMTP id e124so3693652oig.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 05:51:22 -0700 (PDT)
Subject: Re: New Realtek driver
To: Greg KH <gregkh@linux.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>, Pkshih <pkshih@realtek.com>
References: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
 <20170721150820.GC18198@kroah.com>
 <2cf70a42-6665-1da9-7c38-32751f2dc981@lwfinger.net>
 <20170722035119.GA31377@kroah.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f0c99e4c-52bf-0b32-df56-afbcee4b879e@lwfinger.net> (sfid-20170722_145126_395241_7707DDF5)
Date: Sat, 22 Jul 2017 07:51:20 -0500
MIME-Version: 1.0
In-Reply-To: <20170722035119.GA31377@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2017 10:51 PM, Greg KH wrote:
> On Fri, Jul 21, 2017 at 07:36:41PM -0500, Larry Finger wrote:
>> On 07/21/2017 10:08 AM, Greg KH wrote:
>>> On Thu, Jul 20, 2017 at 08:18:13PM -0500, Larry Finger wrote:
>>>> Kalle and Greg,
>>>>
>>>> Once again I find myself in the awkward position of needing to submit code
>>>> to two different trees, i.e. wireless and staging.
>>>>
>>>> The code in question concerns a new Realtek device, the RTL8822BE. The
>>>> device is already shipping, and Realtek would like it to be available in
>>>> kernel 3.14. As it consists of ~120,000 new lines of code, I have assured
>>>> Realtek that 3.14 would not be possible, at least in the wireless tree. What
>>>> I plan to do is submit the changes in the existing drivers through wireless,
>>>> and the three totally new drivers through staging. My expectation is that
>>>> this code would live for a relatively short time there, but going that route
>>>> would give time for the code to be reviewed properly, but still be available
>>>> in a kernel driver. All of the new code will be available in a GitHub repo
>>>> maintained by Realtek for those users whose distros do not configure
>>>> anything in staging.
>>>>
>>>> For my part, I will push the wireless tree material as fast as I can and
>>>> hope there is time available near the end of the 4.13-rcX sequence for the
>>>> material to reach 4.14-rc1.
>>>
>>> Why do you need a staging driver to have changes in the wireless tree?
>>> Staging drivers should be self-contained and not rely on anything
>>> outside of it in order to work properly (i.e. don't add code to the real
>>> kernel only for a staging driver.)
>>
>> Greg,
>>
>> To add the new driver to staging without any other changes, I will need to
>> duplicate a lot of code. That is no problem, other than the duplicate entry
>> points that will show up in a makeallyes configuration. If that is what you
>> want, then that is what I will do.
> 
> What do you mean by "duplicate entry points"?  Duplicate global symbols?
> Something else?

Of course, I meant duplicate global symbols.

Larry
