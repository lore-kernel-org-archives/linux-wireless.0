Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdLEKdZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 05:33:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        johannes.berg@intel.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: Re: 4.15.0-rc1-next-20171201: WARNING: .... at net/mac80211/agg-tx.c:315
References: <20171205102434.GA12780@amd>
Date: Tue, 05 Dec 2017 12:33:21 +0200
In-Reply-To: <20171205102434.GA12780@amd> (Pavel Machek's message of "Tue, 5
        Dec 2017 11:24:34 +0100")
Message-ID: <874lp5jwge.fsf@purkki.adurom.net> (sfid-20171205_113330_144534_A76C75D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Machek <pavel@ucw.cz> writes:

> This is quite annoying: repeated
>
> [ 4169.591529] ---[ end trace e65d97cf1d20b84d ]---
> [ 4169.591565] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315
> ___ieee80211_stop_tx_\
> ba_session+0x158/0x1f0
>
> Hardware is thinkpad x60. Git blame says cfcdbde35 introduced the
> test.

To save time for others, the driver is iwl3945:

> [    0.970687] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
> [    0.970690] iwl3945: Copyright(c) 2003-2011 Intel Corporation
> [    0.970692] iwl3945: hw_scan is disabled
> [    0.971082] iwl3945 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
> [    1.026281] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> [    1.026287] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
> [    1.027866] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'

-- 
Kalle Valo
