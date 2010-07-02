Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59193 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab0GBQnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 12:43:12 -0400
Message-ID: <4C2E170E.6040207@candelatech.com>
Date: Fri, 02 Jul 2010 09:42:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question on 'iw reg get/set'
References: <4C2CFAEB.9070302@candelatech.com> <20100702141216.GB2381@tuxdriver.com>
In-Reply-To: <20100702141216.GB2381@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2010 07:12 AM, John W. Linville wrote:
> On Thu, Jul 01, 2010 at 01:30:35PM -0700, Ben Greear wrote:
>> I'm using an ath9k NIC on a slightly hacked 2.6.34 kernel, Fedora 13 32-bit.
>> I'm using the stock 'iw' command that comes with Fedora 13.
>>
>> As far as I can tell, the results of 'iw reg get'
>> are funky:
>>
>> [root@atom lanforge]# iw reg get
>> country 98:
>> 	(2402 - 2472 @ 40), (N/A, 20)
>> 	(5170 - 5250 @ 20), (N/A, 17)
>> 	(5250 - 5330 @ 20), (N/A, 18), DFS
>>
>> What is '98'?  It doesn't correspond to anything I can find
>> in the numeric or ascii lists of country codes.
>>
>> Also, setting the domain doesn't seem to do anything, although
>> there are no errors:
>>
>> [root@atom lanforge]# iw reg get
>> country 98:
>> 	(2402 - 2472 @ 40), (N/A, 20)
>> 	(5170 - 5250 @ 20), (N/A, 17)
>> 	(5250 - 5330 @ 20), (N/A, 18), DFS
>> [root@atom lanforge]# iw reg set US
>> [root@atom lanforge]# iw reg get
>> country 98:
>> 	(2402 - 2472 @ 40), (N/A, 20)
>> 	(5170 - 5250 @ 20), (N/A, 17)
>> 	(5250 - 5330 @ 20), (N/A, 18), DFS
>>
>> Anyone know if this is *supposed* to work?
>
> The ath9k driver is setting its own regulatory restrictions based on
> its EEPROM.  Setting the domain from userland can only further restrict
> the regulatory settings.  The '98' value represents a synthesized
> regulatory domain, based on the intersection of the available source
> of regulatory information (which can include the EEPROM, the userland
> setting, and a country IE from your AP).

Is there any way to get/set these raw settings (like, whatever it has in EEPROM)?

I expect we may ship some of these systems overseas, and would like the flexibility
to set the country-code for testing purposes, if nothing else.

Is there any documentation as to what '98' really means, or do we just ignore that
value and look at the info printed out after that?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
