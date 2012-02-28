Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:55267 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2B1Pfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:35:50 -0500
Message-ID: <4F4CF454.8050207@raritan.com> (sfid-20120228_163553_655385_5097D2D6)
Date: Tue, 28 Feb 2012 16:35:48 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Occasional truncated scan results
References: <4F4CE4D6.6020108@raritan.com>  (sfid-20120228_152950_864254_C21F9143) <1330440166.3368.7.camel@jlt3.sipsolutions.net>  <4F4CEFA6.2090005@raritan.com> <1330442659.3368.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330442659.3368.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.02.2012 16:24, Johannes Berg wrote:
> On Tue, 2012-02-28 at 16:15 +0100, Ronald Wahl wrote:
>> My problem is not that the scan results are larger than 64k. The user
>> space is coded so that it provides a small buffer that is doubled in
>> size until the data fits into the buffer. But the kernel code does not
>> always detect the case that the buffer is almost full and just starts
>> skipping some data without notifying user space with E2BIG.
>
> Ok. Yes, this could be fixed by making sure that a single BSS is
> atomically written or not written -- probably simply by rolling back at
> the end of the function if it didn't fit and returning an error etc. If
> you wanted to work on this, I'd review&  accept the patch, but I have no
> intention whatsoever to do this myself :-)

I'll first check if I can use the nl80211 interface in all cases. If not 
I'll probably come up with a patch. Thanks!

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler
