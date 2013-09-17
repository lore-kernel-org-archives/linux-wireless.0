Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60822 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab3IQSUg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 14:20:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Mack <zonque@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Tue, 17 Sep 2013 11:19:39 -0700
Subject: RE: [PATCH 1/1] mwifiex: queue main work from main process when
 bailing on races
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C587D4@SC-VEXCH1.marvell.com> (sfid-20130917_202041_493972_BF73D1AB)
References: <1379331546-30617-1-git-send-email-zonque@gmail.com>
 <1379331546-30617-2-git-send-email-zonque@gmail.com>
 <477F20668A386D41ADCC57781B1F70430F44C5849E@SC-VEXCH1.marvell.com>
 <52378D81.3070707@gmail.com>
In-Reply-To: <52378D81.3070707@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> >>  	/* Check if already processing */
> >>  	if (adapter->mwifiex_processing) {
> >>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> >> +		queue_work(adapter->workqueue, &adapter->main_work);
> >
> > This is specific to SDIO interface,
> 
> Is it really? By checking adapter->mwifiex_processing, the driver seems
> to expect mwifiex_main_process() to be called from multiple execution
> paths, and in that case, we will always loose one execution cycle in

You are right. I overlooked it.

> case we bail early. I actually wonder why this didn't hit us earlier,
> but I might miss a detail.

I guess, in your case, the interrupt comes in at line 363 where you have passed the int_status or RX_RCVD checking but the mwifiex_processing flag is still true.

 361         if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
 362                 goto process_start;
 363
 364         spin_lock_irqsave(&adapter->main_proc_lock, flags);
 365         adapter->mwifiex_processing = false;
 366         spin_unlock_irqrestore(&adapter->main_proc_lock, flags);

The interrupt thread exits because mwifiex_processing is true.
Therefore the mwifiex_main_process misses this interrupt.

> 
> OTOH, the worst thing that can happen if the function is executed too
> often is that it exits early and does nothing.
> 
> > +               if (adapter->iface_type == MWIFIEX_SDIO)
> > +                       queue_work(adapter->workqueue, &adapter->main_work);
> 
> I can of course add this, but I don't fully understand why the driver
> takes care of concurrently running executing paths and then just bails
> silently in case a race is detected.

No. Your original patch is fine.
Could you resend it as [PATCH 3.12]? I will ACK in that thread.

Thanks,
Bing



