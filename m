Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56754 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0C2V2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 17:28:50 -0400
Received: by pwi5 with SMTP id 5so7055503pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 14:28:50 -0700 (PDT)
Message-ID: <4BB11B8E.1020506@lwfinger.net>
Date: Mon, 29 Mar 2010 16:28:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com> <4BB10A0F.1030608@lwfinger.net> <20100329204822.GL4984@tuxdriver.com> <20100329205558.GM4984@tuxdriver.com>
In-Reply-To: <20100329205558.GM4984@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2010 03:55 PM, John W. Linville wrote:
> On Mon, Mar 29, 2010 at 04:48:22PM -0400, John W. Linville wrote:
>> On Mon, Mar 29, 2010 at 03:14:07PM -0500, Larry Finger wrote:
>>
>>> Could you please apply my little test patch and send me the contents of the
>>> chipcommon status register in your netbook?
>>
>> Mine looks like yours, "chip_id 0x4312, status 0x12"...
> 
> I guess I misread the earlier messages -- mine looks like René's, not yours.

Bummer. To answer your previous message, the Broadcom driver is very clear that
0x2 set in the chipcommon status for a BCM4312 means no SPROM; however, René's
device contradicts that conclusion. There must be some other test that I have
missed.

René: For your information, this test was added because attempting to read the
SPROM in John's computer locks the processor - he has to power off. I did
reverse engineering on the Broadcom driver and found their workaround when no
SPROM is present. The patch in question matches their code, and allows John's
machine to continue. There is a second, pending patch that works with some udev
rules to create a virtual SPROM image and assign a unique MAC address. With this
patch applied, your machine would still work. The only change is that you would
be assigned a random MAC address.

I will likely need some additional test prints to see if I can find a test that
recognizes that René's machine has an SPROMs and that John's does not.

Larry
