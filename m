Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:55369 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZAJAha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:37:30 -0500
Received: by yw-out-2324.google.com with SMTP id 9so3114047ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 16:37:28 -0800 (PST)
Message-ID: <40f31dec0901091637u70ad5c97g3915d5b2b8726e88@mail.gmail.com> (sfid-20090110_013734_507556_BA90EC33)
Date: Sat, 10 Jan 2009 02:37:28 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Add debug code for EEPROM
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
In-Reply-To: <49610E8D.9080807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090104173252.GA5944@makis> <49610E8D.9080807@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jiri and thanks a lot for the review ;-)

2009/1/4 Jiri Slaby <jirislaby@gmail.com>:
>> +/* debugfs: EEPROM stuff */
>> +
>> +/* EEPROM Header (common) */
>> +static ssize_t read_file_eeprom_header(struct file *file, char __user *user_buf,
>> +                                size_t count, loff_t *ppos)
>> +{
>> +
>> +     struct ath5k_softc *sc = file->private_data;
>> +     struct ath5k_hw *ah = sc->ah;
>> +     struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
>> +     char buf[2000];
>
> Please don't use that much memory from stack. 2k is way too much. Note that
> you use yet another bunch of stack (next 3k here on 64-bit) by
> ath5k_eeprom_info and 32-bit x86 can still be configured with 4k stacks.
>
> Convert both of them to dynamically allocated buffers.
>

Why dynamically allocated buffers (can you point out some docs on
these please ?) ? The length of each file (what we print) is standard.
I understand that we use too much stack here but we can work this out
eg. by using a pointer to ath5k_eeprom_info or something like that. I
checked out user_buffer btw and it's 4K, sometimes it's not much for
calibration data (eg. on RF5111 that we have 10 points per pd gain
curve or RF2413+ that we can have multiple pd gain curves per
channel).

>> +/* EEPROM Header (per mode) */
>> +static unsigned int dump_calinfo_for_mode(struct ath5k_hw *ah, int mode,
>> +                             char __user *user_buf, size_t count, loff_t *ppos)
>> +{
>> +     struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
>> +     unsigned int len = 0;
>> +     char buf[2000];
>
> dtto
>

What does dtto mean ?

>> +     int i;
> ...
>> +     len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
>
> simple_read_from_buffer can fail and returns negative errno in that case,
> change dump_calinfo_for_mode return type appropriately.
>

ACK

> Happy new year!

Thank you verry much, happy new year !! ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
