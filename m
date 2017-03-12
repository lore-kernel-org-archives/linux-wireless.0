Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36185 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755391AbdCLQ7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Mar 2017 12:59:41 -0400
Received: by mail-wr0-f193.google.com with SMTP id l37so17326945wrc.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Mar 2017 09:59:40 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v5] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
Date: Sun, 12 Mar 2017 17:59:37 +0100
Message-ID: <2641812.B5DpPPlh2Q@debian64> (sfid-20170312_175945_348216_471B5CE8)
In-Reply-To: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, March 11, 2017 11:04:17 PM CET Igor Mitsyanko wrote:
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
> 
> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
> 5G WMAC supports 160M, 8x8 configuration. FW supports
> up to 8 concurrent virtual interfaces on each WMAC.
> [...]
---

I see a lot of error/warning/info messages the likes of:
 
pr_err("failed to change interface type\n");
pr_err("bss not started\n");
pr_err("failed to configure phy thresholds\n");
pr_err("failed to add key\n");
pr_err("failed to delete key\n");
pr_err("failed to change STA\n");
...

I'm wondering what this will look like if there are multiple VIFs,
multiple PHYs or more than one QSR10G in a System. How - for example -
can you map a error/warning/info message to the individual Client, VIF,
PHY instance or device? From what I can tell, this is bound to get very
confusing very fast.

the kernel and cfg80211 has a ton of predefined logging and debug
functions: dev_[info|warn|err|...], wiphy_[WARN|emerg|alert|crit|err|warn|...]
I think using those functions (and adding information about the client/vif)
would tremendously help with that?

Thanks,
Christian
