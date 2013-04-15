Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56905 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab3DORIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 13:08:43 -0400
From: Kalle Valo <kvalo@adurom.com>
To: minimumlaw@rambler.ru
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Fix transmit power troubles on some Ralink RT30xx cards
References: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
Date: Mon, 15 Apr 2013 20:08:42 +0300
In-Reply-To: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
	(minimumlaw@rambler.ru's message of "Sun, 14 Apr 2013 14:54:43 +0400")
Message-ID: <87a9oz7mcl.fsf@purkki.adurom.net> (sfid-20130415_190847_626686_EF76D9E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

minimumlaw@rambler.ru writes:

> From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
>
> Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> value in them EEPROM/EFUSE. In this case, we must use default value,
> but always used EEPROM/EFUSE value. As result we have tranmitt power
> range from -10dBm to +6dBm instead 0dBm to +16dBm.
>
> Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> more for other RT30xx chips.
>
> Testen on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> embedded Wi-Fi module.
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

The subject should have "rt2x00: " prefix.

-- 
Kalle Valo
