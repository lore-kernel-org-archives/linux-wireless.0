Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34231 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753651AbdBGROy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 12:14:54 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Tobias Guggenmos <slartibartfas421@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <1486376979.14226.9.camel@sipsolutions.net>
 <fbe5786e-54eb-b8a7-1540-64a913692361@lwfinger.net>
 <46454409.lUoPi3ZtJt@slartibartfas>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <9c8a63f7-ddde-aefd-2db6-83d91a5c689e@gmail.com> (sfid-20170207_181632_549680_409CAC6F)
Date: Tue, 7 Feb 2017 20:14:50 +0300
MIME-Version: 1.0
In-Reply-To: <46454409.lUoPi3ZtJt@slartibartfas>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.02.2017 19:45, Tobias Guggenmos wrote:
> Am Montag, 6. Februar 2017, 09:45:31 CET schrieb Larry Finger:
>> On 02/06/2017 04:29 AM, Johannes Berg wrote:
>>> On Sat, 2017-02-04 at 12:41 -0600, Larry Finger wrote:
>>>> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
>>>>> Seems the problem is caused by rtl92c_dm_*() casting .priv to
>>>>> "struct
>>>>> rtl_pci_priv", while it is "struct rtl_usb_priv".
>>>>
>>>> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to
>>>> make that
>>>> difference in cast to be immaterial. I think we need to move "struct
>>>> bt_coexist_info" to the beginning of both rtlpci_priv and
>>>> rtl_usb_priv. Then it
>>>> should not matter.
>>>
>>> I think you really should consider putting a struct rtl_common into
>>> that or something, and getting rid of all the casting that causes this
>>> problem to start with?
>>
>> The fix you suggest is prepared and will be submitted soon. As it is much
>> more invasive with ~150 insertions and ~160 deletions, I decided not to
>> have it be the one that is pushed to all stable kernels from 4.0 onward.
>>
>> Larry
> 
> This is possibly related to the following Fedora Bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=1391987
> 

Bug only affects USB adapters (8192cu), PCIe (8192ce) should be fine. The Fedora
bug sounds like the one I have with the enabled AP QoS.

-- 
Dmitry
