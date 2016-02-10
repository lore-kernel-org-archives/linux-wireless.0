Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36365 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbcBJRoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 12:44:23 -0500
Received: by mail-qg0-f51.google.com with SMTP id y9so19318804qgd.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 09:44:22 -0800 (PST)
Subject: Fwd: Re: wilc1000 staging driver initialization failure
References: <n9053t$nmb$1@ger.gmane.org>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
From: Andrew Boyce <andrew@idvector.net>
Message-ID: <56BB76F4.9070702@idvector.net> (sfid-20160210_184427_025972_9657B755)
Date: Wed, 10 Feb 2016 12:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <n9053t$nmb$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Sorry for the mass forward, I was instructed to email more than just the 
linux-wireless mailing list.

Any help would be appreciated.

Thanks!
	 -Andrew


-------- Forwarded Message --------
Subject: Re: wilc1000 staging driver initialization failure
Date: Thu, 4 Feb 2016 13:26:04 -0500
From: Andrew Boyce <andrew-YzRM5efQXs3k1uMJSBkQmQ@public.gmane.org>
To: linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Newsgroups: gmane.linux.kernel.wireless.general
References: <n8u1av$hqv$1@ger.gmane.org>

I've enabled more debugging.


The core of the issue seems to be that wilc_lock_timeout() is for some
reason failing to down_timeout(). I do not currently understand enough
of the internals to understand why.



[ 6852.530000] wilc1000: module is from the staging directory, the
quality is unknown, you have been warned.
[ 6852.570000] wilc1000_sdio: module is from the staging directory, the
quality is unknown, you have been warned.
[ 6852.580000] wilc1000_sdio mmc0:0001:1: Initializing netdev
[ 6852.580000] DBG [wilc_create_wiphy: 2783]Registering wifi device
[ 6852.580000] DBG [WILC_WFI_CfgAlloc: 2747]Allocating wireless device
[ 6852.580000] INFO [wilc_create_wiphy]Max number of PMKIDs = 16
[ 6852.580000] INFO [wilc_create_wiphy]Max scan ids = 10,Max scan IE len
= 1000,Signal Type = 1,Interface Modes = 844,Interface Type = 2
[ 6852.580000] DBG [wilc_create_wiphy: 2822]Successful Registering
[ 6852.580000] DBG [wilc_create_wiphy: 2783]Registering wifi device
[ 6852.580000] DBG [WILC_WFI_CfgAlloc: 2747]Allocating wireless device
[ 6852.580000] INFO [wilc_create_wiphy]Max number of PMKIDs = 16
[ 6852.580000] INFO [wilc_create_wiphy]Max scan ids = 10,Max scan IE len
= 1000,Signal Type = 1,Interface Modes = 844,Interface Type = 2
[ 6852.580000] DBG [wilc_create_wiphy: 2822]Successful Registering
[ 6852.580000] wilc1000_sdio mmc0:0001:1: Driver Initializing success
[ 6856.900000] DBG [wilc_mac_open: 1020]MAC OPEN[cd8c9000]
[ 6856.900000] DBG [wilc_init_host_int: 2835]Host[cd8c9000][cd97cd00]
[ 6856.900000] DBG [wilc_init: 3790]Initializing host interface for client 1
[ 6856.900000] DBG [wilc_init: 3810]Global handle pointer value=cee0f400
[ 6856.900000] DBG [wilc_init: 3824]INIT: CLIENT COUNT 0
[ 6856.900000] INFO [wilc_init]Initialization values, Site survey value: 2
  Scan source: 0
  Active scan time: 10
  Passive scan time: 1200
