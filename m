Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0LBQhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:37:53 -0500
Subject: Re: [RFC] iwlwifi: jiffies based tx queues watchdog
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101202163116.GA11331@redhat.com>
References: <1288191304-6177-1-git-send-email-sgruszka@redhat.com>
	 <1288192267.12056.75.camel@wwguy-huron> <20101202163116.GA11331@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 08:31:29 -0800
Message-ID: <1291307489.16838.21.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2010-12-02 at 08:31 -0800, Stanislaw Gruszka wrote:
> Hi Wey
> 
> On Wed, Oct 27, 2010 at 08:11:07AM -0700, Guy, Wey-Yi wrote:
> > > This patch replace monitor/recover timer by watchdog based on time
> > > stamp. New code allow to discover hangs more precisely.
> > > 
> > > Timeout values are currently doubled monitoring period values of
> > > previous timer. This have to be tuned based of firmware timing
> > > capabilities.
> > > 
> > > Code was not widely tested jet.
> > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > 
> > Thanks for the RFC, I will have people here test this patch with the
> > latest devices still under development. At the meantime, could you also
> > do some testing on your side with the devices you have since we can not
> > cover all the older devices already out there.
> 
> I finally get some time to test this patch. I found two issues. 
> 
> First problem is oops on 3945, when I set wd_timeout to 10 ms.
> Frequent resets show a bug when ieee80211_reconfig do call to
> iwl_send_add_sta, and in parallel, restart code do 
> iwl3945_down()->iwl3945_hw_txq_ctx_stop() and free txq that
> iwl_send_add_sta() want to use. This need some better fix
> and careful review, but adding
> 
>         /* initialize force reset */
>         priv->force_reset[IWL_RF_RESET].reset_duration =
>                 IWL_DELAY_NEXT_FORCE_RF_RESET;
>         priv->force_reset[IWL_FW_RESET].reset_duration =
>                 IWL_DELAY_NEXT_FORCE_FW_RELOAD;
> 
> to iwl3945_init_drv to prevent too frequent reset make bug gone.
> 
> Second problem I saw, was also when watchdag want to do frequent
> resets. When reset was not actually performed, because of above
> reset duration limit, watchdog stays disabled. Keep watchdog
> running when iwl_force_reset() return error fix that problem.
> 
> In general watchdog do the job. I will official patch shortly.
> 

Thanks for all the works and testing. Sorry we did not have chance to
test this patch since we are very busy for the past few weeks.

The patch looks good, what devices you are test with? my only
consideration is how this perform with newer devices, especially with
the WiFi/BT combo devices which we are working on now.

Please go ahead and send the official patch, I will try my best to do
some test next week on the WiFi/BT combo device to make sure it work as
expected.

Thanks
Wey



