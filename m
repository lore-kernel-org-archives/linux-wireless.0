Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4871 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3IXHxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 03:53:48 -0400
Received: from [10.176.68.21] (unknown [10.176.68.21]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 6024E207C0 for
 <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 00:53:36 -0700 (PDT)
Message-ID: <524144FF.9020908@broadcom.com> (sfid-20130924_095351_732309_D660C654)
Date: Tue, 24 Sep 2013 09:53:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac causes soft lockup in 3.12-rc1
References: <20130921223440.GA5297@mail.catnarok.net>
 <523FF83D.8030103@broadcom.com>
 <20130924005224.GA27400@mail.catnarok.net>
In-Reply-To: <20130924005224.GA27400@mail.catnarok.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2013 02:52 AM, Michael Stolovitzsky wrote:
> On Mon, Sep 23, 2013 at 10:13:49AM +0200, Arend van Spriel wrote:
>> On 09/22/2013 12:34 AM, Michael Stolovitzsky wrote:
>>> Hi,
>>>
>>> On 3.12-rc1, modprobe brcmsmac causes a soft lockup (trace #1), effectively killing the box. This is a Lenovo S206
>>> with BCM4313 (14e4:4727), which I believe is a bluetooth combo board. After a while,
>>> RCU scheduler code detects a lockup (trace #2).
>>>
>>> This did not happen in 3.11.1, although brcmsmac hasn't worked on this machine
>>> as far as I remember. In  the previous kernels (~3.2.0+), it loads, but the
>>> reception is extremely weak - you must be within few meters to the AP, and the card would
>>> die after several minutes. The proprietary wl.ko driver works fine.
>>>
>>> I've attached the dmesg output, the kernel configuration and the output of lspci -vnn.
>>> I'm comfortable with experimenting; please let me know how I can help here.
>>
>> A fix for this problem has been submitted to John. I think it is in
>> transit to mainline so probably will be in 3.12-rc2.
>>
>> Here the URL of the patch:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/patch/?id=aaa2ced15ad8dca8048666c9f70736424d696a6b
>>
>
> Arend, much thanks and an apology for not checking the patches. I will try this out ASAP.
>
> Is the (presumedly) low RX gain also a known problem with brcmsmac on BCM4313?

The patch is in 3.12-rc2. There have been more reports on that, but it 
still needs to be investigated. Can you provide content of 
/sys/kernel/debug/brcmsmac/bcma*/hardware? You need to have 
CONFIG_BRCMDBG selected.

Regards,
Arend

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


