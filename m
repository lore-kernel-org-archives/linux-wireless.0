Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57943 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab1EaRdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 13:33:03 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QRSoO-0004eQ-Iv
	for linux-wireless@vger.kernel.org; Tue, 31 May 2011 19:33:00 +0200
From: Andreas Schwab <schwab@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?=
	<public-zajec5-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	Michael =?utf-8?Q?B=C3=BCsch?=
	<public-mb-fseUSCV1ubazQB+pC5nmwQ@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org>,
	public-b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
	linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ssb: pci: implement serdes workaround
References: <1301657212-12126-1-git-send-email-zajec5@gmail.com>
	<m2vcwr9pn8.fsf@linux-m68k.org> <4DE505C6.8020601@lwfinger.net>
	<m3wrh6hnmn.fsf@linux-m68k.org> <4DE51487.1000808@lwfinger.net>
	<m239jukddk.fsf@igel.home>
Date: Tue, 31 May 2011 19:32:50 +0200
In-Reply-To: <m239jukddk.fsf@igel.home> (Andreas Schwab's message of "Tue, 31
	May 2011 19:07:19 +0200")
Message-ID: <m2vcwqixml.fsf@igel.home> (sfid-20110531_193307_254578_8EE499D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Andreas Schwab <schwab@linux-m68k.org> writes:

> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> On 05/31/2011 10:54 AM, Andreas Schwab wrote:
>>> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>>>
>>>>  From the traceback, it must be the serdes_pll_device read that failed.
>>>
>>> Why not ssb_pcicore_polarity_workaround (note r4 == 0x134)?
>>
>> Mainly because the last two steps in the traceback are
>>
>> [c2ca5c40] [f2146244] ssb_pcie_read+0x4c/0x54 [ssb]
>> [c2ca5c50] [f2146440] ssb_pcicore_serdes_workaround+0x1c/0x170 [ssb]
>
> Which exactly is what ssb_pcicore_polarity_workaround is doing.

0000022c <ssb_pcicore_serdes_workaround>:
 22c:   94 21 ff e0     stwu    r1,-32(r1)
 230:   7c 08 02 a6     mflr    r0
 234:   38 80 02 04     li      r4,516
 238:   90 01 00 24     stw     r0,36(r1)
 23c:   bf a1 00 14     stmw    r29,20(r1)
 240:   7c 7f 1b 78     mr      r31,r3
 244:   4b ff fd bd     bl      0 <ssb_pcie_read>

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

