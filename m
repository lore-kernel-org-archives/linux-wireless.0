Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33607 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbdBHAx0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 19:53:26 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Tobias Guggenmos <slartibartfas421@gmail.com>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <1486376979.14226.9.camel@sipsolutions.net>
 <fbe5786e-54eb-b8a7-1540-64a913692361@lwfinger.net>
 <46454409.lUoPi3ZtJt@slartibartfas>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <05892a0b-6745-1fd4-f050-5b0b4aa463b3@lwfinger.net> (sfid-20170208_015407_733888_E766696F)
Date: Tue, 7 Feb 2017 18:45:01 -0600
MIME-Version: 1.0
In-Reply-To: <46454409.lUoPi3ZtJt@slartibartfas>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2017 10:45 AM, Tobias Guggenmos wrote:
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

This bug is unlikely to be the cause of that problem. In fact, this bug only 
affects rtl8192cu, not rtl8192ce. The RedHat problem is more likely caused by 
the not-yet-merged patch entitled "rtlwifi: rtl8192ce: Fix loading of incorrect 
firmware".

Larry
