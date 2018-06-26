Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57203 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbeFZHtC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 03:49:02 -0400
Subject: Re: [PATCH 00/12] staging: wilc1000: address TODO item to remove
 host_if_work()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <4df4a647-7301-0221-5526-0b4210e41d49@microchip.com> (sfid-20180626_094906_051881_E4799B1C)
Date: Tue, 26 Jun 2018 10:48:57 +0300
MIME-Version: 1.0
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For this series:

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 26.06.2018 09:07, Ajay Singh wrote:
> The current patch series contains changes to address TODO item [1].
> 
> [1]. Move handling for each individual members of 'union message_body' out
> into a separate 'struct work_struct' and completely remove the multiplexer
> that is currently part of host_if_work(), allowing movement of the
> implementation of each message handler into the callsite of the function
> that currently queues the 'host_if_msg'.
> 
> 
> Ajay Singh (12):
>   staging: wilc1000: remove host_if_work() to handle TODO list issue
>   staging: wilc1000: remove unused marco related to HIF commands
>   staging: wilc1000: move the allocation of cmd out of
>     wilc_enqueue_cmd()
>   staging: wilc1000: added 'work_comp' completion as part of host_if_msg
>   staging: wilc1000: remove 'hif_thread_comp' completions
>   staging: wilc1000: rename wilc_enqueue_cmd() to wilc_enqueue_work()
>   staging: wilc1000: handle freeing of key data in wep add key
>   staging: wilc1000: handle freeing of key data in wilc_add_ptk()
>   staging: wilc1000: handle freeing of 'key' & 'seq' data in
>     wilc_add_rx_gtk()
>   staging: wilc1000: avoid use of static variable 'inactive_time'
>   staging: wilc1000: avoid use of static variable 'rssi'
>   staging: wilc1000: updated TODO file
> 
>  drivers/staging/wilc1000/TODO                     |    5 -
>  drivers/staging/wilc1000/host_interface.c         | 1548 +++++++++++----------
>  drivers/staging/wilc1000/host_interface.h         |    7 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |    2 +-
>  4 files changed, 799 insertions(+), 763 deletions(-)
> 
