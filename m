Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58184 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0Wn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 18:43:58 -0400
Received: by mail-lb0-f180.google.com with SMTP id z12so3170301lbi.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2014 15:43:57 -0700 (PDT)
Message-ID: <544ECAAA.5090204@gmail.com> (sfid-20141027_234401_924116_CECE0A1F)
Date: Mon, 27 Oct 2014 23:43:54 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: systemd Mailing List <systemd-devel@lists.freedesktop.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Network Manager <networkmanager-list@gnome.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Kernel module(r8712u) reload  - suspend/resume - systemd
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


It is tested and works, 

# systemctl suspend

[  144.218876] PM: Entering mem sleep
[  144.219249] r8712u 2-3:1.0 wlp0s4f1u3: Suspending...
[  144.219255] r8712u 2-3:1.0 wlp0s4f1u3: Unable to suspend

            & RESUME

[  146.844240] r8712u 2-3:1.0 wlp0s4f1u3: Resuming...
[  146.844241] r8712u 2-3:1.0 wlp0s4f1u3: Unable to resume
[  147.015962] PM: Finishing wakeup.
[  154.029573] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  177.489082] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  200.499708] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  233.514654] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  276.498402] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  329.498037] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  392.507363] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  455.559545] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  518.540179] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1
[  581.533404] r8712u 2-3:1.0 wlp0s4f1u3: In r8711_wx_set_scan: bDriverStopped=1

~~~~~~~~~~~~~~

# nmcli device 
DEVICE      TYPE      STATE         CONNECTION 
wlp0s4f1u3  wifi      disconnected  --         

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/etc/systemd/system/r8712u-reload.service
[Unit]
Description=Reload rtl871x wireless lan driver after system resume
After=hibernate.target suspend.target hybrid-sleep.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/modprobe -r r8712u
ExecStart=/usr/sbin/modprobe r8712u

[Install]
WantedBy=hibernate.target suspend.target hybrid-sleep.target

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# systemctl enable r8712u-reload.service

~~~~~~~~~~~~~~~~~~~

# systemctl suspend

[  616.251430] PM: Entering mem sleep
[  616.251962] r8712u 2-3:1.0 wlp0s4f1u3: Suspending...
[  616.251965] r8712u 2-3:1.0 wlp0s4f1u3: Unable to suspend

            & RESUME

[  619.008122] r8712u 2-3:1.0 wlp0s4f1u3: Resuming...
[  619.008124] r8712u 2-3:1.0 wlp0s4f1u3: Unable to resume
[  619.195001] PM: Finishing wakeup.
[  620.073126] usb 2-3: reset high-speed USB device number 3 using ehci-pci
[  620.209187] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
[  620.209785] r8712u: Staging version
[  620.209802] r8712u: register rtl8712_netdev_ops to netdev_ops
[  620.209807] usb 2-3: r8712u: USB_SPEED_HIGH with 4 endpoints
[  620.210253] usb 2-3: r8712u: Boot from EFUSE: Autoload OK
[  620.583476] usb 2-3: r8712u: CustomerID = 0x0000
[  620.583489] usb 2-3: r8712u: MAC Address from efuse = 00:01:02:03:04:05
[  620.583498] usb 2-3: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
[  620.584238] usbcore: registered new interface driver r8712u
[  620.589721] r8712u 2-3:1.0 wlp0s4f1u3: renamed from wlan0
[  627.183840] r8712u 2-3:1.0 wlp0s4f1u3: 1 RCR=0x153f00e
[  627.184345] r8712u 2-3:1.0 wlp0s4f1u3: 2 RCR=0x553f00e
[  627.288231] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[  627.592219] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[  627.896222] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[  628.201217] IPv6: ADDRCONF(NETDEV_UP): wlp0s4f1u3: link is not ready
[  648.740663] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s4f1u3: link becomes ready

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# nmcli device 
DEVICE      TYPE      STATE         CONNECTION 
wlp0s4f1u3  wifi      connected     AP 


but is there a better way to do it?


poma
