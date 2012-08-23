Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59407 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2HWRKv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 13:10:51 -0400
Message-ID: <50366411.6000408@openwrt.org> (sfid-20120823_191058_620376_8EBAA878)
Date: Thu, 23 Aug 2012 19:10:41 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Adrian Chadd <adrian.chadd@gmail.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
References: <20120813165340.GA10044@pandem0nium> <20120819220436.GA9899@pandem0nium> <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com> <CAJ-VmokN_2PHZinfE8zfx6-8VZ+KenccymfSs+JFWtDtmjExVg@mail.gmail.com> <20120823092831.GA25818@pandem0nium>
In-Reply-To: <20120823092831.GA25818@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.08.23. 11:28 keltezéssel, Simon Wunderlich írta:
> Hello Adrian,
> 
> thanks for your comments!
> 
> On Wed, Aug 22, 2012 at 11:57:04AM -0700, Adrian Chadd wrote:
>> Yeah. The deadbeef means "something's turned off."
>>
>> I'd start with the SoC reset register and see if the MAC/WMAC bits are
>> correctly set. Ie, that something hasn't gone and reset the wireless
>> bits behind your back.
> 
> Sure, but which register would that be? How can I find out? Is it included
> in regdump of ath9k debugfs?

It is the AR933X_RESET_REG_RESET_MODULE register (0x1806001c), and the reset of
the WMAC chip is controlled by the AR933X_RESET_WMAC bit. You can find the
definitions in arch/mips/include/asm/mach-ath79/ar71xx_regs.h.

The platform device registration code pulls the WMAC chip out of reset before
registering the device. See the 'ar933x_wmac_setup' function in
'arch/mips/ath79/dev-wmac.c'. Then only the ath9k driver controls the hardware
reset line indirectly via ah->external_reset.

However, I doubt that the 0xdeadbeef values are caused by this. If the
AR933X_RESET_WMAC bit is set in the reset register, the WMAC chip is not
accessible at all. If the AR933X_RESET_WMAC bit is set and the driver tries to
access the WMAC registers, the board locks up completely, or reboots itself. At
least I have experienced this earlier.

-Gabor
