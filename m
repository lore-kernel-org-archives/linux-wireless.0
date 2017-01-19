Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11286 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdASNTQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 08:19:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: prevent sta pointer rcu violation
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com>
References: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <greearb@candelatech.com>, <linux-wireless@vger.kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        <ath10k@lists.infradead.org>, <mohammed@qti.qualcomm.com>
Message-ID: <09e8655e878946659bc62c52e59abd76@euamsexm01a.eu.qualcomm.com> (sfid-20170119_141922_332902_72BAC13E)
Date: Thu, 19 Jan 2017 14:18:20 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Station pointers are RCU protected so driver must
> be extra careful if it tries to store them
> internally for later use outside of the RCU
> section it obtained it in.
> 
> It was possible for station teardown to race with
> some htt events. The possible outcome could be a
> use-after-free and a crash.
> 
> Only peer-flow-control capable firmware was
> affected (so hardware-wise qca99x0 and qca4019).
> 
> This could be done in sta_state() itself via
> explicit synchronize_net() call but there's
> already a convenient sta_pre_rcu_remove() op that
> can be hooked up to avoid extra rcu stall.
> 
> The peer->sta pointer itself can't be set to
> NULL/ERR_PTR because it is later used in
> sta_state() for extra sanity checks.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Patch applied to ath-next branch of ath.git, thanks.

0a744d927406 ath10k: prevent sta pointer rcu violation

-- 
https://patchwork.kernel.org/patch/9513391/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
