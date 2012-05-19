Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4472 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab2ESIqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:46:21 -0400
Message-ID: <4FB75DCB.9070001@broadcom.com> (sfid-20120519_104633_781807_ED924713)
Date: Sat, 19 May 2012 10:46:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac: use sprom from bcma
References: <20120517191339.GA17018@elgon.mountain>
 <4FB69F25.3040707@hauke-m.de>
In-Reply-To: <4FB69F25.3040707@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2012 09:12 PM, Hauke Mehrtens wrote:
> On 05/17/2012 09:13 PM, Dan Carpenter wrote:
>> Hello Hauke, Arend,
>>
>> The patch 898d3c3b2462: "brcmsmac: use sprom from bcma" from Apr 29, 
>> 2012, leads to the following warning:
>> drivers/net/wireless/brcm80211/brcmsmac/channel.c:645 
>> brcms_c_country_valid()
>> 	 error: buffer overflow 'ccode' 2 <= 2
>>
>> -       if (ccode && brcms_c_country_valid(ccode))
>> -               strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
>> +       if (sprom->alpha2 && brcms_c_country_valid(sprom->alpha2))
>>                                                    ^^^^^^^^^^^^^
>> This is a two character array.  It's not NULL terminated.
>>
>> +               strncpy(wlc->pub->srom_ccode, sprom->alpha2, sizeof(sprom->alpha2));
>>
>> But in brcms_c_country_valid() we check for the NULL terminator.
>>
>>    637  static bool brcms_c_country_valid(const char *ccode)
>>    638  {
>>    639          /*
>>    640           * only allow ascii alpha uppercase for the first 2
>>    641           * chars.
>>    642           */
>>    643          if (!((0x80 & ccode[0]) == 0 && ccode[0] >= 0x41 && ccode[0] <= 0x5A &&
>>    644                (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A &&
>>    645                ccode[2] == '\0'))
>>                       ^^^^^^^^^^^^^^^^
>> Here.
>>
>>    646                  return false;
>>
>> My guess is that this works because -> leddc_on_time is mostly zero.
>>
>> regards,
>> dan carpenter
>>
> Hi Dan,
> 
> your guess is probably right, but I do not know want is the best
> solution to fix this. I set this to 2 byte as there are just two bytes
> memory for this in the sprom. In the nvram of some SoC I also found a 3
> letter code ccode=US2 and an other wrong two letter code ccode=Q2. What
> is the way we should handle this?

As the problem seemed to be with the available space in ssb_sprom
structure I waited for your reply. The country codes in sprom are not
wrong. However, they are only meaningful in regulatory code in the
proprietary driver as CRDA only knows ISO country names (and "00").

So country codes within SPROM that are more than two characters or one
letter and one number are meaningless to CRDA and should not be passed
to CRDA.

> 1. just read the first 2 bytes and ignore the rest -> change
> brcms_c_country_valid() and some SoC parsing code.
> 
> 2. read the first 2 bytes and reject longer codes as completely invalid
> (probably just found in nvram on SoCs) -> change brcms_c_country_valid()
> 
> 3. read 4 (or more) bytes and let brcmsmac decide what is a valid code
> -> change sprom struct and some more code
> 
> I would vote for number 2.
> 
> @Arend by the way how should the code EU or 0 be handled? It is used on
> all my recent SoCs.
> 

There are patches being made by Seth Forshee to have brcmsmac make use
of the regulatory framework. So we probably should add a ruleset for EU
when those patches are applied. Not sure what you mean by code 0. Is it
the character '0' or '\0'.

Gr. AvS

