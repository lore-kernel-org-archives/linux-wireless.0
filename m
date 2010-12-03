Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55755 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0LCBJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 20:09:50 -0500
Received: by vws16 with SMTP id 16so1489912vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 17:09:49 -0800 (PST)
Message-ID: <4CF84354.1090803@lwfinger.net>
Date: Thu, 02 Dec 2010 19:09:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ssb: Attempt to recover from SPROM CRC error
References: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net>	 (sfid-20101202_173713_192185_FFFFFFFF949EBC0D) <1291328154.13801.0.camel@maggie>
In-Reply-To: <1291328154.13801.0.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2010 04:15 PM, Michael Büsch wrote:
> On Thu, 2010-12-02 at 10:36 -0600, Larry Finger wrote: 
>> Current code defaults to SPROM revision 1 if there is a CRC error. In at
>> least one known case, most of the corrupt contents are reasonable and
>> it is possible to extract the correct MAC address and TX power settings
>> from what is read. With this patch, an attempt is made to match the
>> apparent revision number with certain SPROM signatures. For those revisions
>> without such a feature, a reasonable guess is made. If the apparent
>> revision is invalid, or if the signature does not match, the previous
>> behavior is kept.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> Could you please test this patch with your card?
>>
>> Thanks,
>>
>> Larry
>> ---
>>
>> Index: linux-2.6/drivers/ssb/pci.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/ssb/pci.c
>> +++ linux-2.6/drivers/ssb/pci.c
>> @@ -620,6 +620,7 @@ static int ssb_pci_sprom_get(struct ssb_
>>  	const struct ssb_sprom *fallback;
>>  	int err = -ENOMEM;
>>  	u16 *buf;
>> +	u16 revision;
>>  
>>  	if (!ssb_is_sprom_available(bus)) {
>>  		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
>> @@ -671,6 +672,50 @@ static int ssb_pci_sprom_get(struct ssb_
>>  			}
>>  			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
>>  				   " SPROM CRC (corrupt SPROM)\n");
>> +			/* At this point, we have a faulty SPROM image.
>> +			 * In case only part of it is corrupt, try to
>> +			 * determine what rev we might have */
>> +			revision = buf[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF;
> 
> I think this could possibly overrun the buffer, or did I get something
> wrong?

At this point, we have gotten a CRC error with the small SPROM and expanded the
memory for the 440 byte size, and gotten a second CRC error. This test will be
OK here.

Larry
