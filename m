Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:35700 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbbHWPP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2015 11:15:59 -0400
Received: by labtq9 with SMTP id tq9so3556904lab.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2015 08:15:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 23 Aug 2015 18:15:58 +0300
Message-ID: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com> (sfid-20150823_171619_817045_69BAF548)
Subject: bcmdhd: Concurrent use of wlan0 and virtual interface in managed mode
From: Gucea Doru <gucea.doru@gmail.com>
To: eccopark@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, community

I'm a Master student doing my research on a subject related to Android
and multiple paths between two nodes. What I try to do now is to allow
a client to connect to multiple APs (Access Points).

I started with the simplest use-case where I have only two APs (AP1
and AP2) and an Android client  - a Nexus 5 device running the Kernel
from [1]. For the connection with AP1 I used the already present
interface wlan0. For the connection with AP2 I tried to use a newly
created virtual interface but the wpa_supplicant connection is not
successful. I'm not sure if this is a driver limitation or a driver
bug.

I will detail what I've done. After killing the wpa_supplicant process
I followed the steps:
--- Created a virtual interface in the station mode ---
root@hammerhead:/ # iw phy phy0 interface add vif_AP2 type station
root@hammerhead:/ # ip link set dev vif_AP2 address 64:89:9a:81:0f:22
root@hammerhead:/ # ip link set dev vif_AP2 up

---- Connection to AP1 - SUCCESS ----
root@hammerhead:/data # wpa_supplicant -iwlan0 -c/data/tmp/preshared_key_AP1
The dmesg log from [2] proved that the connection was successful.

---- Connection to AP2 - FAILED ----
root@hammerhead:/ # wpa_supplicant -ivif_AP2 -c/data/tmp/preshared_key_AP2
The dmesg log from [3] proved that the connection failed.

It seems that the connection error is due to a failed PNO setup [3].
Also, the failed PNO setup seems to prevent the AP scanning process
from running. More accurate, what is this PNO setup? I looked into the
Kernel code [4] but I can't figure it out how I could avoid this
error.

[1] https://github.com/gdetal/mptcp_nexus5
[2] https://drive.google.com/file/d/0B5SBH08PU_ChYzNIV3VxUWlqWGs/view?usp=sharing
[3] https://drive.google.com/file/d/0B5SBH08PU_ChNHdOck5UbjNERjQ/view?usp=sharing
[4] https://github.com/gdetal/mptcp_nexus5/blob/master/drivers/net/wireless/bcmdhd/dhd_pno.c

Any help is greatly appreciated,
Doru
