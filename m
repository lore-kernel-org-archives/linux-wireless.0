Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51506 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbbBLWvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 17:51:14 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so13721939obc.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 14:51:14 -0800 (PST)
Received: from linux.site ([69.76.245.152])
        by mx.google.com with ESMTPSA id ve6sm2888509obb.2.2015.02.12.14.51.13
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2015 14:51:13 -0800 (PST)
Message-ID: <54DD2E60.50509@lwfinger.net> (sfid-20150212_235121_276360_3ECAA8FE)
Date: Thu, 12 Feb 2015 16:51:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce kernel panics since 3.17(?)
References: <20150212121057.GA1804@leeloo.kyriasis.com> <54DCD708.3070402@lwfinger.net> <20150212172753.GA17043@leeloo.kyriasis.com> <54DCF71A.8030207@lwfinger.net> <20150212215457.GA23894@leeloo.kyriasis.com>
In-Reply-To: <20150212215457.GA23894@leeloo.kyriasis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2015 03:54 PM, Johannes Löthberg wrote:
> On 12/02, Larry Finger wrote:
>> OK, that makes more sense than your original report of problems starting with
>> 3.16 or 3.17. That bug was fixed in 3.18.4.
>>
>
> Well, I'm rather sure that I had some panics in 3.17 due to it, but I have no
> photographic evidence anymore alas. And d'oh, should have tried a newer kernel
> before sending it in, was meaning to report it for a while but never ended up
> to, sorry.
>
> Any idea about the third kernel panic photo?

Trying to trace it back on my kernel leads to a nonsense location. If it happens 
again, capture the trace as you did, then find the location in one of the rtl* 
routines that crashed. In the picture you sent, that is 
"_rtl_pci_interrupt+0x3d0" and that is in rtl_pci. To find the code section that 
crashed, start in the kernel source directory and do the following:

gdb drivers/net/wireless/rtlwifi/rtl_pci.ko
l *_rtl_pci_interrupt+0x3d0
quit

Adjust the driver and location to match the new crash. Send me the output of the 
"l" command.

Larry


