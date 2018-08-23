Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41867 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbeHWLh7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 07:37:59 -0400
Subject: Re: [PATCH 00/24] staging: wilc1000: avoid use of static and global
 variable
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <3536aa12-233c-3a77-ca7f-1766d6a9bc6c@microchip.com> (sfid-20180823_101016_079857_BBA8231D)
Date: Thu, 23 Aug 2018 11:09:29 +0300
MIME-Version: 1.0
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ajay,

Few comments on this series. See per patch replies.

Thank you,
Claudiu Beznea

On 14.08.2018 09:49, Ajay Singh wrote:
> This patch set mainly contains changes to avoid the use of static
> and global variables. Also contains few patch to avoid the checkpatch
> warning arise due to code refactor.
> 
> Ajay Singh (24):
>   staging: wilc1000: move 'wilc_enable_ps' global variable into 'wilc'
>     struct
>   staging: wilc1000: move 'aging_timer' static variable to wilc_priv
>     struct
>   staging: wilc1000: fix to use correct index to free scanned info in
>     clear_shadow_scan()
>   staging: wilc1000: remove unnecessary NULL check in
>     clear_shadow_scan()
>   staging: wilc1000: moved last_scanned_shadow & last_scanned_cnt to
>     wilc_priv struct
>   staging: wilc1000: move during_ip_timer & wilc_optaining_ip to
>     'wilc_vif' struct
>   staging: wilc1000: remove unused variable 'op_ifcs'
>   staging: wilc1000: avoid use of extra 'if' condition in wilc_init()
>   staging: wilc1000: move static variable clients_count to 'wilc'
>     structure
>   staging: wilc1000: move wilc_multicast_mac_addr_list to 'wilc_vif'
>     struct
>   staging: wilc1000: move hif specific static variables to 'wilc'
>     structure
>   staging: wilc1000: move static variable 'terminated_handle' to
>     wilc_vif struct
>   staging: wilc1000: move 'periodic_rssi' as part of 'wilc_vif' struct
>   staging: wilc1000: rename 'dummy_statistics' variable to
>     'periodic_stat'
>   staging: wilc1000: move 'rcv_assoc_resp' as part of hif_drv
>   staging: wilc1000: refactor tcp_process() to avoid extra leading tabs
>   staging: wilc1000: use lowercase for get_BSSID() and HIL variable
>   staging: wilc1000: move tcp_ack_filter algo related variables to
>     'wilc_vif' struct
>   staging: wilc1000: avoid line over 80 chars in
>     wilc_wlan_txq_filter_dup_tcp_ack()
>   staging: wilc1000: avoid line over 80 chars in tcp_process()
>   staging: wilc1000: remove unused code to set and get IP address
>   staging: wilc1000: move 'chip_ps_state' static variable as part of
>     'wilc' struct
>   staging: wilc1000: move 'wilc_connecting' static variable to
>     'wilc_vif' struct
>   staging: wilc1000: remove unnecessary static variable
>     'p2p_listen_state'
> 
>  drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
>  drivers/staging/wilc1000/host_interface.c         | 227 +++++-----------------
>  drivers/staging/wilc1000/host_interface.h         |   9 +-
>  drivers/staging/wilc1000/linux_wlan.c             |  29 ++-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 191 +++++++++---------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  47 ++++-
>  drivers/staging/wilc1000/wilc_wlan.c              | 167 ++++++++--------
>  drivers/staging/wilc1000/wilc_wlan.h              |   3 +-
>  8 files changed, 284 insertions(+), 393 deletions(-)
> 
