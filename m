Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:46697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZAJOfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 09:35:38 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3627534fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 06:35:35 -0800 (PST)
Message-ID: <4968B233.5050401@gmail.com> (sfid-20090110_153545_247303_EEF0EA6B)
Date: Sat, 10 Jan 2009 15:35:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Add debug code for EEPROM
References: <20090104173252.GA5944@makis> <49610E8D.9080807@gmail.com> <40f31dec0901091637u70ad5c97g3915d5b2b8726e88@mail.gmail.com>
In-Reply-To: <40f31dec0901091637u70ad5c97g3915d5b2b8726e88@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis napsal(a):
> Hello Jiri and thanks a lot for the review ;-)
> 
> 2009/1/4 Jiri Slaby <jirislaby@gmail.com>:
>>> +/* debugfs: EEPROM stuff */
>>> +
>>> +/* EEPROM Header (common) */
>>> +static ssize_t read_file_eeprom_header(struct file *file, char __user *user_buf,
>>> +                                size_t count, loff_t *ppos)
>>> +{
>>> +
>>> +     struct ath5k_softc *sc = file->private_data;
>>> +     struct ath5k_hw *ah = sc->ah;
>>> +     struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
>>> +     char buf[2000];
>> Please don't use that much memory from stack. 2k is way too much. Note that
>> you use yet another bunch of stack (next 3k here on 64-bit) by
>> ath5k_eeprom_info and 32-bit x86 can still be configured with 4k stacks.
>>
>> Convert both of them to dynamically allocated buffers.
>>
> 
> Why dynamically allocated buffers (can you point out some docs on
> these please ?) ? The length of each file (what we print) is standard.
> I understand that we use too much stack here but we can work this out
> eg. by using a pointer to ath5k_eeprom_info or something like that.

Yes, no problem in changing it to a pointer. Anyway the buf should be
kmalloc'ed anyway.

> I
> checked out user_buffer btw and it's 4K, sometimes it's not much for
> calibration data (eg. on RF5111 that we have 10 points per pd gain
> curve or RF2413+ that we can have multiple pd gain curves per
> channel).

I don't understand here. user_buf is sized by userspace application. E.g.
cat on my system requests user_buf of size 1K. simple_read_from_buffer()
takes care about multiple invocations of fops.read function by looking at
ppos parameter and filling user_buf by correct contents (some offset in from
param). BTW as a side-effect, it is possible, that the user will get
different info in these split reads.

>> dtto
>>
> 
> What does dtto mean ?

Oops, as I checked right now, this shortcut is commonly used only in czech.
It should be detto or ditto (and it means "the same as above"), sorry for
the confusion.
