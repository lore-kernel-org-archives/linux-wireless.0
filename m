Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2HVS5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 14:57:05 -0400
Received: by pbbrr13 with SMTP id rr13so1896916pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2012 11:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
References: <20120813165340.GA10044@pandem0nium>
	<20120819220436.GA9899@pandem0nium>
	<CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
Date: Wed, 22 Aug 2012 11:57:04 -0700
Message-ID: <CAJ-VmokN_2PHZinfE8zfx6-8VZ+KenccymfSs+JFWtDtmjExVg@mail.gmail.com> (sfid-20120822_205712_567547_34913774)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Adrian Chadd <adrian.chadd@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah. The deadbeef means "something's turned off."

I'd start with the SoC reset register and see if the MAC/WMAC bits are
correctly set. Ie, that something hasn't gone and reset the wireless
bits behind your back.

You could try hacking up a work around that does a full MAC/WMAC reset
when you reset the driver.

Ie, when ath9k does a full reset, actually _do_ a full reset by
resetting the mac/wmac via the SoC lines.

It could also be the RTC state. Maybe it's found its way into network
sleep (ie, the force wake bits aren't set right.) Or something PLL
related isn't programmed correctly. Dumping the RTC registers would be
helpful.

Thanks,



Adrian
