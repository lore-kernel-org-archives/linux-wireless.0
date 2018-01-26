Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbeAZRBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 12:01:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: James Hogan <jhogan@kernel.org>
Cc: Sven Joachim <svenjoac@gmx.de>, Michael Buesch <m@bues.ch>,
        linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ssb: Do not disable PCI host on non-Mips
References: <87vafpq7t2.fsf@turtle.gmx.de> <20180126100902.GN5446@saruman>
        <87fu6su1mv.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 26 Jan 2018 19:01:49 +0200
In-Reply-To: <87fu6su1mv.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 26 Jan 2018 16:37:44 +0200")
Message-ID: <87tvv8r1tu.fsf@purkki.adurom.net> (sfid-20180126_180201_475555_2BD2EA8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> James Hogan <jhogan@kernel.org> writes:
>
>> On Fri, Jan 26, 2018 at 10:38:01AM +0100, Sven Joachim wrote:
>>> After upgrading an old laptop to 4.15-rc9, I found that the eth0 and
>>> wlan0 interfaces had disappeared.  It turns out that the b43 and b44
>>> drivers require SSB_PCIHOST_POSSIBLE which depends on
>>> PCI_DRIVERS_LEGACY, a config option that only exists on Mips.
>>> 
>>> Fixes: 58eae1416b80 ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC")
>>> Cc: stable@vger.org
>>> Signed-off-by: Sven Joachim <svenjoac@gmx.de>
>>
>> Whoops, thats a very good point. I hadn't twigged that
>> PCI_DRIVERS_LEGACY was MIPS specific (one of the disadvantages of using
>> "tig grep" I suppose!).
>>
>> Reviewed-by: James Hogan <jhogan@kernel.org>
>>
>> I think this is obviously correct, so it'd be great to squeeze it into
>> 4.15 final.
>
> I'm not sure if I'm able to get it to 4.15 as it has go via the net
> tree, and we have only two days before the (likely) final release, but
> I'll try.

Too late, Dave already sent his last pull request for 4.15. This will be
in 4.16.

-- 
Kalle Valo
