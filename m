Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:21457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZDIOUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 10:20:37 -0400
Received: by fg-out-1718.google.com with SMTP id 16so701735fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 07:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239263762.32594.19.camel@johannes.local>
References: <87ljqamktq.fsf@litku.valot.fi>
	 <1239263762.32594.19.camel@johannes.local>
Date: Thu, 9 Apr 2009 17:20:34 +0300
Message-ID: <da94abde0904090720t3c9d5f88ta25b2b2bf71cba35@mail.gmail.com> (sfid-20090409_162041_373130_798E3D50)
Subject: Re: [PATCH] fix iwl3945 registration regression
From: Kalle Valo <kalle.valo@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 9, 2009 at 10:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I forgot that iwl3945 registration is separate from iwlagn.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks, this fixed the problem for me.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

Although I wasn't able to get iwl3945 working yet:

Apr  9 17:06:57 tikku kernel: [   16.586612] iwl3945: Intel(R)
PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kd
Apr  9 17:06:57 tikku kernel: [   16.591406] iwl3945: Copyright(c)
2003-2009 Intel Corporation
Apr  9 17:06:57 tikku kernel: [   16.596203] iwl3945 0000:03:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Apr  9 17:06:57 tikku kernel: [   16.600996] iwl3945 0000:03:00.0:
setting latency timer to 64
Apr  9 17:06:57 tikku kernel: [   16.660038] iwl3945 0000:03:00.0:
Tunable channels: 13 802.11bg, 23 802.11a channels
Apr  9 17:06:57 tikku kernel: [   16.664799] iwl3945 0000:03:00.0:
Detected Intel Wireless WiFi Link 3945ABG
Apr  9 17:06:57 tikku kernel: [   16.669786] iwl3945 0000:03:00.0: irq
29 for MSI/MSI-X
Apr  9 17:06:57 tikku kernel: [   16.675157] phy0: Selected rate
control algorithm 'iwl-3945-rs'
Apr  9 17:06:57 tikku kernel: [   16.681674] phy0: Failed to initialize wep: -2
Apr  9 17:06:57 tikku kernel: [   16.695543] iwl3945 0000:03:00.0:
Failed to register hw (error -2)
Apr  9 17:06:57 tikku kernel: [   16.700576] iwl3945 0000:03:00.0: PCI
INT A disabled
Apr  9 17:06:57 tikku kernel: [   16.705359] iwl3945: probe of
0000:03:00.0 failed with error -2

Maybe this is the infamous module loading bug I see people talking
about? I'll investigate it later.

> This looks like my mistake, sorry!

No problem! That's why we are here, testing latest and greatest wireless code :)

Kalle
