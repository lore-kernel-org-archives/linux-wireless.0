Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1097 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab1FON7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 09:59:30 -0400
Message-ID: <4DF8BAB3.2000705@broadcom.com> (sfid-20110615_155941_083511_EE54511A)
Date: Wed, 15 Jun 2011 15:59:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: [RFC][WORTH IT?][PATCH] bcma: make use of crc8 lib
References: <1308138814-12235-1-git-send-email-zajec5@gmail.com>
 <4DF8A0EF.5030702@broadcom.com>
In-Reply-To: <4DF8A0EF.5030702@broadcom.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 02:09 PM, Arend van Spriel wrote:
> On 06/15/2011 01:53 PM, Rafał Miłecki wrote:
>>    static u8 bcma_sprom_crc(const u16 *sprom)
>>    {
>> -	int word;
>> -	u8 crc = 0xFF;
>> +	u8 crc;
>> +	u8 sprom2[SSB_SPROMSIZE_WORDS_R4 * 2 - 1];
>> +	u8 table[CRC8_TABLE_SIZE];
>> +	u16 word;
>>
>> +	/* u16 to u8 */
>>    	for (word = 0; word<   SSB_SPROMSIZE_WORDS_R4 - 1; word++) {
>> -		crc = bcma_crc8(crc, sprom[word]&   0x00FF);
>> -		crc = bcma_crc8(crc, (sprom[word]&   0xFF00)>>   8);
>> +		sprom2[word * 2] = sprom[word]&   0x00FF;
>> +		sprom2[(word * 2) + 1] = (sprom[word]&   0xFF00)>>   8;
>>    	}
>> -	crc = bcma_crc8(crc, sprom[SSB_SPROMSIZE_WORDS_R4 - 1]&   0x00FF);
>> +	/* 127th byte */
>> +	sprom2[(SSB_SPROMSIZE_WORDS_R4 * 2) - 2] =
>> +				sprom[SSB_SPROMSIZE_WORDS_R4 - 1]&   0x00FF;
>> +
>> +	/* Prepare table, 0xAB is x^8 + x^7 + x^6 + x^4 + x^2 + 1 */
>> +	crc8_populate_lsb(table, 0xAB);
>> +
>> +	/* Calculate */
>> +	crc = crc8(table, sprom2, (SSB_SPROMSIZE_WORDS_R4 * 2) - 1, 0xFF);
>>    	crc ^= 0xFF;
>>
>>    	return crc;
> You could do (I think):
>
> crc8_populate_lsb(table, 0xAB);
> for (word = 0; word<   SSB_SPROMSIZE_WORDS_R4; word++) {
> 	u16 val = cpu_to_le16(sprom[word]);
> 	crc = crc8(table,&val, sizeof(u16), crc);
Obviously this should have proper cast here so: (u8 *)&val

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


