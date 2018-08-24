Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:5920 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeHXMVJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 08:21:09 -0400
Subject: Re: [PATCH 11/24] staging: wilc1000: move hif specific static
 variables to 'wilc' structure
To: Ajay Singh <ajay.kathat@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-12-git-send-email-ajay.kathat@microchip.com>
 <8020e04f-23b0-1b1c-9d75-9dc5fdfde9f3@microchip.com>
 <20180823153941.0ff5f43e@ajaysk-VirtualBox>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <96e78d41-ec99-9c66-6b76-54c5af4fb4ae@microchip.com> (sfid-20180824_104734_431001_FD27F094)
Date: Fri, 24 Aug 2018 11:47:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180823153941.0ff5f43e@ajaysk-VirtualBox>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23.08.2018 13:09, Ajay Singh wrote:
> On Thu, 23 Aug 2018 11:11:09 +0300
> Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> 
>> On 14.08.2018 09:50, Ajay Singh wrote:
>>> Avoid use of static variable and move it in 'wilc' structure
>>> related to hif and added NULL before accessing hif_workqueue in
>>> wilc_enqueue_work().
>>>
>>> Below variables are moved to 'wilc' struct:
>>>  struct workqueue_struct *hif_workqueue;
>>>  struct mutex hif_deinit_lock;
>>>  struct completion hif_driver_comp;
>>>
>>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
>>> ---
>>>  drivers/staging/wilc1000/host_interface.c     | 43
>>> ++++++++++++++-------------
>>> drivers/staging/wilc1000/wilc_wfi_netdevice.h |  4 +++ 2 files
>>> changed, 26 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/host_interface.c
>>> b/drivers/staging/wilc1000/host_interface.c index 642c314..d5d81843
>>> 100644 --- a/drivers/staging/wilc1000/host_interface.c
>>> +++ b/drivers/staging/wilc1000/host_interface.c
>>> @@ -187,9 +187,6 @@ struct join_bss_param {

[...]

>>>  void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer,
>>> u32 length) diff --git
>>> a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
>>> b/drivers/staging/wilc1000/wilc_wfi_netdevice.h index
>>> ee8eda7..eb00e42 100644 ---
>>> a/drivers/staging/wilc1000/wilc_wfi_netdevice.h +++
>>> b/drivers/staging/wilc1000/wilc_wfi_netdevice.h @@ -173,6 +173,10
>>> @@ struct wilc { struct rf_info dummy_statistics; bool enable_ps;
>>>  	int clients_count;
>>> +	struct workqueue_struct *hif_workqueue;
>>> +	/* deinitialization lock */
>>> +	struct mutex hif_deinit_lock;
>>> +	struct completion hif_driver_comp;  
>>
>> I'm thinking now... wouldn't fit these better to struct host_if_drv?
> 
> No, In my opinion it should be part of 'wilc' struct as only the single
> instance of there variables is required. 'host_if_drv' is maintained
> separately for each interface.
> 

Ok, agree on this.

>>
>>>  };
>>>  
>>>  struct wilc_wfi_mon_priv {
>>>   
> 
> 
