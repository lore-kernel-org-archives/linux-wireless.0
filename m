Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46665 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab0J1XV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 19:21:59 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PBbnB-0004J3-98
	for linux-wireless@vger.kernel.org; Fri, 29 Oct 2010 01:21:57 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([173.34.126.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 01:21:57 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 01:21:57 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Date: Thu, 28 Oct 2010 23:21:47 +0000 (UTC)
Message-ID: <loom.20101029T010426-834@post.gmane.org>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org> <4CC71CFF.8050004@lwfinger.net> <20101026185341.GA4608@barata.holoscopio.com> <20101028191305.2960c83b@gotham.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski <herton@...> writes:

> The excessive retries etc. should be another issue. The patch from Thadeu
> really improves the driver.

Well, I tried once more today, maybe I'm doing something wrong?

- I run "./scripts/driver-select rtl818x" in compat-wireless-2010-10-28
- then "patch -p1 rtl8187_dev.c rtl8187b-do-not-do-per-packet-TX-AGC.patch"
- then "make"
- then "sudo make install"
- then reboot

"dmesg |grep compat" gives "Compat-wireless backport release: compat-
wireless-2010-10-22-5-g69fdc09" so the new module is used.

On speedtest.net, max speed is ~ 1mbit (on 10 mbit cable internet @10 meters 
distance)
The router reports an improved "Signal Quality", but iwconfig now shows:

"Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0"
"Tx excessive retries:2589  Invalid misc:17686   Missed beacon:0"

Herton: If I make something wrong, can you please post your rtl8187.ko.gz 
(Mandriva 2010.1 / 2.6.33.7-desktop-2mnb x86_64)?

Thank you.

