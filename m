Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab0LGEXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 23:23:14 -0500
Received: by pwj3 with SMTP id 3so2046478pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 20:23:14 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19709.46740.86437.390791@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 09:52:44 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
	<19704.23185.565826.890275@gargle.gargle.HOWL>
	<AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
	<19709.45926.38551.25130@gargle.gargle.HOWL>
	<AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> That's the thing, the device was powered up, lifted from idle, but we
                    ^^^^^^^^^^^^^^^^^^^^^^^^^
Not according to mac80211 - start() wasn't issued, config() with ~CONF_IDLE
wasn't issued.

This is the issue in ath9k_htc:

* modprobe ath9k_htc
* pm-suspend
---
* resume

In this case, as I said above, neither start() nor CONF_IDLE have been notified
to the driver by mac80211, since the interface was never brought up.

But ath9k_htc powers up the device while initialization, immediately when the driver
is loaded, not waiting for start() or ~CONF_IDLE. And since the driver maintains
internal state with respect to the radio's power status, I think it is up to the
driver to clean it properly ...

Sujith
