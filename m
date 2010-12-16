Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.mezon.ru ([88.212.197.163]:46849 "EHLO mail.mezon.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0LPORL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:17:11 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.mezon.ru (Postfix) with ESMTP id 0F8F94B8133
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:10:01 +0300 (MSK)
Received: from gate-suntel.mezon.ru (gate-unisnet.mezon.ru [94.230.162.90])
	by mail.mezon.ru (Postfix) with ESMTP id DF4F38C8A17
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:10:00 +0300 (MSK)
Received: from [192.168.0.206] (fdkit.mezon.local [192.168.0.206])
	by gate-suntel.mezon.ru (Postfix) with ESMTP id C9D64D7021D
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:10:00 +0300 (MSK)
Message-ID: <4D0A1DB8.7080108@mezon.ru>
Date: Thu, 16 Dec 2010 17:10:00 +0300
From: Alexander Khryukin <alexander@mezon.ru>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: wimaxd daemon bug
References: <370262.79515.qm@web56806.mail.re3.yahoo.com>
In-Reply-To: <370262.79515.qm@web56806.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day.
I have
1.MeeGo 1.1
2.Intel Corporation WiMAX/WiFi Link 6050 Series (rev 2c)
3.Wimax network that named 'Yota'


wimaxcu scan wide
WARNING: Wide scan may take upto 2 minutes...
NSP : Yota
    ID          : 21
    Signal      : Excellent
    RSSI        : -62 dBm
    CINR        : 29 dB
    Network Type: Home Network
    Activated.



Then i try to connect with Yota-network

wimaxcu connect network 21
Connecting to Yota Network...
Connection successful

[root@meego-desktop ~]# /usr/bin/wimaxd -d -i wmx0
Enter Command:
q - Quit AppSrv
t - Trace ReInit (ReLoads Registry Values)
u - uplink(Apdo uplink event
h - Help
d - Toggle driver messages to display - debug & internal only


AppSrv is ready !
Act_FullRestart!
Act_DriverDeviceStatus - DRIVER_UP
CTRL-EVENT-EAP-STARTED EAP authentication started
Sending EapResponse. Data size: 25
CTRL-EVENT-EAP-PROPOSED-METHOD vendor=0 method=13
CTRL-EVENT-EAP-METHOD EAP vendor 0 method 13 (TLS) selected
Sending EapResponse. Data size: 60
Sending EapResponse. Data size: 60
Sending EapResponse. Data size: 6
Sending EapResponse. Data size: 6
Sending EapResponse. Data size: 1310
Sending EapResponse. Data size: 1144
Sending EapResponse. Data size: 6
CTRL-EVENT-EAP-SUCCESS EAP authentication completed successfully
CTRL-EVENT-EAP-STARTED EAP authentication started
Sending EapResponse. Data size: 17
CTRL-EVENT-EAP-PROPOSED-METHOD vendor=0 method=13
CTRL-EVENT-EAP-METHOD EAP vendor 0 method 13 (TLS) selected
Sending EapResponse. Data size: 60
Sending EapResponse. Data size: 6
Sending EapResponse. Data size: 6
Sending EapResponse. Data size: 1310
Sending EapResponse. Data size: 1144
Sending EapResponse. Data size: 6


Then i try to reconnect

[root@meego-desktop ~]# wimaxcu connect network 21
Current Preferred Profile is:
    ID  : 21
    Name: Yota
Connecting to Yota Network...
Connection failure


Next i try to

wimaxll -i wmx0 reset
and start daemon again

/usr/bin/wimaxd -d -i wmx0

Connect to network

imaxcu connect network 21
Current Preferred Profile is:
    ID  : 21
    Name: Yota
Connecting to Yota Network...
Connection successful


Wimaxd version wimax-1.5.1-35.13.i586.rpm    
from Inaky Perez-Gonzalez repo.
http://download.meego.com/live/home:/inaky:/pegatron-idf-2010/Trunk/i586/


uname -a
Linux meego-desktop 2.6.36-1.9_mezon.12.1-netbook #1 SMP PREEMPT Wed Dec
15 20:01:48 MSK 2010 i686 i686 i386 GNU/Linux



steps to reproduce:
1.Plug on Intel Corporation WiMAX/WiFi Link 6050 Series (rev 2c)
2.Install any version on wimaxd
3.wimaxcu connect any_network_id
4.wait about 2 minutes
5.connection dropped.
6.try connect again, and see "connection failure"
7.wimaxll -i wmx0 rese
8.connect to network again (it will be succeeded)
9.Proceed to step 4

