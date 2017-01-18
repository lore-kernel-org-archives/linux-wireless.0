Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754730AbdARLqp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 06:46:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] rsi: Device initialization sequence is changed
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477044656-10402-1-git-send-email-prameela.j04cs@gmail.com>
References: <1477044656-10402-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170118114644.B0BC860805@smtp.codeaurora.org> (sfid-20170118_124648_871081_E6CCF908)
Date: Wed, 18 Jan 2017 11:46:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> BT Co-ex support has been added in the firmware and hence BT, COEX queues are
> introducted. To support the latest firmware queues, packet processing,
> and initialization sequence is modified in the Host.
> 
> Common device configuration parameters (tx command frame) need to be send after
> common card ready indication from the firmware. This frame contains information
> about the driver mode, coex mode, protocols to support etc. Once it is sent,
> then second level card ready indication comes for each protocol (WLAN, BT etc).
> 
> Currently host supports only WLAN mode. New command frames are added as part
> of these changes.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Few review comments:

* no C++ '//' style comments

* avoid magic numbers

* use structs for new firmware commands instead of cmd[offset] style

* struct rsi_ulp_gpio_vals, struct rsi_soc_gpio_vals and struct rsi_config_vals
  don't look endian safe

-- 
https://patchwork.kernel.org/patch/9388627/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
