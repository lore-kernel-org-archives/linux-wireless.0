Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45586 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZLSXbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 18:31:24 -0500
Received: by fxm21 with SMTP id 21so3801483fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 15:31:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091219184401.GH2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	 <4B2BC7E3.2050907@lwfinger.net>
	 <20091218185916.GE2512@florz.florz.dyndns.org>
	 <4B2C100A.9000507@lwfinger.net>
	 <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
	 <20091219011306.GG2512@florz.florz.dyndns.org>
	 <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
	 <20091219184401.GH2512@florz.florz.dyndns.org>
Date: Sat, 19 Dec 2009 23:31:22 +0000
Message-ID: <3ace41890912191531k8703ecfr19c33f30127b2ecb@mail.gmail.com>
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Florian Zumbiehl <florz@florz.de>
Cc: Andrea Merello <andreamrl@tiscali.it>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br, htl10@users.sourceforge.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 19, 2009 at 6:44 PM, Florian Zumbiehl <florz@florz.de> wrote:

> So, a base load of 3.8 W seems to be caused by any connected usb device
> preventing C3 and some 250 ms polling done by uhci_hcd, plus a bit for
> the device itself. According to
> http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19354.html
> (why aren't there any message IDs on any of those archive sites, BTW?)
> that's the expected behaviour.

Presumably power-management changes have a time granuarity i.e. if you
make the CPU busy for one moment, it would stay in the higher-power
state for a while before dropping down? That's the standard thing to
do for prevent the power state being changed too often (and have bad
effects of some sort)?
