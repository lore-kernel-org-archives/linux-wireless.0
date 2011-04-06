Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56815 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1DFQKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 12:10:40 -0400
Received: by yia27 with SMTP id 27so632399yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 09:10:39 -0700 (PDT)
Message-ID: <4D9C907B.7000504@lwfinger.net>
Date: Wed, 06 Apr 2011 11:10:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gottfried Haider <gottfried.haider@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: odd ping behavior
References: <BANLkTimnXJGy07-8gt=O7ruH-Hyt=NqtuQ@mail.gmail.com> <4D9B5473.6040003@lwfinger.net> <BANLkTi=ueo0Vm5VPRh=LMCQ-huGzXMyvFQ@mail.gmail.com> <20110406145700.GC11941@tuxdriver.com> <BANLkTikpDaEpHaCBOT2vE9=j9Ukvmo0gpw@mail.gmail.com> <20110406153918.GF11941@tuxdriver.com>
In-Reply-To: <20110406153918.GF11941@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2011 10:39 AM, John W. Linville wrote:
> On Wed, Apr 06, 2011 at 05:05:19PM +0200, Gottfried Haider wrote:
>>>> Thanks for testing. I had hoped that the ping results could make a
>>>> light go on somewhere..
>>>
>>> FWIW, the behaviour you described sounds a lot like bufferbloat.
>>
>> Thanks John, I was looking forward to reading this soon.
>>
>> But (without knowing about bufferbloat): would this manifest itself
>> only on the single network adapter? I am having no issues at all with
>> a Broadcom card on the same network or on the same machine when using
>> a USB-tethered phone to access the WiFi..
>
> It depends on where the bottlenecks are in the network, and where the
> "dark" buffers are too.  I'm not sure how big the hardware tx ring
> is for the rtl8192ce for example, or if it has any problems with
> retries or whatever.  I was mostly just observing that what you were
> describing sounded like typical bufferbloat (i.e. high latency leading
> to full big slow buffers) behavior. :-)

I have no idea what the hardware does internally, but rtl8192ce allocates 2 TX 
software ring entries for the beacon queue, 256 for the best effort queue, and 
128 for all others. It is not much different than b43, which allocates 256 
entries for all queues.

Larry
