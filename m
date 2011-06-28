Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52685 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1F1PEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 11:04:44 -0400
Received: by wyg8 with SMTP id 8so211602wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 08:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E05F12B.4020302@openwrt.org>
References: <152381309010939@web35.yandex.ru>
	<4E05F12B.4020302@openwrt.org>
Date: Tue, 28 Jun 2011 20:34:43 +0530
Message-ID: <BANLkTi=J8y0TSviVb0Nh6QyVeNu+0sESww@mail.gmail.com> (sfid-20110628_171957_688295_BC6D66DA)
Subject: Re: AR9280 won't initialize
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Misha Shnurapet <shnurapet@fedoraproject.org>,
	Felix Fietkau <nbd@openwrt.org>
Cc: Community support for Fedora users
	<users@lists.fedoraproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/25 Felix Fietkau <nbd@openwrt.org>:
> On 2011-06-25 4:08 PM, Misha Shnurapet wrote:
>>
>> Hi.
>>
>> I have a little problem. I replaced the old BCM4312 card on my Dell mini
>> 1011 (10v) with:
>> 03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
>> Network Adapter (PCI-Express) (rev 01)
>>
>> But it won't work.
>>
>> First it crashed Linux:
>> http://pastebin.com/YmEGcPK8
>>
>> Then I installed a system update:
>> http://funkyimg.com/u2/879/849/2.png
>> http://pastebin.com/hWG6u7VJ
>>
>> And now it is:
>>
>> [   30.589243] ath9k 0000:03:00.0: PCI INT A ->  GSI 17 (level, low) ->
>>  IRQ 17
>> [   30.589269] ath9k 0000:03:00.0: setting latency timer to 64
>> [   30.594884] ath: address test failed addr: 0x00008000 - wr:0xaaaaaaaa
>> != rd:0xaaaa2aaa

this looks really wrong if the memory test itself fails, then all
those REG_READ, REG_WRITES are unreliable and this may be the reason
that your gettsf64 looks weird and hits a warning. also did you try
what Felix had suggested?

>> [   30.594898] ath: Unable to initialize hardware; initialization status:
>> -19
>> [   30.594913] ath9k 0000:03:00.0: Failed to initialize device
>> [   30.594991] ath9k 0000:03:00.0: PCI INT A disabled
>>
>> lsusb:
>> http://pastebin.com/JHYZiDhr
>>
>> Installing the latest stable compat-wireless from source didn't help
>> (bleeding edge won't build).
>>
>> I would appreciate if you help me.
>
> Looks like a hardware issue to me. Try removing the card and plugging it
> back in.
>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
