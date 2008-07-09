Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:30429 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752115AbYGISJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:09:17 -0400
Message-ID: <4874FC95.3050904@sbcglobal.net> (sfid-20080709_200919_370806_D81153E7)
Date: Wed, 09 Jul 2008 10:59:49 -0700
From: Bryan Batten <BryanBatten@sbcglobal.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in adhoc/master
 mode
References: <200807051511.57995.IvDoorn@gmail.com> <486FBE75.5040100@sbcglobal.net> <200807052042.47008.IvDoorn@gmail.com>
In-Reply-To: <200807052042.47008.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Saturday 05 July 2008, Bryan Batten wrote:
>> Ivo van Doorn wrote:
...
>>> Note that the "raise beacondone interrupts without a beacon" is
>>>  also a bug, and will be addressed later.
...
>> FWIW, I've never been able to figure out a way to shut it off in 
>> the legacy drivers. Unless there's some mechanism I've missed, I 
>> would consider this a bug, but its a hardware bug because - in 
>> the rt2500 driver at least - even disabling it in the interrupt 
>> mask register has no effect.

Looking thru the RT2400 and RT2500 datasheets, I notice that on pp. 12
of the 2400 datasheet, CSR8 bits 0 and 1 are described. On the same
page of the RT2500 datasheet, CSR8 bits 0 and 1 are not described. If
that is not a typo, that means to me that on the RT2400 you can
mask off beacon timer and wakeup timer interrupts with CSR8, but on
the RT2500 you cannot.

Would it be possible to verify with Ralink that this is not a typo in
the RT2500 datasheet?

Thanks,
-- 
Bryan
-
"Beyond the point of no return, there's no going back."

Narration to "Mars Rising" on the Science Channel
