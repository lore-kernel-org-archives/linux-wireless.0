Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53739 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0KKTPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:15:35 -0500
Received: by qwi4 with SMTP id 4so160252qwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:15:34 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 14:15:34 -0500
Message-ID: <AANLkTikjg+jY6XYhJjRPydwveW0xr+8tLv-Oypsks4ay@mail.gmail.com>
Subject: ath9k max_power question
From: Mark Mentovai <mark@moxienet.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In drivers/net/wireless/ath/ath9k/init.c, both CHAN2G and CHAN5G set
.max_power to 20, represented in dBm. I’m wondering how this number
was chosen. Is it simply a safe generic value? I’m dealing with a
device on which the vendor’s madwifi-based binary driver would show
23dBm for 2.4GHz and 18dBm for 5GHz (although only when I asked it for
26dBm and 24dBm respectively, so I’m not sure which set of numbers to
believe.)

I noticed that in ath9k, if these .max_power limits are raised, the
driver is happy to set a somewhat higher transmit power. In this case,
it will max out at 25dBm for 2.4GHz and 21dBm for 5GHz. These are
still below the relevant regulatory limits. These values seem to be
computed by routines in eeprom_*.c, so I’m wondering if they’re based
on the card’s own data and safe to use without fear of burning the
radios.
