Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:43178 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbZFBSRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 14:17:55 -0400
Message-ID: <4A256CCC.5040908@free.fr>
Date: Tue, 02 Jun 2009 20:17:48 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 : unaligned access on mips
References: <4A244E19.7090501@free.fr> <4A244F6C.3000509@free.fr> <200906021720.39080.mb@bu3sch.de>
In-Reply-To: <200906021720.39080.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

Michael Buesch wrote:
> On Tuesday 02 June 2009 00:00:12 matthieu castet wrote:
>> matthieu castet wrote:
>>> Hi,
>>>
>>> b43_generate_plcp_hdr generate unaligned access on mips with gcc [1] 
>>> from openwrt.
>>>
>>> A small testcase [2] show that &plcp->data is access as a 32 bit aligned 
>>> variable (see the "lw      $2,0($4)" and "sw      $2,0($4)").
>>> I don't know enough mips to know if it is a gcc bug (ignoring the packed 
>>> attribute) or something missing in b43 code.
>> For example using "plcp->data" instead "*data" produce the correct code.
> 
> Uhm, I'm not sure. This code has been in the driver as-is forever and I don't
> see any unaligned access issues on mips (I checked a month or so ago).
Where does this pointer come from ? May be other code change change this 
pointer alignement?
Which toolchain did you use ?
Could you try to build the testcase I posted and see which code it 
generate ?


> The plcp data structure is also __attribute__((packed)), so there can't be any
> unaligned accesses, as gcc is required to _expect_ unaligned accesses on structures
> with packed attribute. So it is required to do byte accesses on architectures where
> alignment matters.
> So I don't think there's an issue in the code.
> 
But the code doesn't use the structure to access the data.
It use by an extra pointer "data", and I believe gcc loose the packed 
info (use byte accesses) when we do the "u32 *data = &plcp->data".


Matthieu
