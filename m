Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:5846 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbZHEFsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:48:45 -0400
Received: by fg-out-1718.google.com with SMTP id e12so809538fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 22:48:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A78F0DC.4070104@lwfinger.net>
References: <4A78C336.9000503@gmail.com> <4A78F0DC.4070104@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 5 Aug 2009 07:48:25 +0200
Message-ID: <69e28c910908042248m5419a39fl5f370e73e01e8b64@mail.gmail.com>
Subject: Re: [PATCH V3] b43: implement baseband init for LP-PHY <= rev1
To: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/5 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> Implement baseband init for rev.0 and rev.1 LP PHYs. Convert
>> boardflags_hi values to defines.
>> Implement b43_phy_copy for easier copying between registers, as needed
>> by LP-PHY init.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> Cc: Michael Buesch <mb@bu3sch.de>
>> Cc: Larry Finger <larry.finger@lwfinger.net>
>> ---
>> V3:
>> -Added FIXME to the b43_hf_write call.
>> -The b43_hf_write call now uses a #defined value, rather than a magic
>> number.
>
> It looks to me that V2 was put into wireless-testing. You will need to
> prepare a separate patch to make the V2 => V3 changes.
>
> Larry

OK, I will be sending one today.

Note to John: Please apply the "Fix fallout" patch, but not the
"Cleanups" one. The second part of "Cleanups" will be resubmitted,
combined with other V2->V3 changes.

Larry, my next target is
http://bcm-v4.sipsolutions.net/802.11/PHY/LP/SYNCHSTX - however, what
is the definition of struct lpphy_extstxdata_t? Where does the stx
array get its values (or what are its initial values, if it needs to
be initialized here)?
Also, with Sync-STX, >=rev2 radio init is essentially complete, except
for "with interrupts disabled, do something with backplane (TODO)" -
when can we expect documentation on this step?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
