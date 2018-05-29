Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45068 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966992AbeE2VkV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 17:40:21 -0400
Date: Tue, 29 May 2018 14:40:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        Eyal Reizer <eyalreizer@gmail.com>
Subject: Re: [RFT 6/6] wlcore: Use generic runtime pm calls for wowlan elp
 configuration
Message-ID: <20180529213928.GA5705@atomide.com> (sfid-20180529_234058_156293_DCD2ABDB)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-7-tony@atomide.com>
 <75fb865b-dc84-2e7d-d879-581e65dc343d@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <75fb865b-dc84-2e7d-d879-581e65dc343d@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Grygorii Strashko <grygorii.strashko@ti.com> [180529 19:25]:
> On 05/29/2018 01:06 PM, Tony Lindgren wrote:
> > From: Eyal Reizer <eyalreizer@gmail.com>
> > 
> > With runtime PM enabled, we can now use generic calls to
> > pm_generic_runtime_suspend and pm_generic_runtime_resume for enabling elp
> > during suspend when wowlan is enabled and waking the chip from elp
> > on resume.
> 
> Sry, but not sure you can :(
> 
> These functions are not used by drivers directly because system suspend
> are not synchronized with PM runtime, so if you call pm_generic_runtime_suspend()
> and, at the same time, there is pm_runtime_get_() in progress --> race ...
> 
> The pm_runtime_force_() APIs have to be used, or 
> PM runtime drivers functions can be called directly, but only if it possible to be
> sure no other PM runtime calls active which is usually true at suspend_noirq stage. 

Oh right, those are subsystem calls. Seems like
pm_runtime_force_suspend/resume() should work here,
Eyal?

Regards,

Tony
