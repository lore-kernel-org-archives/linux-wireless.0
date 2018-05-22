Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44020 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeEVNzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:55:15 -0400
Date: Tue, 22 May 2018 06:55:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180522135511.GI98604@atomide.com> (sfid-20180522_155519_149897_ACC83E57)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com>
 <20180521224339.GD98604@atomide.com>
 <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
 <20180522133158.GE98604@atomide.com>
 <eae7c720c09549f0b4ff83f88ad6959b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eae7c720c09549f0b4ff83f88ad6959b@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180522 13:50]:
> > 
> > OK try replacing the pm_runtime_put_noidle() above with just
> > pm_runtime_put_sync(). The reason why I put noidle there was the
> > wlcore_fw_sleep() call, with that gone put_sync should do the trick.
> > 
> 
> I have tried that already. Same problem. The last call to:
> ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP)
> 
> which allows the firmware to get into ELP state during wowlan suspend is 
> only completing after system resume for some unknown reason...

Hmm maybe try also adding wl1271_power_off(wl) after put_sync()?

Regards,

Tony
