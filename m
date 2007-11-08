Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.post.naumen.ru ([77.222.34.75]:51309 "EHLO
	relay.post.naumen.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbXKHTTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 14:19:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by relay.post.naumen.ru (Postfix) with ESMTP id 467CBA31B3
	for <linux-wireless@vger.kernel.org>; Thu,  8 Nov 2007 21:46:34 +0300 (MSK)
Received: from relay.post.naumen.ru ([127.0.0.1])
	by localhost (post.naumen.ru [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCAbXsoxO0hJ for <linux-wireless@vger.kernel.org>;
	Thu,  8 Nov 2007 21:46:27 +0300 (MSK)
Received: from smtp.post.naumen.ru (smtp.post.naumen.ru [77.222.34.74])
	by relay.post.naumen.ru (Postfix) with ESMTP id 68AF5A31B2
	for <linux-wireless@vger.kernel.org>; Thu,  8 Nov 2007 21:46:27 +0300 (MSK)
Received: from [192.168.225.193] (unknown [195.151.207.66])
	by smtp.post.naumen.ru (Postfix) with ESMTP id 46C8657837
	for <linux-wireless@vger.kernel.org>; Thu,  8 Nov 2007 21:46:27 +0300 (MSK)
Message-ID: <47335980.4070103@naumen.ru> (sfid-20071108_191935_692038_02B0E548)
Date: Thu, 08 Nov 2007 23:46:24 +0500
From: =?windows-1251?Q?=C2=E5=F2=EE=F8=EA=E8=ED_=CD=E8=EA=E8=F2=E0?=
	<nvetoshkin@naumen.ru>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 and SIOCSIWAUTH
Content-Type: text/plain; charset=windows-1251; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I'm a user of Lenovo R61 laptop with Intel 3945 wireless card. I 
have Gentoo and would like to use the iwlwifi + wpa_supplicant driver, 
but I can't because Wi-Fi installed in our office needs WPA2 
authentication and I can't connect to it. There no problems using ipw3945d.
#wpa_supplicant config
ap_scan=2
network={
         ssid="point1"
         key_mgmt=WPA-EAP
         scan_ssid=1
         identity="nvetoshkin"
         proto=WPA2
         eap=TLS
         ca_cert="/home/nekto/certificate.pem"
         private_key="/home/nekto/nvetoshkin.p12"
         private_key_passwd="nvetoshkin"
}
ioctl[SIOCSIWAUTH]: Operation not supported - this error always appears 
in wpa_supplicant output. I digged a bit in source code and found out 
that it is mac80211 subsystem who returns ENOTSUP.
Is it really the cause of my problems or am I just confused?

-=-=-=-
Vetoshkin Nikita
