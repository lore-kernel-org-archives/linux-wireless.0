Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33495 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdBELeW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Feb 2017 06:34:22 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
 <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
 <b100135b-97c4-b2bc-4f19-2574e573878b@gmail.com>
 <3f1ad9bc-c065-4f1f-be78-70c0702867b4@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <03153d2a-abfd-78b4-4365-b80ec718e3e1@gmail.com> (sfid-20170205_123448_076926_FF5DBC69)
Date: Sun, 5 Feb 2017 14:34:18 +0300
MIME-Version: 1.0
In-Reply-To: <3f1ad9bc-c065-4f1f-be78-70c0702867b4@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05.02.2017 04:05, Larry Finger wrote:
> On 02/04/2017 01:32 PM, Dmitry Osipenko wrote:
>> On 04.02.2017 21:41, Larry Finger wrote:
>>> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
>>>> Seems the problem is caused by rtl92c_dm_*() casting .priv to "struct
>>>> rtl_pci_priv", while it is "struct rtl_usb_priv".
>>>
>>> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to make that
>>> difference in cast to be immaterial. I think we need to move "struct
>>> bt_coexist_info" to the beginning of both rtlpci_priv and rtl_usb_priv. Then it
>>> should not matter.
>>>
>>> I do not have a gcc version new enough to turn KASAN testing on, thus the
>>> attached patch is only compile tested. Does it fix the problem?
>>
>> Thank you for the patch, it indeed fixes the bug.
>>
>> I noticed that struct rtl_priv contains .btcoexist, isn't it duplicated in the
>> struct rtl_pci_priv?
> 
> Thanks for testing. When I submit the patch, is it OK to cite your reporting and
> testing?

Sure, Tested-by: Dmitry Osipenko <digetx@gmail.com>

> Yes, the bt_coexist_info structure is in two different places. I will change the
> code in rtl8192c-common and rtl8192ce to use only the one in rtlpriv. That
> should satisfy the problem you reported, as well as clean up the code.
> 
> Thanks again,

Good, thank you.

BTW, I have an issue with the 8192cu: WiFi stops to work after a while (3-15
minutes) if I enable WMM QoS on the AP. There is nothing suspicious in KMSG,
connection is up but no packets go in/out. I tried to enable debug messages in
the driver, so when the WiFi stops to work I see that some "temperature/led"
notify still going on in the driver, but nothing happens when I try to initiate
a transfer (say to open a web page) - the log is silent, like the requests are
getting stuck/dropped somewhere before reaching the driver. Is it a known issue?
With the QoS disabled everything works hunky-dory, however I get 2x-4x faster
download speed with QoS enabled (while it works.)

I noticed that rtl92c_init_edca_param() isn't wired in the driver, so I suppose
the QoS isn't implemented yet, right?

If it is an expected behaviour, I think at least printing a warning message in
the KMSG like "QoS unimplemented, you may expect problems" should be good enough
to avoid confusion.

-- 
Dmitry
