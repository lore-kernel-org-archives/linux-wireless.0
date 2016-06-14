Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp7.emailarray.com ([65.39.216.66]:22888 "EHLO
	smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbcFNSnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 14:43:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 14 Jun 2016 20:36:37 +0200
From: Esben Stien <b0ef@esben-stien.name>
To: linux-wireless@vger.kernel.org
Subject: Failed to set mode: Blocked through rfkill (0x12)
Message-ID: <9acc4dbc18e8738dd2766b7b1531b802@esben-stien.name> (sfid-20160614_204329_149509_58016AE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get bluetooth working and it sometimes does and sometimes 
not;)

I've got two chips:

BCM4360 (on motherboard, which never works)
BCM20702A0 (Targus BT USB Adapter, which works mostly)

I'm only interested in the BCM20702A0, right now.

When I do sudo systemctl status bluetooth.service, I get:
● bluetooth.service - Bluetooth service
    Loaded: loaded (/lib/systemd/system/bluetooth.service; enabled; 
vendor preset: enabled)
    Active: active (running) since ti. 2016-06-14 15:10:14 CEST; 4h 50min 
ago
      Docs: man:bluetoothd(8)
  Main PID: 1036 (bluetoothd)
    Status: "Running"
    CGroup: /system.slice/bluetooth.service
            └─1036 /usr/lib/bluetooth/bluetoothd

juni 14 19:38:58 quasar bluetoothd[1036]: Failed to set mode: Blocked 
through rfkill (0x12)
juni 14 19:39:10 quasar bluetoothd[1036]: Failed to set mode: Blocked 
through rfkill (0x12)
juni 14 19:39:22 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:39:59 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:40:09 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:40:32 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:40:52 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:44:20 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:45:56 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)
juni 14 19:46:17 quasar bluetoothd[1036]: Failed to set mode: Failed 
(0x03)

, but if I check rfkill list, it's not blocked:
0: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
2: hci1: Bluetooth
	Soft blocked: no
	Hard blocked: no

Any pointers to what may cause this? Where does these messages come 
from? I'm sure it works again if
I reboot, but I need to get to the bottom of this;)
