Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42538 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbeEPPn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 11:43:29 -0400
Date: Wed, 16 May 2018 08:43:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] wlcore: Make sure PM calls are paired
Message-ID: <20180516154326.GG98604@atomide.com> (sfid-20180516_174334_008505_146ECA14)
References: <20180515161315.1997-1-tony@atomide.com>
 <20180515161315.1997-2-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180515161315.1997-2-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180515 16:15]:
> The call to wl1271_ps_elp_wakeup() in wl12xx_queue_recovery_work() is
> unpaired. Let's remove it and add paired calls to wl1271_recovery_work()
> instead in preparation for changing things to use runtime PM.

Looks like this causes at least a warning at
drivers/net/wireless/ti/wlcore/io.h:66 if recovery triggers.

Regards,

Tony
