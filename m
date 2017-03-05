Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:32781 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdCEHjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Mar 2017 02:39:15 -0500
Received: by mail-ua0-f175.google.com with SMTP id u30so10283414uau.0
        for <linux-wireless@vger.kernel.org>; Sat, 04 Mar 2017 23:39:14 -0800 (PST)
MIME-Version: 1.0
From: ravin goyal <ravirocks1021@gmail.com>
Date: Sun, 5 Mar 2017 13:08:53 +0530
Message-ID: <CANU0Mn1D8pccK6QgZe1TuayFNbYHEXCJYJXZH8Z1dX6N6qhK1g@mail.gmail.com> (sfid-20170305_084501_198968_B3B8D60D)
Subject: Hostapd driver issues in orange pi Zero
To: Jouni Malinen <j@w1.fi>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        wpa_supplicant <hostap@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am running hostapd 2.5 on orange pi zero running debian jessie and
my wireless driver is xradio_wlan.

First it was running fine when I was testing without bridge settings
in hostapd.conf.

But when I set bridge=br0 in  hostapd.conf and restart the process, as
the number of STA's are getting connected to the hostapd access point.

I noticed driver error allover in syslog and dmesg, I am sharing few
logs from dmesg as below:

[Sun Mar  5 07:46:46 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 07:46:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:47:48 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:48:16 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 07:49:56 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:51:14 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 07:51:57 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:52:07 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:52:14 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:52:18 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 07:53:30 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:56:09 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 07:59:00 2017] [BH_WRN] miss interrupt!
[Sun Mar  5 08:00:00 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 08:00:38 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:01:16 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:01:48 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 08:02:21 2017] [STA_WRN] Inactivity Event Recieved for link_id 1
[Sun Mar  5 08:02:21 2017] [STA_WRN]  Inactivity Deauth Frame sent for
MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
[Sun Mar  5 08:02:31 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 08:03:09 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:03:56 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:04:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:04:54 2017] [STA_WRN] Inactivity Event Recieved for link_id 3
[Sun Mar  5 08:04:54 2017] [STA_WRN]  Inactivity Deauth Frame sent for
MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
[Sun Mar  5 08:04:59 2017] [AP_WRN] Multicast delivery timeout.
[Sun Mar  5 08:05:44 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:06:50 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:07:11 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:07:26 2017] [BH_WRN] miss interrupt!
[Sun Mar  5 08:08:02 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:08:16 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:08:48 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:10:04 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:10:26 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:11:22 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:12:31 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:17:18 2017] [BH_WRN] miss interrupt!
[Sun Mar  5 08:18:52 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:21:28 2017] [STA_WRN] Inactivity Event Recieved for link_id 4
[Sun Mar  5 08:21:28 2017] [STA_WRN]  Inactivity Deauth Frame sent for
MAC SA 88:79:7e:13:5e:ce      and DA dc:44:6d:6b:43:18
[Sun Mar  5 08:22:30 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:23:22 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:24:00 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:24:14 2017] [WSM_ERR] wsm_flush_tx:No pengding, but
hw_bufs_used=1
[Sun Mar  5 08:24:23 2017] [BH_WRN] miss interrupt!

Internet is working fine on the connected devices but these errors are
keep coming in syslog which are hard to ignore.
Any idea about this ?

Moreover One more thing I noticed is that I can connect atmost 9-10
clients( I get to know this by running hostapd_cli all_sta) afterwards
it just keeps showing status connecting... when a new clients try to
connect until unless one or more clients that are already connected
gets disconnected.
I even has set max_num_sta=255 but no help ?

Regards
Ravin
