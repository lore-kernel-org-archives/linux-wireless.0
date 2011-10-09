Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4543 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab1JIJu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 05:50:29 -0400
Message-ID: <4E916E55.30101@broadcom.com> (sfid-20111009_115033_875967_193726DC)
Date: Sun, 9 Oct 2011 11:50:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
 <20111009005107.43a49372@milhouse>
In-Reply-To: <20111009005107.43a49372@milhouse>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2011 12:51 AM, Michael Büsch wrote:
> On Sat, 08 Oct 2011 17:28:42 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> The kernel now contains library routines to establish crc8 tables and
>> to calculate the appropriate sums. Use them for ssb.
> 
>> +static u8 srom_crc8_table[CRC8_TABLE_SIZE];
>> +
>> +/* Polynomial:   x^8 + x^7 + x^6 + x^4 + x^2 + 1   */
>> +#define SROM_CRC8_POLY	0xAB
>> +
>> +static inline void ltoh16_buf(u16 *buf, unsigned int size)
>>  {
>> +	size /= 2;
>> +	while (size--)
>> +		*(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
>> +}
>>  
>> -	return crc;
>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>> +{
>> +	size /= 2;
>> +	while (size--)
>> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>>  }
> 
>>  		return -ENOMEM;
>> +	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
>>  	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
>>  	sprom_do_read(bus, buf);
>> +	/* convert to le */
>> +	htol16_buf(buf, 2 * bus->sprom_size);
> 
>>  		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
>>  		sprom_do_read(bus, buf);
>> +		htol16_buf(buf, 2 * bus->sprom_size);
>>  		err = sprom_check_crc(buf, bus->sprom_size);
> 
>> +	/* restore endianess */
>> +	ltoh16_buf(buf, 2 * bus->sprom_size);
>>  	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
> 
> This endianness stuff is _really_ ugly.

It may seem ugly, but is not new. Choosing a 8-bit crc to check a 16-bit
array is not very efficient considering host endianess. The endianess
was also dealt with in the old version:

-	for (word = 0; word < size - 1; word++) {
-		crc = ssb_crc8(crc, sprom[word] & 0x00FF);
-		crc = ssb_crc8(crc, (sprom[word] & 0xFF00) >> 8);
-	}

It is a bit easier on the eye. I guess the ugliness comes from the fact
that there are two calls to htol16_buf.

A better approach would be to read sprom as bytes and run the crc8 over
the byte array. When ok do ltoh16_buf once.

> Does this patch decrease the code size, at least? I'll almost doubt it.
> If it doesn't, why are we actually doing this?

Probably for the same reason why struct list_head and related functions
are used. Trying to use what is commonly available in the kernel.

> It doesn't even decrease the .data size. Worse, it converts a .const
> table to a .data table.

True. .code size became .data size, because of the flexibility that the
table is generated for a given polynomial. Every 'bility' comes with a
price and this seems not too pricy.

> Just my 2 cents.
> 

Gr. AvS

