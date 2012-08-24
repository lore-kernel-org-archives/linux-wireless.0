Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1731 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab2HXIhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 04:37:35 -0400
Message-ID: <50373D46.2090502@broadcom.com> (sfid-20120824_103743_009112_49DB1935)
Date: Fri, 24 Aug 2012 10:37:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcma: expose cc sprom to sysfs
References: <20120816190616.GE6726@eris.garyseven.net>
 <502E4B70.5090900@broadcom.com>
 <CACna6ryXk-rL49uhe2nOqReYW8QVu-av0zDcbNOfwTEUa0q2tw@mail.gmail.com>
 <5036984A.6060004@lwfinger.net>
In-Reply-To: <5036984A.6060004@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2012 10:53 PM, Larry Finger wrote:
> On 08/23/2012 02:44 PM, Rafał Miłecki wrote:
>> 2012/8/17 Arend van Spriel <arend@broadcom.com>:
>>> On 08/16/2012 09:06 PM, Saul St. John wrote:
>>>>
>>>> On BCMA devices with a ChipCommon core of revision 31 or higher, the
>>>> device
>>>> SPROM can be accessed through CC core registers. This patch exposes the
>>>> SPROM on such devices for read/write access as a sysfs attribute.
>>>>
>>>> Tested on a MacBookPro8,2 with BCM4331.
>>>>
>>>> Cc: Rafał Miłecki <zajec5@gmail.com>
>>>> Cc: John W. Linville <linville@tuxdriver.com>
>>>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>>>
>>>
>>> Hi Saul,
>>>
>>> I was still planning to come back to your reply on August 14. Just
>>> wanted to
>>> reply to this patch as I still feel it is a bad thing to open up the
>>> sprom
>>> as a whole. I can see the use-cases you mentioned as useful, but
>>> maybe we
>>> can get a specific solution for that.
>>
>> I agree with Arend's doubts, on the other hand it would be nice to
>> provide some workaround for that stupid HP wifi blacklisting.
>>
>> Providing a way to overwrite just a vendor is really close to allowing
>> overwriting anything. In that case we probably should just allow
>> writing whole SPROM... Which again, is sth some want to avoid.
>>
>>
>> I wonder if we could write some user-space tool for writing SPROM.
>> Accessing ChipCommon registers is quite trivial, the thing I'm not
>> familiar with is accessing PCIE Wifi card registers. I know there are
>> tools for accessing GPU card regs. They work really well, I wonder if
>> we can use the same method for Wifi cards?
>> If so, we could write user-space app and keep this out of kernel.
>> Maybe we could even extend that tool to cover ssb cards and drop SPROM
>> on SSB writing support from kernel?
>
> This idea sounds good to me. The only valid use of the ssb SPROM writing
> was when we found some G-PHY cards that had the BT compatibility setting
> wrong. Now there is a set of quirks that eliminate that need for
> rewriting the SPROM.
>
> With a separate utility, we can control what parameters can be changed.
> The vendor codes are one possibility. What else would be useful? I have
> seen changing the MAC address be mentioned, but I would argue against
> that. There are too many possibilities for misuse.

That was indeed my concern. I know people have their legitimate reasons 
for it, but it is more for convenience as it is a necessity. Given that 
MAC spoofing also allows misuse.

The same is true for the country code. When left to the user they can 
select a country code with a less restrictive regulatory parameters for 
which the device might not be certified. With the utility we could also 
control how the parameters are changed. However, the country code change 
on system level is already covered and properly restricted by the 
regulatory framework.

Gr. AvS

