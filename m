Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46442 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750757AbdHaGLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 02:11:48 -0400
Message-ID: <1504159902.31031.11.camel@coelho.fi> (sfid-20170831_081204_250562_1E6AEBFA)
From: Luca Coelho <luca@coelho.fi>
To: David Weinehall <david.weinehall@linux.intel.com>
Cc: jikos@kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwifi@intel.com,
        rui.zhang@intel.com, edubezval@gmail.com, linux-pm@vger.kernel.org,
        david.weinehall@intel.com, johannes.berg@intel.com,
        kvalo@codeaurora.org, sara.sharon@intel.com,
        emmanuel.grumbach@intel.com
Date: Thu, 31 Aug 2017 09:11:42 +0300
In-Reply-To: <20170830145726.eq7qs4jtdsqa74lu@boom>
References: <alpine.LSU.2.20.1708171537380.3581@cbobk.fhfr.pm>
         <20170822073729.4856-1-luca@coelho.fi>
         <20170830145726.eq7qs4jtdsqa74lu@boom>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2] iwlwifi: pcie: move rx workqueue initialization to
 iwl_trans_pcie_alloc()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-08-30 at 17:57 +0300, David Weinehall wrote:
> On Tue, Aug 22, 2017 at 10:37:29AM +0300, Luca Coelho wrote:
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > Work queues cannot be allocated when a mutex is held because the mutex
> > may be in use and that would make it sleep.  Doing so generates the
> > following splat with 4.13+:
> > 
> > [   19.513298] ======================================================
> > [   19.513429] WARNING: possible circular locking dependency detected
> > [   19.513557] 4.13.0-rc5+ #6 Not tainted
> > [   19.513638] ------------------------------------------------------
> > [   19.513767] cpuhp/0/12 is trying to acquire lock:
> > [   19.513867]  (&tz->lock){+.+.+.}, at: [<ffffffff924afebb>] thermal_zone_get_temp+0x5b/0xb0
> > [   19.514047]
> > [   19.514047] but task is already holding lock:
> > [   19.514166]  (cpuhp_state){+.+.+.}, at: [<ffffffff91cc4baa>] cpuhp_thread_fun+0x3a/0x210
> > [   19.514338]
> > [   19.514338] which lock already depends on the new lock.
> > 
> > This lock dependency already existed with previous kernel versions,
> > but it was not detected until commit 49dfe2a67797 ("cpuhotplug: Link
> > lock stacks for hotplug callbacks") was introduced.
> > 
> > Reported-by: David Weinehall <david.weinehall@intel.com>
> > Reported-by: Jiri Kosina <jikos@kernel.org>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> With this patch I no longer get the lockdep warning,
> and the driver seems to work just as well as before.

Great! Thanks for reporting and testing, David!


> Thanks!
> 
> Tested-by: David Weinehall <david.weinehall@linux.intel.com>

Thanks for this too, but unfortunately it's too late to add it, since
the patch is already in net tree.

--
Cheers,
Luca.
