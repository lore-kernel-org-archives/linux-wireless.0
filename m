Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55906 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbbCEGlF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 01:41:05 -0500
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>,
	Shengzhen Li <szli@marvell.com>
Date: Wed, 4 Mar 2015 22:38:52 -0800
Subject: RE: [PATCH 1/4] mwifiex: avoid queue_work while work is ongoing
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66746954D8@SC-VEXCH2.marvell.com> (sfid-20150305_074110_114712_F3DB4996)
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
	<1424883057-12102-2-git-send-email-patila@marvell.com>
 <87a8zu9rz5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a8zu9rz5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Tuesday, March 03, 2015 6:08 PM
> To: Avinash Patil
> Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Zhaoyang Liu;
> Shengzhen Li; Marc Yang
> Subject: Re: [PATCH 1/4] mwifiex: avoid queue_work while work is ongoing
> 
> Avinash Patil <patila@marvell.com> writes:
> 
> > From: Marc Yang <yangyang@marvell.com>
> >
> > Current code does not check whether main_work_queue or rx_work_queue
> > is running when preparing to do queue_work, this code fix add check
> > before calling queue_work, reducing unnecessary queue_work switch.
> >
> > This change instead sets more_task flag to ensure we run main_process
> > superloop once again.
> >
> > Signed-off-by: Marc Yang <yangyang@marvell.com>
> > Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> > Signed-off-by: Shengzhen Li <szli@marvell.com>
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Avinash Patil <patila@marvell.com>
> 
> Really, it took six persons to write this patch? Or do you just dump the same
> names to each patch?

This should have been "Reviewed-by". Apologies.
 

> > +void mwifiex_queue_main_work(struct mwifiex_adapter *adapter) {
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> > +	if (adapter->mwifiex_processing) {
> > +		adapter->more_task_flag = true;
> > +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> > +	} else {
> > +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> > +		queue_work(adapter->workqueue, &adapter->main_work);
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(mwifiex_queue_main_work);
> > +
> > +static void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter) {
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
> > +	if (adapter->rx_processing) {
> > +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> > +	} else {
> > +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> > +		queue_work(adapter->rx_workqueue, &adapter->rx_work);
> > +	}
> > +}
> 
> I can apply this patch, but to me this looks like a horrible hack.

We are here trying to avoid requeueing another work when work item is being executed. We set more_task flag to true if work item is being executed and mwifiex_main_process would execute superloop once again if more_task it set. work_pending() cannot be of much help here since we want to avoid queing only when work item is being executed. Could you please let us know if you think of any better way to handle this?
> --
> Kalle Valo

-Avinash
