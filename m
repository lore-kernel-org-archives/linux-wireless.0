Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:5885 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeHXMUV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 08:20:21 -0400
Subject: Re: [PATCH 12/24] staging: wilc1000: move static variable
 'terminated_handle' to wilc_vif struct
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-13-git-send-email-ajay.kathat@microchip.com>
 <8e7928a5-1d9f-d36e-f7b2-dbbbddff94ae@microchip.com>
 <20180823200600.47e1b418@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <e21007c8-c043-54aa-433e-e7a2467fbda8@microchip.com> (sfid-20180824_104646_624258_5852622E)
Date: Fri, 24 Aug 2018 11:46:39 +0300
MIME-Version: 1.0
In-Reply-To: <20180823200600.47e1b418@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23.08.2018 17:36, Ajay Singh wrote:
> On Thu, 23 Aug 2018 11:11:18 +0300
> Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> 
>> On 14.08.2018 09:50, Ajay Singh wrote:
>>> Remove the use of static variable 'terminated_handle' and instead
>>> move in wilc_vif struct.
>>> After moving this variable to wilc_vif struct its not required to
>>> keep 'terminated_handle', so changed it to boolean type.  
>>
>> You can remove it at all and use wilc->hif_deinit_lock mutex also in
>> wilc_scan_complete_received() and wilc_network_info_received() it is
>> used in wilc_gnrl_async_info_received().
> 
> In my understanding, 'terminated_handle' is used to know the
> status when interface is getting deinit(). During deinitialization
> of an interface if any async event received for the interface(from
> firmware) should be ignored.

'terminated_handle' true only inside mutex. So, outside of it it will be
false, so *mostly* it will tell you when mutex is locked for deinit.
*Mostly*, because context switches may happen while a mutex is locked.

With the current approach you have this code:

int wilc_deinit(struct wilc_vif *vif)
{
	// ...
	mutex_lock(&vif->wilc->hif_deinit_lock);

	// (A)

	vif->is_termination_progress = true;
	// ...
	vif->is_termination_progress = false;

	mutex_unlokc(&vif->wilc->hif_deinit_lock);
}

And:

void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
{
	// ...
	if (!hif_drv || vif->is_termination_progress) {
		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
		return;
	}

	// ...
	
	// (B)
	result = wilc_enqueue_work(msg);	
	// ...
}

And:

static int wilc_enqueue_work(struct host_if_msg *msg)

{

        INIT_WORK(&msg->work, msg->fn);



        if (!msg->vif || !msg->vif->wilc || !msg->vif->wilc->hif_workqueue)

                return -EINVAL;


	// (C)
        if (!queue_work(msg->vif->wilc->hif_workqueue, &msg->work))

                return -EINVAL;



        return 0;

}


You may have the following scenario:
1. context switch in wilc_deinit() just after the mutex is taken (point A
above). vif->is_termination_progress = false at this point.

2. a new packet is received and wilc_network_info_received() gets executed
and execution reaches point B, goes to wilc_enqueue_work() and suspend at
point C then context switch.

3. wilc_deinit() resumes and finish its execution.

4. wilc_enqueue_work() resumes and queue_work() is executed but you already
freed the hif_workqueue. You will have a crash here.

Notice that hif_drv is not set to NULL on wilc_deinit() after it is kfree().

> 
> In my opinion its not right to only wait for the mutex in any of
> callback e.g wilc_scan_complete_received() because it will delay the
> handling of callback and try to process the event once lock is
> available for the interface which is already de-initialized.

But this is already done for wilc_gnrl_async_info_received().

> 
> Based on my understand 'mutex' alone is not enough to
> handle this and we some extra check to know if interface is down.

terminated_handle will *mostly* tell you when the mutex is locked, nothing
more.

I will
> check more about this patch how to handle the extra scenario for this
> case.
> Please suggest if someone has better idea on how to handle this. 
> 
>>
>>>
>>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
>>> ---
>>>  drivers/staging/wilc1000/host_interface.c     | 11 +++++------
>>>  drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/host_interface.c
>>> b/drivers/staging/wilc1000/host_interface.c index
>>> d5d81843..f71f451f 100644 ---
>>> a/drivers/staging/wilc1000/host_interface.c +++
>>> b/drivers/staging/wilc1000/host_interface.c @@ -185,7 +185,6 @@
>>> struct join_bss_param { u8 start_time[4];
>>>  };
>>>  
>>> -static struct host_if_drv *terminated_handle;
>>>  static u8 p2p_listen_state;
>>>  static struct timer_list periodic_rssi;
>>>  static struct wilc_vif *periodic_rssi_vif;
>>> @@ -3505,7 +3504,7 @@ int wilc_deinit(struct wilc_vif *vif)
>>>  
>>>  	mutex_lock(&vif->wilc->hif_deinit_lock);
>>>  
>>> -	terminated_handle = hif_drv;
>>> +	vif->is_termination_progress = true;
>>>  
>>>  	del_timer_sync(&hif_drv->scan_timer);
>>>  	del_timer_sync(&hif_drv->connect_timer);
>>> @@ -3543,7 +3542,7 @@ int wilc_deinit(struct wilc_vif *vif)
>>>  	kfree(hif_drv);
>>>  
>>>  	vif->wilc->clients_count--;
>>> -	terminated_handle = NULL;
>>> +	vif->is_termination_progress = false;
>>>  	mutex_unlock(&vif->wilc->hif_deinit_lock);
>>>  	return result;
>>>  }
>>> @@ -3565,7 +3564,7 @@ void wilc_network_info_received(struct wilc
>>> *wilc, u8 *buffer, u32 length) return;
>>>  	hif_drv = vif->hif_drv;
>>>  
>>> -	if (!hif_drv || hif_drv == terminated_handle) {
>>> +	if (!hif_drv || vif->is_termination_progress) {
>>>  		netdev_err(vif->ndev, "driver not init[%p]\n",
>>> hif_drv); return;
>>>  	}
>>> @@ -3611,7 +3610,7 @@ void wilc_gnrl_async_info_received(struct
>>> wilc *wilc, u8 *buffer, u32 length) 
>>>  	hif_drv = vif->hif_drv;
>>>  
>>> -	if (!hif_drv || hif_drv == terminated_handle) {
>>> +	if (!hif_drv || vif->is_termination_progress) {
>>>  		mutex_unlock(&wilc->hif_deinit_lock);
>>>  		return;
>>>  	}
>>> @@ -3662,7 +3661,7 @@ void wilc_scan_complete_received(struct wilc
>>> *wilc, u8 *buffer, u32 length) return;
>>>  	hif_drv = vif->hif_drv;
>>>  
>>> -	if (!hif_drv || hif_drv == terminated_handle)
>>> +	if (!hif_drv || vif->is_termination_progress)
>>>  		return;
>>>  
>>>  	if (hif_drv->usr_scan_req.scan_result) {
>>> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
>>> b/drivers/staging/wilc1000/wilc_wfi_netdevice.h index
>>> eb00e42..ba606d0 100644 ---
>>> a/drivers/staging/wilc1000/wilc_wfi_netdevice.h +++
>>> b/drivers/staging/wilc1000/wilc_wfi_netdevice.h @@ -121,6 +121,7 @@
>>> struct wilc_vif { struct timer_list during_ip_timer;
>>>  	bool obtaining_ip;
>>>  	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
>>> +	bool is_termination_progress;
>>>  };
>>>  
>>>  struct wilc {
>>>   
> 
> 
