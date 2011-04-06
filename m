Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60813 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1DFUkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 16:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <op.vti9ote53ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	<op.vti9ote53ri7v4@arend-laptop>
Date: Wed, 6 Apr 2011 22:40:50 +0200
Message-ID: <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/6 Arend van Spriel <arend@broadcom.com>:
> On Wed, 06 Apr 2011 20:02:20 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> 2011/4/6 Arend van Spriel <arend@broadcom.com>:
>>>
>>> 1. Term Broadcom AI
>>>
>>
>> I'm still little confused with that, let me read old mails, google a
>> little, etc. I though AMBA AXI is AI on ARM host, give me some time
>> for this.
>
> It is the interconnect or backplane which the cores in the chip are hooked
> up to. See the ARM website for some more info:
> http://www.arm.com/products/system-ip/interconnect/axi/index.php
>
>>
>>> 2. Bus registration
>>>
>>
>> You should drop initialization (to do not perform it twice), but
>> ChipCommon ops are still allowed. See: bcmai_cc_read32,
>> bcmai_cc_write32, bcmai_cc_mask32, bcmai_cc_set32, bcmai_cc_maskset32.
>>
>> You can simply call:
>> bcmai_cc_read32(mydev->bus.drv_cc, CC_REGISTER);
>>
>> There is nothing stopping you from registering one driver for few
>> cores. We do this in b43 for old SSBs with 2 wireless cores. Of course
>> this is not possible to use 2 drivers for 1 core at the same time.
>
> So in theory 2 drivers for 2 separate cores can both call bcmai_cc_read32().
> 2 drivers for 1 core indeed seems a 'little awkward' ;-)

If we want to have two drivers working on two (different) cores
simultaneously, we will have to add trivial mutex to group core
switching with core operation (read/write).

We could also use the fact that [base + (2 * BCMAI_CORE_SIZE)] always
points to PCIe and [base + (3 * BCMAI_CORE_SIZE)] always points to
ChipCommon. For that cores we do not need core switching and so we do
not need mutexes. (Don't take my "always" too seriously, just wanted
to explain it easier, this can be not 100% always).

-- 
Rafał
