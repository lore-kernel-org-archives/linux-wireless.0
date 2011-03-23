Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2458 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab1CWNya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 09:54:30 -0400
To: "Randy Dunlap" <rdunlap@xenotime.net>,
	=?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
cc: "george@znau.edu.ua" <george@znau.edu.ua>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
 <1300738586-7157-2-git-send-email-arend@broadcom.com>
 <20110321132848.e4e846a5.rdunlap@xenotime.net>
 <op.vsslrqf23ri7v4@arend-laptop> <1300888183.18815.5.camel@Nokia-N900>
Date: Wed, 23 Mar 2011 14:54:12 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsst8mfl3ri7v4@arend-laptop>
In-Reply-To: <1300888183.18815.5.camel@Nokia-N900>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Mar 2011 14:49:43 +0100, Michael Büsch <mb@bu3sch.de> wrote:

>
>> void foobar(void *r, u32 val)
>> {
>>     volatile u32 dummy;
>>
>>     WR_REG(r, val);
>>     dummy = RD_REG(r);
>> }
>>
>> The register read is necessary to assure the register write is properly
>> flushed out in hardware. Could removing the volatile for the dummy
>> variable cause removal of the register read due to code optimization.
>
> It shouldn't optimize the read away as long as the RD_REG uses a  
> volatile pointer internally. Which is the case if you use readl/w/b or  
> ioread... to implement RD_REG

Well, RD_REG(r) is a macro which translates to readb((volatile u8*)r). Are  
you referring to that being a volatile pointer or do you mean that inside  
the accessor function readb the 'r' parameter is treated as a volatile  
pointer.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

