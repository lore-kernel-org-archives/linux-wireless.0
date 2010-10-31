Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40461 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab0JaDnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 23:43:55 -0400
Received: by gxk23 with SMTP id 23so2651440gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 20:43:54 -0700 (PDT)
Message-ID: <4CCCE60F.6090105@lwfinger.net>
Date: Sat, 30 Oct 2010 22:44:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Walter Goldens <goldenstranger@yahoo.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <201010292202.25486.s.L-H@gmx.de> <694082.86488.qm@web56803.mail.re3.yahoo.com> <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com> <4CCB99CB.9000400@lwfinger.net> <20101030144947.GA2058@tuxdriver.com> <AANLkTi=WTFY07fqV5QsDcmzdL+0=4TQe7xv0ui90J=Jd@mail.gmail.com>
In-Reply-To: <AANLkTi=WTFY07fqV5QsDcmzdL+0=4TQe7xv0ui90J=Jd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2010 01:11 PM, Gábor Stefanik wrote:
> On Sat, Oct 30, 2010 at 4:49 PM, John W. Linville
>>
>> More good news!  Even if that device is aging, this indicates that
>> Realtek is getting serious about working with the community, even on
>> older devices.
> 
> However, it may be a good idea to indicate that "it is not yet stable"
> AFAIK doesn't preclude inclusion...

Perhaps not, but I want to have one that works before removing the staging driver.

I think Realtek is serious. After the r8712u driver was ready for inclusion in
staging, I sent them a copy of my revisions to their code. Obviously, they
studied it. When I received the new code for a mac80211-based driver for the
RTL8192CE driver, it was pretty clean and the sort of changes that were needed
for the 8712 had already been done. After only a few hours work, the sparse and
checkpatch warnings and errors were fixed. As far as I can tell, this code is
essentially ready for submission; however, I will wait until the sample cards
arrive from Realtek so that I can test those devices. In the very near future,
Not only will there be a driver for the RTL8188CE/RTL8192CE (PCIe), and for the
RTL8188CU/RTL8192CU (USB) devices. These two families use the same chip but
different interfaces. The new drivers will include a common core driver
(rtlwifi.ko) and an interface driver for each interface architecture (rtl8192se
for PCIe).

I also sent them the code I had for a mac80211-based driver for the RTL8187SE.
It was "almost" working, and they seem to have found the part I missed. In
addition, they used that code to learn how to use mac80211. I have not yet seen
their changes, but they said to expect it soon.

It certainly appears that Realtek plans to develop mainline drivers for all
their devices. As only they have the detailed knowledge of the chips, the news
is certainly good. With this help, we should be able to remove the staging
drivers for the Realtek cards.

For the record, I will not receive any compensation from Realtek, other than
their sending me complementary sample devices for testing.

Larry
