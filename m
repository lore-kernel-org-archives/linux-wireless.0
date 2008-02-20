Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:54583 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYBTN7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 08:59:50 -0500
Message-ID: <47BC32D7.3040900@gentoo.org> (sfid-20080220_135953_075957_1DB8996E)
Date: Wed, 20 Feb 2008 14:01:59 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Patch for compat-wireless-2.6
References: <47B6FD58.5010004@hauke-m.de> <43e72e890802191535i5bd89432rfed0f4cf3e375c29@mail.gmail.com>
In-Reply-To: <43e72e890802191535i5bd89432rfed0f4cf3e375c29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
>> +--- a/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000000 -0500
>> ++++ b/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000000 -0500
>> +@@ -890,7 +890,7 @@ int zd_chip_lock_phy_regs(struct zd_chip *chip);
>> + int zd_chip_unlock_phy_regs(struct zd_chip *chip);
>> +
>> + enum led_status {
>> +-	LED_OFF = 0,
>> ++	LED_OFF_ZD = 0,
>> + 	LED_SCANNING = 1,
>> + 	LED_ASSOCIATED = 2,
>> + };
> 
> This could possibly go upstream so we don't have to keep an extra
> patch around. Up to zd guys though. If not we'll have to keep updating
> this hunk as the driver changes. Not a big issue. This is just so we
> can keep including from compat.h leds.h which has its own definition
> of LEDS_OFF.

Feel free to submit a patch adding a ZD_ prefix to all the enum members.

Daniel
