Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab3IKQK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 12:10:28 -0400
Message-ID: <1378916091.1693.21.camel@dcbw.foobar.com> (sfid-20130911_181351_047366_5CD2FFB1)
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Dan Williams <dcbw@redhat.com>
To: Vincent Thiele <vincentthiele@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Date: Wed, 11 Sep 2013 11:14:51 -0500
In-Reply-To: <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com>
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
	 <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com>
	 <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some relevant bits:

Sep 11 16:49:38 Arbeits-PC NetworkManager[1104]: <info> (wlan0): supplicant interface state: 4-way handshake -> completed
Sep 11 16:49:44 Arbeits-PC kernel: [ 1749.454788] wlan0: Connection to AP a0:f3:c1:05:80:ec lost
Sep 11 16:49:45 Arbeits-PC wpa_supplicant[1205]: wlan0: CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0): supplicant interface state: completed -> disconnected
Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Sep 11 16:49:45 Arbeits-PC wpa_supplicant[1205]: wlan0: SME: Trying to authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.282343] wlan0: authenticate with a0:f3:c1:05:80:ec
Sep 11 16:49:45 Arbeits-PC NetworkManager[1104]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.306287] wlan0: send auth to a0:f3:c1:05:80:ec (try 1/3)
Sep 11 16:49:45 Arbeits-PC kernel: [ 1750.410098] wlan0: send auth to a0:f3:c1:05:80:ec (try 2/3)
Sep 11 16:49:46 Arbeits-PC kernel: [ 1750.514232] wlan0: send auth to a0:f3:c1:05:80:ec (try 3/3)
Sep 11 16:49:46 Arbeits-PC kernel: [ 1750.618374] wlan0: authentication with a0:f3:c1:05:80:ec timed out

So the AP is disconnecting the device a couple seconds with reason 4,
which is "Disassociated due to inactivity".  My thought is that this
points to a driver bug (Larry?).

Dan

