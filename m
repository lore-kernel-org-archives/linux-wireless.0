Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:48791 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1FYMek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 08:34:40 -0400
Received: from [195.4.92.18] (helo=8.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QaS4M-0001bw-0L
	for linux-wireless@vger.kernel.org; Sat, 25 Jun 2011 14:34:38 +0200
Received: from p54a19652.dip0.t-ipconnect.de ([84.161.150.82]:59146 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #5)
	id 1QaS4L-0003Qu-J8
	for linux-wireless@vger.kernel.org; Sat, 25 Jun 2011 14:34:37 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p5PCYXL3003889
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2011 14:34:34 +0200
Message-ID: <4E05D60B.5020007@dualc.maya.org> (sfid-20110625_143448_555968_F6C9DA42)
Date: Sat, 25 Jun 2011 14:35:23 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AP: mon.wlan0 vs wlan0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I traced mon.wlan0 and wlan0 on an accesspoint, because I wanted to see,
which data is sent through which device (WPA2 TLS).

That's what I saw:


				mon.wlan0		wlan0
---------------------------------------------------------------------------------
initial authentication

probe request			x
probe response			x (2 times)
authentication requ		x
authentication resp		x (2 times)
association request		x
association response		x (2 times)

request identity		x (2 times)
response identity					x
request eaptls			x (2 times)

Server Hello			x
Client Hello						x
IEEE 802.11			x

request eap-tls			x (2 times)
response eap-tls					x (2 times)
Change Cipher Spec		x (2 times)
Certificate Client					x
EAP Success			x (2 times)
Response eap-tls					x
EAPOL Key msg 1/4		x (2 times)
EAPOL Key msg 2/4					x
EAPOL Key msg 3/4		x (2 times)
EAPOL Key msg 4/4					x
IEEE 802.11 action success	x


GTK - rekeying

QoS Data			2 times (WEP and CCMP)
EAPOL Key msg 2/2					x


Reauthentication

QoS (request identity?)		x
response identity					x
QoS (server hello?)		x
client hello						x
QoS (Change Cipher Spec?)	x
QoS (EAPOL Key msg 1/4?)	x
EAPOL Key msg 2/4					x
QoS (EAPOL Key msg 3/4?)	x
EAPOL Key msg 4/4					x
QoS (IEEE 802.11 success)	x


I'm surprised, that not all of the management packages went through the
mon-device.
At the beginning (initial connection), all data went through the
mon-device. After the association, all management data from the client
(supplicant) goes through the normal wlan0 device - I would have
expected, that all management and authorization data went through the
mon device.

Could anybody please shed some light on this?


Thank you,
Andreas
