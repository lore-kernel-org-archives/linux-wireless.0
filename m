Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdHXNuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 09:50:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] iwlwifi: pcie: move rx workqueue initialization to
 iwl_trans_pcie_alloc()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170822073729.4856-1-luca@coelho.fi>
References: <20170822073729.4856-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: jikos@kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, linux-kernel@vger.kernel.org,
        linuxwifi@intel.com, rui.zhang@intel.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, david.weinehall@intel.com,
        johannes.berg@intel.com, sara.sharon@intel.com,
        emmanuel.grumbach@intel.com
Message-Id: <20170824135023.EB43F60712@smtp.codeaurora.org> (sfid-20170824_155043_872236_B4AB3921)
Date: Thu, 24 Aug 2017 13:50:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Work queues cannot be allocated when a mutex is held because the mutex
> may be in use and that would make it sleep.  Doing so generates the
> following splat with 4.13+:
> 
> [   19.513298] ======================================================
> [   19.513429] WARNING: possible circular locking dependency detected
> [   19.513557] 4.13.0-rc5+ #6 Not tainted
> [   19.513638] ------------------------------------------------------
> [   19.513767] cpuhp/0/12 is trying to acquire lock:
> [   19.513867]  (&tz->lock){+.+.+.}, at: [<ffffffff924afebb>] thermal_zone_get_temp+0x5b/0xb0
> [   19.514047]
> [   19.514047] but task is already holding lock:
> [   19.514166]  (cpuhp_state){+.+.+.}, at: [<ffffffff91cc4baa>] cpuhp_thread_fun+0x3a/0x210
> [   19.514338]
> [   19.514338] which lock already depends on the new lock.
> 
> This lock dependency already existed with previous kernel versions,
> but it was not detected until commit 49dfe2a67797 ("cpuhotplug: Link
> lock stacks for hotplug callbacks") was introduced.
> 
> Reported-by: David Weinehall <david.weinehall@intel.com>
> Reported-by: Jiri Kosina <jikos@kernel.org>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

10a54d8196d1 iwlwifi: pcie: move rx workqueue initialization to iwl_trans_pcie_alloc()

-- 
https://patchwork.kernel.org/patch/9914349/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
