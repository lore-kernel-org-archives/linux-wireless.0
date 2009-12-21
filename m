Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:52101 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834AbZLUV2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 16:28:12 -0500
Date: Mon, 21 Dec 2009 22:27:43 +0100
From: Florian Zumbiehl <florz@florz.de>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Andrea Merello <andreamrl@tiscali.it>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br, htl10@users.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091221212743.GB22914@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org> <4B2C100A.9000507@lwfinger.net> <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com> <20091219011306.GG2512@florz.florz.dyndns.org> <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com> <20091219184401.GH2512@florz.florz.dyndns.org> <3ace41890912191531k8703ecfr19c33f30127b2ecb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <3ace41890912191531k8703ecfr19c33f30127b2ecb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > So, a base load of 3.8 W seems to be caused by any connected usb device
> > preventing C3 and some 250 ms polling done by uhci_hcd, plus a bit for
> > the device itself. According to
> > http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19354.html
> > (why aren't there any message IDs on any of those archive sites, BTW?)
> > that's the expected behaviour.
> 
> Presumably power-management changes have a time granuarity i.e. if you
> make the CPU busy for one moment, it would stay in the higher-power
> state for a while before dropping down? That's the standard thing to
> do for prevent the power state being changed too often (and have bad
> effects of some sort)?

Well, yeah, but: There are "only" some 1050 wakeups per second going on,
1000 of which are the timer tick, despite NO_HZ. And all of them in total
seem to be using < 1 % of the CPU. Given that
/proc/acpi/processor/CPU0/power lists a latency of 65 µs for C3, I don't
quite see how that fits together.

Florian
