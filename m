Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34787 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab3BSThV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 14:37:21 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so5298901wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 11:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
	<20771.50338.434076.484711@gargle.gargle.HOWL>
	<CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
	<20771.51233.248133.141840@gargle.gargle.HOWL>
	<alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
Date: Tue, 19 Feb 2013 11:37:14 -0800
Message-ID: <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com> (sfid-20130219_203725_906920_B176DCE2)
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
From: Adrian Chadd <adrian@freebsd.org>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2013 11:11, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:

>
> hm, i have signal jumps too on some cards, but it's may be a hardware problem,
> in one of my case this confirmed by manufacturer, then hi block 2.4 bands on it
> where problem occurses, and continue sell it as 5Ggz only card. and i have NF
> calibration jumps on this card too, it easy to se just enable calibration debug
> (echo 0x00000008 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug) and watch on
> log with tail -f, you sould se something like this, may be periodicaly:
>
> 6.505180] ath: phy0: NF calibrated [ctl] [chain 0] is -68
> 6.505185] ath: phy0: NF[0] (-68) > MAX (-97), correcting to MAX
> 6.505188] ath: phy0: NF calibrated [ctl] [chain 1] is -80
> 6.505191] ath: phy0: NF[1] (-80) > MAX (-97), correcting to MAX
> 6.505194] ath: phy0: NF calibrated [ext] [chain 0] is -70
> 6.505197] ath: phy0: NF[3] (-70) > MAX (-97), correcting to MAX
> 6.505200] ath: phy0: NF calibrated [ext] [chain 1] is -80
> 6.505204] ath: phy0: NF[4] (-80) > MAX (-97), correcting to MAX

Yes. I've seen cards that do this. It's almost always due to badly
placed components/tracks causing spurs / resonance to show up in the
2GHz bands.
It makes the NIC unusable in those modes.




Adrian
