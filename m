Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32073 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbbHXIIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 04:08:35 -0400
Message-ID: <55DAD0FD.3070807@broadcom.com> (sfid-20150824_100843_929863_969182FE)
Date: Mon, 24 Aug 2015 10:08:29 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Gucea Doru <gucea.doru@gmail.com>, <eccopark@broadcom.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: bcmdhd: Concurrent use of wlan0 and virtual interface in managed
 mode
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>
In-Reply-To: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2015 05:15 PM, Gucea Doru wrote:
> Hello, community

As you are using bcmdhd I don't think this particular community cares a 
lot about it. But I will take the bait ;-)

> I'm a Master student doing my research on a subject related to Android
> and multiple paths between two nodes. What I try to do now is to allow
> a client to connect to multiple APs (Access Points).
>
> I started with the simplest use-case where I have only two APs (AP1
> and AP2) and an Android client  - a Nexus 5 device running the Kernel
> from [1]. For the connection with AP1 I used the already present
> interface wlan0. For the connection with AP2 I tried to use a newly
> created virtual interface but the wpa_supplicant connection is not
> successful. I'm not sure if this is a driver limitation or a driver
> bug.

I am not sure either. For the upstream brcmfmac we don't allow it at the 
moment. I am kinda surprised you were able to create the additional 
interface. There are a couple of things that I can think of here which 
may cause issues:

- APs operating on different channels.
- Both STA interfaces have powersave enabled.
- Firmware/driver do not support multi STA.

If APs are operating on the same channel it may work, but you probably 
won't have advantage of MP-TCP because of medium use.

Regards,
Arend

> I will detail what I've done. After killing the wpa_supplicant process
> I followed the steps:
> --- Created a virtual interface in the station mode ---
> root@hammerhead:/ # iw phy phy0 interface add vif_AP2 type station
> root@hammerhead:/ # ip link set dev vif_AP2 address 64:89:9a:81:0f:22
> root@hammerhead:/ # ip link set dev vif_AP2 up
>
> ---- Connection to AP1 - SUCCESS ----
> root@hammerhead:/data # wpa_supplicant -iwlan0 -c/data/tmp/preshared_key_AP1
> The dmesg log from [2] proved that the connection was successful.
>
> ---- Connection to AP2 - FAILED ----
> root@hammerhead:/ # wpa_supplicant -ivif_AP2 -c/data/tmp/preshared_key_AP2
> The dmesg log from [3] proved that the connection failed.
>
> It seems that the connection error is due to a failed PNO setup [3].
> Also, the failed PNO setup seems to prevent the AP scanning process
> from running. More accurate, what is this PNO setup? I looked into the
> Kernel code [4] but I can't figure it out how I could avoid this
> error.

PNO is preferred network offload in which firmware is configured with a 
number of ssids and it will notify host when it finds one of those.

wpa_supplicant will do a couple of regular scans after which it requests 
a scheduled_scan which the driver will use to configure PNO in firmware. 
Looking at the log in [3] I get the impression this multi-STA thing is 
not working at all. The regular scans don't find any AP, which is 
already suspect. The PNO setup is rejected by the driver, because the 
other interface is already connected to AP1.

Regards,
Arend

> [1] https://github.com/gdetal/mptcp_nexus5
> [2] https://drive.google.com/file/d/0B5SBH08PU_ChYzNIV3VxUWlqWGs/view?usp=sharing
> [3] https://drive.google.com/file/d/0B5SBH08PU_ChNHdOck5UbjNERjQ/view?usp=sharing
> [4] https://github.com/gdetal/mptcp_nexus5/blob/master/drivers/net/wireless/bcmdhd/dhd_pno.c
>
> Any help is greatly appreciated,
> Doru
>

