Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63187 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934387Ab2HWUxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 16:53:35 -0400
Received: by ialo24 with SMTP id o24so1991282ial.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 13:53:34 -0700 (PDT)
Message-ID: <5036984A.6060004@lwfinger.net> (sfid-20120823_225402_022699_5F3757EF)
Date: Thu, 23 Aug 2012 15:53:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcma: expose cc sprom to sysfs
References: <20120816190616.GE6726@eris.garyseven.net> <502E4B70.5090900@broadcom.com> <CACna6ryXk-rL49uhe2nOqReYW8QVu-av0zDcbNOfwTEUa0q2tw@mail.gmail.com>
In-Reply-To: <CACna6ryXk-rL49uhe2nOqReYW8QVu-av0zDcbNOfwTEUa0q2tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2012 02:44 PM, Rafał Miłecki wrote:
> 2012/8/17 Arend van Spriel <arend@broadcom.com>:
>> On 08/16/2012 09:06 PM, Saul St. John wrote:
>>>
>>> On BCMA devices with a ChipCommon core of revision 31 or higher, the
>>> device
>>> SPROM can be accessed through CC core registers. This patch exposes the
>>> SPROM on such devices for read/write access as a sysfs attribute.
>>>
>>> Tested on a MacBookPro8,2 with BCM4331.
>>>
>>> Cc: Rafał Miłecki <zajec5@gmail.com>
>>> Cc: John W. Linville <linville@tuxdriver.com>
>>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>>
>>
>> Hi Saul,
>>
>> I was still planning to come back to your reply on August 14. Just wanted to
>> reply to this patch as I still feel it is a bad thing to open up the sprom
>> as a whole. I can see the use-cases you mentioned as useful, but maybe we
>> can get a specific solution for that.
>
> I agree with Arend's doubts, on the other hand it would be nice to
> provide some workaround for that stupid HP wifi blacklisting.
>
> Providing a way to overwrite just a vendor is really close to allowing
> overwriting anything. In that case we probably should just allow
> writing whole SPROM... Which again, is sth some want to avoid.
>
>
> I wonder if we could write some user-space tool for writing SPROM.
> Accessing ChipCommon registers is quite trivial, the thing I'm not
> familiar with is accessing PCIE Wifi card registers. I know there are
> tools for accessing GPU card regs. They work really well, I wonder if
> we can use the same method for Wifi cards?
> If so, we could write user-space app and keep this out of kernel.
> Maybe we could even extend that tool to cover ssb cards and drop SPROM
> on SSB writing support from kernel?

This idea sounds good to me. The only valid use of the ssb SPROM writing was 
when we found some G-PHY cards that had the BT compatibility setting wrong. Now 
there is a set of quirks that eliminate that need for rewriting the SPROM.

With a separate utility, we can control what parameters can be changed. The 
vendor codes are one possibility. What else would be useful? I have seen 
changing the MAC address be mentioned, but I would argue against that. There are 
too many possibilities for misuse.

Larry

