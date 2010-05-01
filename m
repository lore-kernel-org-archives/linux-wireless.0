Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59133 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0EAS1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 14:27:46 -0400
Received: by pvg7 with SMTP id 7so673157pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 11:27:45 -0700 (PDT)
Message-ID: <4BDC729E.5060202@lwfinger.net>
Date: Sat, 01 May 2010 13:27:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
References: <4BDC56D2.5060605@gmail.com> <201005011919.42294.mb@bu3sch.de> <4BDC6803.9030805@lwfinger.net> (sfid-20100501_174238_035394_CCE48505) <201005012015.50601.mb@bu3sch.de>
In-Reply-To: <201005012015.50601.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2010 01:15 PM, Michael Buesch wrote:
> On Saturday 01 May 2010 19:42:27 Larry Finger wrote:
>> I may have gotten the MMIO offset part wrong in the specs, but the
>> Broadcom driver definitely writes to offset 0x648 at that point.
> 
> I do not think you are right.
> 
> First: The write has to happen to the 802.11 core and not to the chipcommon core.
> 
> Second: The code that was touched by Gábor is _very_ early in the SSB init.
> Way ahead of the wireless core init. The specs state that the delay value has to be written
> after the wireless core init is nearly done.
> We do _exactly_ that in b43.
> 
> The only thing that needs to be done is to add the additional switch statement.
> No MMIO writes have to be touched.

OK, I changed the spec to remove the write.

Larry
