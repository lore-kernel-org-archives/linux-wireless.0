Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60539 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1HXQzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 12:55:47 -0400
Received: by wyg24 with SMTP id 24so992735wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 09:55:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E552BB7.9050304@lwfinger.net>
References: <4e472623.xXZaXUueNVRpfmG+%Larry.Finger@lwfinger.net>
	<CAD2nsn2sO+Lj+DntbFVa8QMYq8eTtFqdX06aQGHtNEbnbVTJzQ@mail.gmail.com>
	<20110823194545.GF9770@tuxdriver.com>
	<CAD2nsn1VuMvrWtXCq66HuOz8VLDWPnoTy2=p1v36fWohJx8QUA@mail.gmail.com>
	<4E552BB7.9050304@lwfinger.net>
Date: Wed, 24 Aug 2011 22:25:46 +0530
Message-ID: <CAD2nsn1oD9mVOs7dUZNRrnkt=jnefDnaOMro8JFrUfK=7n1+Mw@mail.gmail.com> (sfid-20110824_185550_908531_738BF0FF)
Subject: Re: [RFC/RFT] ath9k_htc: Fix memory leak
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	lrodriguez@atheros.com, vasanth@atheros.com,
	senthilkumar@atheros.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 10:19 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 08/24/2011 10:53 AM, Mohammed Shafi wrote:
>>
>> On Wed, Aug 24, 2011 at 1:15 AM, John W. Linville
>> <linville@tuxdriver.com>  wrote:
>>>
>>> On Mon, Aug 15, 2011 at 05:56:33PM +0530, Mohammed Shafi wrote:
>>>>
>>>> On Sun, Aug 14, 2011 at 7:04 AM, Larry Finger<Larry.Finger@lwfinger.net>
>>>>  wrote:
>>>>>
>>>>> Kmemleak shows the following kind of memory leak for ath9k_htc:
>>>>>
>>>>> unreferenced object 0xffff88004542f200 (size 512):
>>>>>  comm "khubd", pid 977, jiffies 4317632516 (age 16855.868s)
>>>>>  hex dump (first 32 bytes):
>>>>>    00 00 00 0a 00 00 00 00 00 02 01 05 00 00 02 01  ................
>>>>>    00 00 00 00 00 00 81 38 02 00 00 00 33 33 30 30  .......8....3300
>>>>>  backtrace:
>>>>>    [<ffffffff81122d77>] create_object+0x127/0x2b0
>>>>>    [<ffffffff813580b1>] kmemleak_alloc+0x21/0x50
>>>>>    [<ffffffff8111f383>] __kmalloc_node_track_caller+0x153/0x220
>>>>>    [<ffffffff812b703e>] __alloc_skb+0x7e/0x170
>>>>>    [<ffffffffa0833331>] htc_connect_service+0x111/0x200 [ath9k_htc]
>>>>>    [<ffffffffa083bb90>] ath9k_init_htc_services+0x240/0x2b0 [ath9k_htc]
>>>>>    [<ffffffffa083c1ca>] ath9k_htc_probe_device+0xea/0xa50 [ath9k_htc]
>>>>>    [<ffffffffa08338dc>] ath9k_htc_hw_init+0xc/0x30 [ath9k_htc]
>>>>>    [<ffffffffa08356ba>] ath9k_hif_usb_probe+0x1ca/0x420 [ath9k_htc]
>>>>>    [<ffffffffa00a2279>] usb_probe_interface+0xb9/0x160 [usbcore]
>>>>>    [<ffffffff81279379>] driver_probe_device+0x89/0x1a0
>>>>>    [<ffffffff8127958b>] __device_attach+0x4b/0x60
>>>>>    [<ffffffff81278024>] bus_for_each_drv+0x64/0x90
>>>>>    [<ffffffff81279231>] device_attach+0xa1/0xb0
>>>>>    [<ffffffff81278a25>] bus_probe_device+0x25/0x40
>>>>>    [<ffffffff81276d2a>] device_add+0x55a/0x630
>>>>>
>>>>> The device is a TP-Link TL-WN722N. The output from lsusb is "ID
>>>>> 0cf3:9271
>>>>> Atheros Communications, Inc. AR9271 802.11n".
>>>>>
>>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>>> Cc: Stable<stable@kernel.org>
>>>>> ---
>>>>>
>>>>> This patch certainly fixes a leak. I'm testing to see if there are
>>>>> others.
>>>>
>>>> Hi Larry,
>>>>
>>>> thanks for finding this.
>>>> I remember seeing this memleaks sometime back and thought this patch
>>>> might help(i think same as yours with some more corner cases)
>>>> https://patchwork.kernel.org/patch/1016752/
>>>> but I found there were still some memory leaks, I was unsure where I
>>>> am missing. if you are sure that this addresses the issue, we can send
>>>> a patch.
>>>
>>> Ping?  Is this the patch we want?  Or something else?
>>
>> Hi John,
>>
>> the complete patch is posted
>> http://www.spinics.net/lists/linux-wireless/msg75134.html
>> Vasanth said that at some scenario's with the above patch it may cause
>> some panics.
>> based on the maintainers concerns/doubts lets drop this patch. myself
>> and Larry still noticed few more memory leaks. I think we better drop
>> this patch and fix it completely/tested. as I am with some other
>> critical tasks we will soon address this.
>>
>> Larry if you have any thoughts, please share.
>
> Dropping the current patches seems right with me. I hope to get time to work
> on this, but I also have some other things to do. Perhaps, we can get a
> patch with the subset of leaks in the error path that do not have any
> complications. Those would be easy, and then we can get the others later.

yes sure, once I get some time to test and understand this completely. thanks!

>
> Larry
>



-- 
shafi
