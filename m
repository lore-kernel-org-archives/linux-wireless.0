Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36326 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbLDKax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 05:30:53 -0500
Received: by lfs39 with SMTP id 39so105640163lfs.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 02:30:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0P5A6q1yQwrgagO5rVpE=6Zk0Fq2gNA-WVhkc7Ov2NdQ@mail.gmail.com>
References: <20151203220522.GB11138@jessup.stsp.name>
	<CANUX_P2qxe+BqLPPWOs5uWiBY5nO4e8C1A7gkkYnvrTG270YFQ@mail.gmail.com>
	<CANUX_P0P5A6q1yQwrgagO5rVpE=6Zk0Fq2gNA-WVhkc7Ov2NdQ@mail.gmail.com>
Date: Fri, 4 Dec 2015 12:30:52 +0200
Message-ID: <CANUX_P19Aq_PKyUscg8jBkH=XJim1aut9kTmNUrVMeRt-upNyw@mail.gmail.com> (sfid-20151204_113058_674026_4D83B9D2)
Subject: Re: iwlwifi A-MSDU tx
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stefan Sperling <stsp@openbsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding the right mailing list this time.

On Fri, Dec 4, 2015 at 10:18 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Fri, Dec 4, 2015 at 9:35 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> Hi,
>>
>> On Fri, Dec 4, 2015 at 12:05 AM, Stefan Sperling <stsp@openbsd.org> wrote:
>>> Hi Emmanuel,
>>>
>>> As part of implementing 802.11n support in OpenBSD I'm looking for
>>> an AP which sends A-MSDUs. Preferrably under software control rather
>>> than firmware.
>>>
>>> I found your iwlwifi A-MSDU patches at
>>> http://marc.info/?l=linux-wireless&m=144553311122495&w=2
>>> and http://marc.info/?l=linux-wireless&m=144553311822496&w=2
>>>
>>> Would these patches make it possible to run an AP with an 5300 or 7260
>>> card and send A-MSDUs? That would be great as I have the necessary hardware.
>>
>> 7260 will go. Not 5300.
>> Note that this code simulates Tx TCP Csum offload. I did that to write
>> the code while we still don't have the hardware that has this
>> capability. But for testing purposes, it should do the work. The
>> testing teams have reported that AP mode didn't work quite well with
>> this and I haven't taken the time to look into yet, but if you see
>> issues, please report them or even better: fix them :)
>>
>>>
>>> Which Linux tree do these patches apply to? I've tried the following
>>> but had no luck in getting these patches applied without rejects:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
>>>
>>
>> Right. These patches had a long internal review cycle. They are now
>> merge in our internal tree.
>> You can find them in our internal tree [1] (backport based). I will
>> push them soon in iwlwifi-next.git.
>
> I forgot to mention that you need to change the define of
> IWL_MVM_SW_TX_CSUM_OFFLOAD to 1.
>
>>
>> [1] - https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/
>> Please read https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release#how_to_install_the_driver.
>>
>>> Thanks,
>>> Stefan
