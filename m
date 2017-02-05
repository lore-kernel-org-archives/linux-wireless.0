Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33643 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdBESPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Feb 2017 13:15:55 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Larry Finger <Larry.Finger@lwfinger.net>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
 <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
 <b100135b-97c4-b2bc-4f19-2574e573878b@gmail.com>
 <3f1ad9bc-c065-4f1f-be78-70c0702867b4@lwfinger.net>
 <03153d2a-abfd-78b4-4365-b80ec718e3e1@gmail.com>
 <92f6dcb7-bbee-533a-7d49-21670286a3f3@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ae46e5de-9c43-d941-1d11-51d5aef791ea@gmail.com> (sfid-20170205_191626_742652_3AF1CD8D)
Date: Sun, 5 Feb 2017 21:15:51 +0300
MIME-Version: 1.0
In-Reply-To: <92f6dcb7-bbee-533a-7d49-21670286a3f3@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05.02.2017 20:30, Larry Finger wrote:
> On 02/05/2017 05:34 AM, Dmitry Osipenko wrote:
>> BTW, I have an issue with the 8192cu: WiFi stops to work after a while (3-15
>> minutes) if I enable WMM QoS on the AP. There is nothing suspicious in KMSG,
>> connection is up but no packets go in/out. I tried to enable debug messages in
>> the driver, so when the WiFi stops to work I see that some "temperature/led"
>> notify still going on in the driver, but nothing happens when I try to initiate
>> a transfer (say to open a web page) - the log is silent, like the requests are
>> getting stuck/dropped somewhere before reaching the driver. Is it a known issue?
>> With the QoS disabled everything works hunky-dory, however I get 2x-4x faster
>> download speed with QoS enabled (while it works.)
>>
>> I noticed that rtl92c_init_edca_param() isn't wired in the driver, so I suppose
>> the QoS isn't implemented yet, right?
>>
>> If it is an expected behaviour, I think at least printing a warning message in
>> the KMSG like "QoS unimplemented, you may expect problems" should be good enough
>> to avoid confusion.
> 
> As you have already seen, I decided to defer the more invasive patch. When
> backporting to stable, the smaller the change the better.

That is a right approach.

> I have no knowledge of the internals of the RTL8192CU chip. As a result, the
> kinds of changes I can make are limited. I do know that the chip does implement
> QoS. I also noticed that the set_qos() callback routine was very different in
> rtl8192ce than in rtl8192cu. Attached is an untested patch to make the CU
> routine look like the CE version. Please see if it makes a difference.

Thank you a lot, unfortunately it doesn't help.

> Driver rtl8192cu has never been maintained by Realtek, and it will likely be
> removed from the kernel in the next few cycles. As you are running a new kernel,
> I would recommend rtl8xxxu instead. That driver has high reliability, and the
> speed is improving. Your other option would be a driver offered by the vendor of
> your particular device. Realtek used to have these drivers on their web site,
> but they now seem to have been removed. If your vendor does not have a driver,
> http://www.edimax.com/edimax/mw/cufiles/files/download/Driver_Utility/transfer/Wireless/NIC/EW-7811Un/EW-7811Un_Linux_driver_v1.0.0.5.zip
> should work.

Oh, I wasn't aware of rtl8xxxu. Thought it is a driver for some other HW. Thanks
a lot for pointing to it, will give it a whirl.

I'm maintaining a personal fork of a downstream driver for a dozen kernel
releases now, need a hostapd sometime. Fortunately, it's not a big burden.

Thank you a lot again, keep up the good work.

-- 
Dmitry
