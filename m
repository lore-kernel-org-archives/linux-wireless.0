Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39930 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934255Ab2HWTob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 15:44:31 -0400
Received: by weyx8 with SMTP id x8so606250wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 12:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502E4B70.5090900@broadcom.com>
References: <20120816190616.GE6726@eris.garyseven.net>
	<502E4B70.5090900@broadcom.com>
Date: Thu, 23 Aug 2012 21:44:30 +0200
Message-ID: <CACna6ryXk-rL49uhe2nOqReYW8QVu-av0zDcbNOfwTEUa0q2tw@mail.gmail.com> (sfid-20120823_214446_575854_2C1BC919)
Subject: Re: [PATCH 2/2] bcma: expose cc sprom to sysfs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Saul St. John" <saul.stjohn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/17 Arend van Spriel <arend@broadcom.com>:
> On 08/16/2012 09:06 PM, Saul St. John wrote:
>>
>> On BCMA devices with a ChipCommon core of revision 31 or higher, the
>> device
>> SPROM can be accessed through CC core registers. This patch exposes the
>> SPROM on such devices for read/write access as a sysfs attribute.
>>
>> Tested on a MacBookPro8,2 with BCM4331.
>>
>> Cc: Rafał Miłecki <zajec5@gmail.com>
>> Cc: John W. Linville <linville@tuxdriver.com>
>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>
>
> Hi Saul,
>
> I was still planning to come back to your reply on August 14. Just wanted to
> reply to this patch as I still feel it is a bad thing to open up the sprom
> as a whole. I can see the use-cases you mentioned as useful, but maybe we
> can get a specific solution for that.

I agree with Arend's doubts, on the other hand it would be nice to
provide some workaround for that stupid HP wifi blacklisting.

Providing a way to overwrite just a vendor is really close to allowing
overwriting anything. In that case we probably should just allow
writing whole SPROM... Which again, is sth some want to avoid.


I wonder if we could write some user-space tool for writing SPROM.
Accessing ChipCommon registers is quite trivial, the thing I'm not
familiar with is accessing PCIE Wifi card registers. I know there are
tools for accessing GPU card regs. They work really well, I wonder if
we can use the same method for Wifi cards?
If so, we could write user-space app and keep this out of kernel.
Maybe we could even extend that tool to cover ssb cards and drop SPROM
on SSB writing support from kernel?

-- 
Rafał
