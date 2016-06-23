Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcFWEr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 00:47:28 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: Re: WARNING: CPU: 1 PID: 103 at
 drivers/net/wireless/ath/ath9k/hw.c:2778
Date: Thu, 23 Jun 2016 04:47:12 +0000
Message-ID: <87eg7ofr5c.fsf@kamboji.qca.qualcomm.com> (sfid-20160623_064733_285634_548A6F28)
References: <20160622162151.GD1718@lahna.fi.intel.com>
In-Reply-To: <20160622162151.GD1718@lahna.fi.intel.com> (Mika Westerberg's
	message of "Wed, 22 Jun 2016 19:21:51 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> After upgrading from v4.6 to v4.7-rc3 I'm starting to see following
> warnings constantly being printed by ath driver:
>
> [    6.761789] ath: phy0: ASPM enabled: 0x43
> [    6.761794] ath: EEPROM regdomain: 0x6a
> [    6.761796] ath: EEPROM indicates we should expect a direct regpair map
> [    6.761799] ath: Country alpha2 being used: 00
> [    6.761800] ath: Regpair used: 0x6a
> [    6.773482] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    6.774048] ieee80211 phy0: Atheros AR9462 Rev:3 mem=0xffffc90000b00000, irq=19
> [    6.774054] ------------[ cut here ]------------
> [    6.774070] WARNING: CPU: 1 PID: 103 at drivers/net/wireless/ath/ath9k/hw.c:2778 ath9k_hw_gpio_get+0x161/0x1b0 [ath9k_hw]

Should be fixed by this:

ath9k: fix GPIO mask for AR9462 and AR9565

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=e024111f6946f45cf1559a8c6fd48d2d0f696d07

Please let me know if it doesn't.

-- 
Kalle Valo