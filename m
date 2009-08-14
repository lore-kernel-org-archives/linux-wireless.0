Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:46317 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZHNLnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 07:43:45 -0400
Received: from [76.91.220.157] (helo=[192.168.1.20])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1MbvCE-00062u-BG
	for linux-wireless@vger.kernel.org; Fri, 14 Aug 2009 04:43:46 -0700
Message-ID: <4A854DEB.1080100@symas.com>
Date: Fri, 14 Aug 2009 04:43:39 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless-2009-08-13 ath9k timeouts
References: <4A84D3E4.5050406@symas.com>
In-Reply-To: <4A84D3E4.5050406@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After reading this hint

> From: Sujith <Sujith.Manoharan@...>
> Subject: Re: Revert commit in ath9k
> Date: 2009-08-14 06:17:42 GMT (5 hours and 20 minutes ago)
>
> Pavel Roskin wrote:
>> Quoting Sujith <Sujith.Manoharan@...>:
>>
>> > John,
>> >
>> > Can you revert the commit - "ath9k: Change DEBUG level for certain
>> > interrupts" ?
>> > This interrupt seems to trigger fairly often and floods the log.

I reverted that commit in my build, and things were a bit more usable. But now 
I'm seeing this momentary pauses, and this in dmesg:

[22479.126146] wlan0: associated
[22734.695276] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x40000020
[22978.405252] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x42000020

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
