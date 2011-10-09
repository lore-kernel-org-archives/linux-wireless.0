Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1JIIsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 04:48:25 -0400
Received: by wwf22 with SMTP id 22so7790166wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Oct 2011 01:48:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111009005107.43a49372@milhouse>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
	<20111009005107.43a49372@milhouse>
Date: Sun, 9 Oct 2011 10:48:22 +0200
Message-ID: <CACna6rz-0TZrwctTZR-YLDHG=xdt4Oc5ShbjCZiad7Cvmh0+hQ@mail.gmail.com> (sfid-20111009_104830_624074_FD387C8F)
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/10/9 Michael Büsch <m@bues.ch>:
> On Sat, 08 Oct 2011 17:28:42 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> The kernel now contains library routines to establish crc8 tables and
>> to calculate the appropriate sums. Use them for ssb.
>
>> +static u8 srom_crc8_table[CRC8_TABLE_SIZE];
>> +
>> +/* Polynomial:   x^8 + x^7 + x^6 + x^4 + x^2 + 1   */
>> +#define SROM_CRC8_POLY       0xAB
>> +
>> +static inline void ltoh16_buf(u16 *buf, unsigned int size)
>>  {
>> +     size /= 2;
>> +     while (size--)
>> +             *(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
>> +}
>>
>> -     return crc;
>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>> +{
>> +     size /= 2;
>> +     while (size--)
>> +             *(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>>  }
>
>>               return -ENOMEM;
>> +     crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
>>       bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
>>       sprom_do_read(bus, buf);
>> +     /* convert to le */
>> +     htol16_buf(buf, 2 * bus->sprom_size);
>
>>               bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
>>               sprom_do_read(bus, buf);
>> +             htol16_buf(buf, 2 * bus->sprom_size);
>>               err = sprom_check_crc(buf, bus->sprom_size);
>
>> +     /* restore endianess */
>> +     ltoh16_buf(buf, 2 * bus->sprom_size);
>>       err = sprom_extract(bus, sprom, buf, bus->sprom_size);
>
> This endianness stuff is _really_ ugly.
> Does this patch decrease the code size, at least? I'll almost doubt it.
> If it doesn't, why are we actually doing this?
> It doesn't even decrease the .data size. Worse, it converts a .const
> table to a .data table.
>
> Just my 2 cents.

Agree. I already tried converting bcma to use crc8:
[RFC][WORTH IT?][PATCH] bcma: make use of crc8 lib
http://lists.infradead.org/pipermail/b43-dev/2011-June/001466.html

But resigned, it was introducing some hacks or not optimal ops, I
decided it's not worth it.

Even Arend said their brcm80211 is hacky about crc8 usage:

W dniu 15 czerwca 2011 21:26 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> Agree. In brcm80211 we convert the entire sprom, calculate, and convert it
> back. Also not perfect I think as it loops over de sprom data twice.

-- 
Rafał
