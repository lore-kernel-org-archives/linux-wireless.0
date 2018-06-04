Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:27845 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeFDJm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 05:42:29 -0400
Subject: Re: [PATCH 0/4] staging: wilc1000: modification to use list_head data
 structure
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <c35a0695-efcb-2063-c64d-61402fcca7a6@microchip.com> (sfid-20180604_114349_114600_719F0F28)
Date: Mon, 4 Jun 2018 12:42:28 +0300
MIME-Version: 1.0
In-Reply-To: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 04.06.2018 08:29, Ajay Singh wrote:
> Instead of having own linked list implementation to maintain buffer queue change
> to use list_head. Also removed the few elements from 'wilc' struct as it's not
> required to be part of 'wilc' struct.
> 
> Ajay Singh (4):
>   staging: wilc1000: use list_head to maintain 'txq_entry_t' elements of
>     tx queue
>   staging: wilc1000: use list_head to maintain 'rxq_entry_t elements in
>     rx queue
>   staging: wilc1000: remove 'rxq_entries' from 'wilc' struct
>   staging: wilc1000: move 'txq_spinlock_flags' from 'wilc' structure to
>     local variable
> 
>  drivers/staging/wilc1000/linux_wlan.c         |   2 +
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h |   9 +--
>  drivers/staging/wilc1000/wilc_wlan.c          | 101 ++++++++------------------
>  drivers/staging/wilc1000/wilc_wlan.h          |   5 +-
>  4 files changed, 37 insertions(+), 80 deletions(-)
> 
