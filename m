Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:39340 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZEPAOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 20:14:49 -0400
Message-ID: <4A0E0579.70507@highlandsun.com>
Date: Fri, 15 May 2009 17:14:49 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com>	 <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com>	 <4A0DC4A9.8050505@highlandsun.com>  <4A0DD39D.6070001@gmail.com> <1242429170.10933.30.camel@localhost.localdomain>
In-Reply-To: <1242429170.10933.30.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Fri, 2009-05-15 at 21:42 +0100, Dave wrote:
>> That message is printed in response to a firmware interrupt. It
>> indicates "an unsolicited Frame Structure cannot be generated... because
>> there is not enough Frame Structure buffer space available".
>>
>> I suspect that the beacons/probe responses/scan results are either too
>> large/too frequent for the card to handle, or the firmware can't
>> decipher them.
>>
>> Before enabling wpa_supplicant, can you try scan for your AP (as root):
>>
>> iwlist ethX scan essid YYYYY

That works fine. In fact, just "iwlist scan" returns the same result - only 
the info for my AP is returned. (There are at least 6 APs visible from an 
another laptop sitting nearby.)

>> I'm interested in what it returns, and whether dmesg reports 'Ext scan
>> results too large' or something similar.

No, it just continues with the stream of "frame lost" messages:

eth2: Information frame lost. (10 times, followed by 1
__ratelimit: 2 callbacks suppressed  (then 10 more frame lost messages, and so on)

The number in "callbacks suppressed" varies pretty widely, from 2 to 32.

> Yeah a lot of APs will stuff a ton of info into the IEs these days,
> including WPS, WPA, 11d, blah blah.  It's not out of the question that
> the firmware writers didn't anticipate or handle large numbers of IEs in
> the beacons.  That said, what firmware version is he using?  Maybe

Using 9.48, I so far haven't found 9.52 for download anywhere.

> Apple's firmware fixes that or something?  Would be interesting if the
> reporter could boot up an old iBook with an Airport card and see if that
> works.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
