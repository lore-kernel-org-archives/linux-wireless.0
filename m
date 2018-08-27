Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:24403 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbeH0JMm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 05:12:42 -0400
Date: Mon, 27 Aug 2018 10:57:31 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 12/24] staging: wilc1000: move static variable
 'terminated_handle' to wilc_vif struct
Message-ID: <20180827105731.19919c22@ajaysk-VirtualBox> (sfid-20180827_072740_671455_0C027BA8)
In-Reply-To: <e21007c8-c043-54aa-433e-e7a2467fbda8@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-13-git-send-email-ajay.kathat@microchip.com>
        <8e7928a5-1d9f-d36e-f7b2-dbbbddff94ae@microchip.com>
        <20180823200600.47e1b418@ajaysk-VirtualBox>
        <e21007c8-c043-54aa-433e-e7a2467fbda8@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 24 Aug 2018 11:46:39 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 23.08.2018 17:36, Ajay Singh wrote:
> > On Thu, 23 Aug 2018 11:11:18 +0300
> > Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> >   
> >> On 14.08.2018 09:50, Ajay Singh wrote:  
> >>> Remove the use of static variable 'terminated_handle' and instead
> >>> move in wilc_vif struct.
> >>> After moving this variable to wilc_vif struct its not required to
> >>> keep 'terminated_handle', so changed it to boolean type.    
> >>
> >> You can remove it at all and use wilc->hif_deinit_lock mutex also
> >> in wilc_scan_complete_received() and wilc_network_info_received()
> >> it is used in wilc_gnrl_async_info_received().  
> > 
> > In my understanding, 'terminated_handle' is used to know the
> > status when interface is getting deinit(). During deinitialization
> > of an interface if any async event received for the interface(from
> > firmware) should be ignored.  
> 
> 'terminated_handle' true only inside mutex. So, outside of it it will
> be false, so *mostly* it will tell you when mutex is locked for
> deinit. *Mostly*, because context switches may happen while a mutex
> is locked.
> 

Yes, outside the mutex 'terminated_handle' would be false. 
I already agreed that while fixing the bug using 'terminated_handle'
all the scenarios are not handled but as you suggested before
to remove 'terminated_handle' and only use 'mutex' will also not
help to address all corner scenarios.  So, I suggest to keep the
current status by making use of this flag and handle all scenario in
later patch to de-initialization graceful.

> With the current approach you have this code:
> 
> int wilc_deinit(struct wilc_vif *vif)
> {
> 	// ...
> 	mutex_lock(&vif->wilc->hif_deinit_lock);
> 
> 	// (A)
> 
> 	vif->is_termination_progress = true;
> 	// ...
> 	vif->is_termination_progress = false;
> 
> 	mutex_unlokc(&vif->wilc->hif_deinit_lock);
> }
> 
> And:
> 
> void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32
> length) {
> 	// ...
> 	if (!hif_drv || vif->is_termination_progress) {
> 		netdev_err(vif->ndev, "driver not init[%p]\n",
> hif_drv); return;
> 	}
> 
> 	// ...
> 	
> 	// (B)
> 	result = wilc_enqueue_work(msg);	
> 	// ...
> }
> 
> And:
> 
> static int wilc_enqueue_work(struct host_if_msg *msg)
> 
> {
> 
>         INIT_WORK(&msg->work, msg->fn);
> 
> 
> 
>         if (!msg->vif || !msg->vif->wilc
> || !msg->vif->wilc->hif_workqueue)
> 
>                 return -EINVAL;
> 
> 
> 	// (C)
>         if (!queue_work(msg->vif->wilc->hif_workqueue, &msg->work))
> 
>                 return -EINVAL;
> 
> 
> 
>         return 0;
> 
> }
> 
> 
> You may have the following scenario:
> 1. context switch in wilc_deinit() just after the mutex is taken
> (point A above). vif->is_termination_progress = false at this point.
> 
> 2. a new packet is received and wilc_network_info_received() gets
> executed and execution reaches point B, goes to wilc_enqueue_work()
> and suspend at point C then context switch.
> 

Thanks for explaining the scenario with an example.

For the given scenario, I think not only here it can even suspend
after posting the work queue and start the execution of handler
function eg. handle_recvd_gnrl_async_info()(there is no protection in
handle function)

There are some combination of these scenario, I will relook into these
cases and check how to handle them separately.

> 3. wilc_deinit() resumes and finish its execution.
> 
> 4. wilc_enqueue_work() resumes and queue_work() is executed but you
> already freed the hif_workqueue. You will have a crash here.
> 
> Notice that hif_drv is not set to NULL on wilc_deinit() after it is
> kfree().
> 
> > 
> > In my opinion its not right to only wait for the mutex in any of
> > callback e.g wilc_scan_complete_received() because it will delay the
> > handling of callback and try to process the event once lock is
> > available for the interface which is already de-initialized.  
> 
> But this is already done for wilc_gnrl_async_info_received().
> 
> > 
> > Based on my understand 'mutex' alone is not enough to
> > handle this and we some extra check to know if interface is down.  
> 
> terminated_handle will *mostly* tell you when the mutex is locked,
> nothing more.
> 
> I will
> > check more about this patch how to handle the extra scenario for
> > this case.
> > Please suggest if someone has better idea on how to handle this. 
> >   
