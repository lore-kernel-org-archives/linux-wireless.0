Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63400 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1H2PMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 11:12:35 -0400
Received: by wyg24 with SMTP id 24so4147459wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 08:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
References: <20110827113253.GA1444@ecki>
	<CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
	<CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
Date: Mon, 29 Aug 2011 20:42:33 +0530
Message-ID: <CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com> (sfid-20110829_171239_267644_F517D296)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> But still, the interrupts come. Note that according to
>>> /proc/interrupts, the IRQ line is not shared with any other device.
>>> I did not manage to determine which interrupt it is exactly,
>>> because the device is not in a ready state (SC_OP_INVALID is set)
>>> when they happen (in either scenario that triggers the IRQ storm).
>>> And SC_OP_INVALID is cleared only much later in ath9k_start.
>>>
>>> So, I am at a loss. Any ideas?
>>
>> please provide the lspci -vvvxx.
>> also looking at
>> /sys/kernel/debug/ieee80211/phy0/ath9k$ sudo cat interrupt.
>
> hi, i think this will help, please get the message sudo modprobe ath9k
> debug=0xffffffff.
> few fatal PCI interrupt messages are based on ATH_DEBUG_ANY.
> thanks.
>
we can also try to disable MIB interrupts though its handled properly
now in ath9k

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-09-25/0001-ath9k-disable-MIB-interrupts-to-fix-interrupt-storm.patch


-- 
shafi
