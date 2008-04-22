Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:59472 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760946AbYDVSk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 14:40:57 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1312961ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 11:40:55 -0700 (PDT)
Message-ID: <9f33c5230804221125s65c2b3d5md69c0a4ee054f573@mail.gmail.com> (sfid-20080422_204142_686135_A98D9869)
Date: Tue, 22 Apr 2008 14:25:11 -0400
From: "cao jing" <caojing.china@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Does anybody know how to send a beacon in ath5k driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I try to generate the beacons in ath5k with mac802.11. I have done
some work as follow. But it still doesn't work. Is there anybody know
something about that.

--MAC80211--

set the fallow flag in the driver initialization.

local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE

--Atheros Driver--

setting AP mode

AR5K_STA_ID1 |= AR5K_STA_ID1_AP

initialize beacon register

AR5K_TIMER0 AR5K_TIMER2 AR5K_TIMER3 AR5K_TIMER4

AR5K_BEACON |= AR5K_BEACON_ENABLE [ | AR5K_BEACON_RESET_TSF ]

enable SWBA

AR5K_PIMR |= AR5K_INT_SWBA

configure the Receive filter register

AR5K_RX_FILTER |= AR5K_RX_FILTER_BEACON


Jing
