Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab0LBQbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:31:21 -0500
Date: Thu, 2 Dec 2010 17:31:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] iwlwifi: jiffies based tx queues watchdog
Message-ID: <20101202163116.GA11331@redhat.com>
References: <1288191304-6177-1-git-send-email-sgruszka@redhat.com>
 <1288192267.12056.75.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288192267.12056.75.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Wed, Oct 27, 2010 at 08:11:07AM -0700, Guy, Wey-Yi wrote:
> > This patch replace monitor/recover timer by watchdog based on time
> > stamp. New code allow to discover hangs more precisely.
> > 
> > Timeout values are currently doubled monitoring period values of
> > previous timer. This have to be tuned based of firmware timing
> > capabilities.
> > 
> > Code was not widely tested jet.
> 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> 
> Thanks for the RFC, I will have people here test this patch with the
> latest devices still under development. At the meantime, could you also
> do some testing on your side with the devices you have since we can not
> cover all the older devices already out there.

I finally get some time to test this patch. I found two issues. 

First problem is oops on 3945, when I set wd_timeout to 10 ms.
Frequent resets show a bug when ieee80211_reconfig do call to
iwl_send_add_sta, and in parallel, restart code do 
iwl3945_down()->iwl3945_hw_txq_ctx_stop() and free txq that
iwl_send_add_sta() want to use. This need some better fix
and careful review, but adding

        /* initialize force reset */
        priv->force_reset[IWL_RF_RESET].reset_duration =
                IWL_DELAY_NEXT_FORCE_RF_RESET;
        priv->force_reset[IWL_FW_RESET].reset_duration =
                IWL_DELAY_NEXT_FORCE_FW_RELOAD;

to iwl3945_init_drv to prevent too frequent reset make bug gone.

Second problem I saw, was also when watchdag want to do frequent
resets. When reset was not actually performed, because of above
reset duration limit, watchdog stays disabled. Keep watchdog
running when iwl_force_reset() return error fix that problem.

In general watchdog do the job. I will official patch shortly.

Stanislaw
