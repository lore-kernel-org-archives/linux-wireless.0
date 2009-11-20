Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:2689 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbZKTQDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 11:03:11 -0500
Received: from [10.1.1.4] ([204.17.38.236]) by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id <01NGB3N1U9NO9BA4IM@Opus1.COM> for linux-wireless@vger.kernel.org; Fri, 20 Nov 2009 07:50:54 -0700 (MST)
Date: Fri, 20 Nov 2009 07:50:54 -0700
From: Ehud Gavron <gavron@wetwork.net>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
In-reply-to: <4B06A233.2070708@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Message-id: <4B06ACCE.5040503@wetwork.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <200911201212.19588.mb@bu3sch.de> <4B06A233.2070708@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> On 11/20/2009 05:12 AM, Michael Buesch wrote:
>   
>> This patch adds a generic mechanism for overriding the SPROM mechanism
>> on devices without SPROM hardware.
>>
>> There currently is a major problem with this:
>> It tries to deduce a MAC address from various hardware parameters. But
>> currently it will result in the same MAC address for machines of the same
>> type. Does somebody have an idea of some device-instance specific serial
>> number or something similar that could be hashed into the MAC?
>>     
>
> You might look at the "root=" part of /proc/cmdline. Mine says
> "root=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part1". That disk serial
> number would certainly be unique. Even if it just said "root=/dev/sda1", it
> would be repeatable.
>
> Larry
>
>   
How does WL do it?  Broadcom *has* to generate a MAC address that is 
both unique and in its assigned range.  If we can do the same thing in 
B43 that would be ideal.

E
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>   
