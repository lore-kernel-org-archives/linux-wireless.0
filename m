Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:35902 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbYKVOT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 09:19:57 -0500
Received: by gxk4 with SMTP id 4so1215136gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 06:19:56 -0800 (PST)
Message-ID: <40f31dec0811220619x1c46107vf22e5b6096f73f59@mail.gmail.com> (sfid-20081122_152026_637224_1F963ACB)
Date: Sat, 22 Nov 2008 16:19:56 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: linalex1965@neuf.fr
Subject: Re: Issues with AR5213A
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200811220849.01619.linalex1965@neuf.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200811220849.01619.linalex1965@neuf.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/22 Alexander <linalex1965@neuf.fr>:
> Dear Atheros Experts,
>
> I have an issue with an atheros card that was working fine under suse10.3 after
> installation of the madwifi drivers. When installing suse 11.0, a driver was
> automatically loaded, but it does not work.
>
> I have posted the details here: http://forums.opensuse.org/network-
> internet/wireless/400074-atheros-5005g-card-doesnt-find-signal.html#post1898247
>
> Larry proposed me to mail the output of dmesg to you. I would appreciate if
> you could help me solving this issue.
>
> Thanks in advance
>
> Alexander
>
> ----------------------------------------------------
>
> The critical section is as follows:
>
> ath5k_pci 0000:02:00.0: registered as 'phy0'
> phy0: Selected rate control algorithm 'pid'
> ath5k phy0: Atheros AR5213A chip found (MAC: 0x78, PHY: 0x45)
> ath5k phy0: RF2112A 2GHz radio found (0x56)
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: can't reset hardware (-5)
> pccard: card ejected from slot 0
>
> It appears that the ath5k driver does not support the AR5213A.
>
> Please post these lines to linux-wireless@vger.kernel.org. The Atheros experts
> hang out there.
>
> Larry

Your card is based on 2413 chip (0x78) (it seems that ath5k doesn't
report your chip name correctly which shouldn't happen).

Can you please check out the latest code from compat-wireless and see
what happens ? Current code supports both 5213 and 2413 chips.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