Current tx Rate = 0
[ 6856.900000] DBG [wilc_mac_open: 1029]*** re-init ***
[ 6856.900000] DBG [wlan_init_locks: 809]Initializing Locks ...
[ 6856.900000] DBG [wilc_wlan_init: 1593]Initializing WILC_Wlan ...
[ 6856.900000] ERR [wilc1000_wlan_init: 900]Initializing WILC_Wlan FAILED
[ 6856.900000] ERR [wilc1000_wlan_init: 900]Initializing WILC_Wlan FAILED
[ 6856.900000] DBG [wlan_deinit_locks: 835]De-Initializing Locks
[ 6856.900000] ERR [wilc1000_wlan_init: 983]WLAN Iinitialization FAILED
[ 6856.900000] ERR [wilc1000_wlan_init: 983]WLAN Iinitialization FAILED
[ 6856.900000] ERR [wilc_mac_open: 1032]Failed to initialize wilc1000
[ 6856.900000] ERR [wilc_mac_open: 1032]Failed to initialize wilc1000
[ 6856.900000] DBG [wilc_deinit: 3896]De-initializing host interface for
client 1
[ 6856.900000] DBG [wilc_deinit: 3905]>> Connect timer is active
[ 6856.900000] DBG [wilc_send_config_pkt: 619]Sending config SET PACKET
WID:2085
[ 6856.900000] Sending config SET PACKET WID:2085
[ 6856.900000] Sending config SET PACKET val:
[ 6856.900000] DBG [wilc_wlan_cfg_set: 1443][WILC]PACKET Commit with
sequence number 0
[ 6856.900000] [WILC]PACKET Commit with sequence number 0
[ 6856.900000] DBG [wilc_wlan_cfg_set: 1446]Processing cfg_set()
[ 6856.900000] Processing cfg_set()
[ 6856.900000] DBG [wilc_wlan_txq_add_cfg_pkt: 368]Adding config packet ...
[ 6856.900000] DBG [wilc_wlan_txq_add_cfg_pkt: 389]Adding the config
packet at the Queue tail
[ 6856.900000] DBG [wilc_lock_timeout: 257]Locking cd9eb82c
[ 6856.900000] Locking cd9eb82c
[ 6856.900000] timeout 2000
[ 6856.900000] Failed, mutex is NULL
[ 6856.900000] DBG [wilc_wlan_txq_add_to_head: 150]Number of entries in
TxQ = 1
[ 6856.900000] DBG [wilc_wlan_txq_add_to_head: 155]Wake up the txq_handler
[ 6856.900000] DBG [wilc_lock_timeout: 257]Locking cd9eb850
[ 6856.900000] Locking cd9eb850
[ 6856.900000] timeout 2000
[ 6858.900000] Failed, mutex is NULL
[ 6858.900000] DBG [hostIFthread: 2793]THREAD: Exiting HostIfThread
[ 6858.900000] DBG [hostIFthread: 2989]Releasing thread exit semaphore
[ 6858.900000] INFO [clear_shadow_scan]destroy aging timer
[ 6858.900000] DBG [wilc_deinit_host_int: 2878]destroy during ip


Any help would be appreciated.

Thanks!
  -Andrew



On 2/3/16 6:09 PM, Andrew Boyce wrote:
> I've been working to build and test the staging wilc1000-sdio driver and
> have run into a problem.
>
> I've built a kernel from Greg KH's staging-testing branch and loaded it
> onto our device. When I try to bring the interface up, I get the following:
>
> root@test:~# ifconfig wlan0 up
> kernel: [ 3510.400000] DBG [wilc_mac_open: 1014]MAC OPEN[cef20000]
> kernel: [ 3510.400000] DBG [wilc_init_host_int:
> 2835]Host[cef20000][cd0df1c0]
> kernel: [ 3510.400000] DBG [wilc_mac_open: 1023]*** re-init ***
> kernel: [ 3510.400000] DBG [wlan_init_locks: 803]Initializing Locks ...
> kernel: [ 3510.400000] DBG [wilc_wlan_init: 1589]Initializing WILC_Wlan ...
> kernel: [ 3510.400000] DBG [wlan_deinit_locks: 829]De-Initializing Locks
> SIOCSIFFLAGS: Input/output error
> kernel: [ 3512.400000] [Sendconfigpkt]Set Timed out
> kernel: [ 3512.400000] DBG [hostIFthread: 2793]THREAD: Exiting HostIfThread
>
> Any ideas?
>
> I understand that this driver is under active development. Hopefully I
> can get some of the bugs resolved.
>
> Thanks!
>   --Andrew
>
> P.S. I apologize if this is the wrong forum for this type of bug report.
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



