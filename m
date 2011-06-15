Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56635 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1FOS37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 14:29:59 -0400
Received: by pvg12 with SMTP id 12so507680pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 11:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF8A0EF.5030702@broadcom.com>
References: <1308138814-12235-1-git-send-email-zajec5@gmail.com>
	<4DF8A0EF.5030702@broadcom.com>
Date: Wed, 15 Jun 2011 20:29:58 +0200
Message-ID: <BANLkTim3-sxkHmfiiwR-mLWfyUKxpSVBQA@mail.gmail.com> (sfid-20110615_203002_535848_DF37EB3B)
Subject: Re: [RFC][WORTH IT?][PATCH] bcma: make use of crc8 lib
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 czerwca 2011 14:09 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 06/15/2011 01:53 PM, Rafał Miłecki wrote:
>>
>>  static u8 bcma_sprom_crc(const u16 *sprom)
>>  {
>> -       int word;
>> -       u8 crc = 0xFF;
>> +       u8 crc;
>> +       u8 sprom2[SSB_SPROMSIZE_WORDS_R4 * 2 - 1];
>> +       u8 table[CRC8_TABLE_SIZE];
>> +       u16 word;
>>
>> +       /* u16 to u8 */
>>        for (word = 0; word<  SSB_SPROMSIZE_WORDS_R4 - 1; word++) {
>> -               crc = bcma_crc8(crc, sprom[word]&  0x00FF);
>> -               crc = bcma_crc8(crc, (sprom[word]&  0xFF00)>>  8);
>> +               sprom2[word * 2] = sprom[word]&  0x00FF;
>> +               sprom2[(word * 2) + 1] = (sprom[word]&  0xFF00)>>  8;
>>        }
>> -       crc = bcma_crc8(crc, sprom[SSB_SPROMSIZE_WORDS_R4 - 1]&  0x00FF);
>> +       /* 127th byte */
>> +       sprom2[(SSB_SPROMSIZE_WORDS_R4 * 2) - 2] =
>> +                               sprom[SSB_SPROMSIZE_WORDS_R4 - 1]&
>>  0x00FF;
>> +
>> +       /* Prepare table, 0xAB is x^8 + x^7 + x^6 + x^4 + x^2 + 1 */
>> +       crc8_populate_lsb(table, 0xAB);
>> +
>> +       /* Calculate */
>> +       crc = crc8(table, sprom2, (SSB_SPROMSIZE_WORDS_R4 * 2) - 1, 0xFF);
>>        crc ^= 0xFF;
>>
>>        return crc;
>
> You could do (I think):
>
> crc8_populate_lsb(table, 0xAB);
> for (word = 0; word<  SSB_SPROMSIZE_WORDS_R4; word++) {
>        u16 val = cpu_to_le16(sprom[word]);
>        crc = crc8(table,&val, sizeof(u16), crc);
> }

Maybe not a perfect/optimal solution (crc8 focuses on tables, we do
double loop instead) but should work. Thanks for the tip.

-- 
Rafał
