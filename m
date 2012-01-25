Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:57365 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2AYKyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 05:54:12 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rq0UR-0006Oh-Ax
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 11:54:07 +0100
Received: from localhost ([::1]:44629 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rq0UR-0003CY-6y
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 11:54:07 +0100
Received: from [195.4.92.18] (port=45449 helo=8.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rq0S0-0001RF-Vf
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 11:51:36 +0100
Received: from [2002:4fde:14a5:2:5054:ff:feb8:40bd] (port=47531 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rq0S0-0004QV-JA
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 11:51:36 +0100
Message-ID: <4F1FDEAE.2020009@01019freenet.de> (sfid-20120125_115416_208356_B9A2CA66)
Date: Wed, 25 Jan 2012 11:51:26 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k get's completely knocked out by rt3572 device
References: <4F1EF618.6080108@01019freenet.de> <13411135.eH6opTgxBo@helmutmobil.site> <4F1FBA09.3000003@01019freenet.de>
In-Reply-To: <4F1FBA09.3000003@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-15
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all!

As promised, I repeated the test before with another AP. The destination
host of netperf was the same. See below!


The test was done using netperf with the following two calls:

netperf -t TCP_MAERTS -H host -l 60
netperf -t TCP_STREAM -H host -l 60


The test was done with two different notebooks as STA:

notebook ath9k:
built-in ar9285 device, intel core i5 processor, linux 3.2.1 / 64 bit
kernel.

notebook rt3572:
WUSB600Nv2 WLAN USB stick (inserted horizontally into the USB port of
the back of the notebook), intel celeron M processor, linux 2.6.37.6 /
32 bit kernel, Ralink rt5572sta.


AP:
Linksys WAP610N, connected to the host (destination of netperf) with
fast ethernet.


The network parameters are:
2,4 GHz, 40 MHz, WPA2 EAP-TLS, CCMP



The following chart should be read like this:

- one measurement / line: the device operates alone
- two measurements / line: both devices run exactly (+/- few ms) at the
  same time
- one direction of the data stream / line: both devices operate at the
  same direction
- two directions of the data stream / line: each device operates at the
  direction next to it


			10^6bits/s	10^6bits/s
			ath9k		rt3572
			table		chair

TCP_STREAM STA -> AP	33.12		
TCP_STREAM STA -> AP			74.32

TCP_STREAM STA -> AP	12.64		50.83
TCP_STREAM STA -> AP	11.96		52.44
TCP_STREAM STA -> AP	15.33		53.46
TCP_STREAM STA -> AP	12.52		51.03
TCP_STREAM STA -> AP	11.67		53.80


TCP_MAERTS AP -> STA			51,52
TCP_MAERTS AP -> STA	36.48
TCP_MAERTS AP -> STA	10.73		33.85
TCP_MAERTS AP -> STA	 2.93		45.38
TCP_MAERTS AP -> STA	 8.67		36.53
TCP_MAERTS AP -> STA	13.35		29.98
TCP_MAERTS AP -> STA	11.13		33.10


TCP_MAERTS AP -> STA	21.16		30.38	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	22.86		26.76	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	23.64		25.37	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	22.45		27.95	TCP_STREAM STA -> AP


TCP_STREAM AP -> STA	 3.99		42.20	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	13.24		28.40	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	12.80		28.46	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	12.78		28.63	TCP_MAERTS STA -> AP


----------------------------------------------------------------------

The position of the notebooks was changed:

			ath9k		rt3572
			chair		table

TCP_STREAM STA -> AP	49.00		
TCP_STREAM STA -> AP			76,32

TCP_STREAM STA -> AP	15.97		55.96
TCP_STREAM STA -> AP	18.96		49.79
TCP_STREAM STA -> AP	14.52		57.33
TCP_STREAM STA -> AP	20.04		51.52
TCP_STREAM STA -> AP	15.57		56.06


TCP_MAERTS AP -> STA			54.25
TCP_MAERTS AP -> STA	40.13

TCP_MAERTS AP -> STA	14.14		34.51
TCP_MAERTS AP -> STA	 9.72		40.47
TCP_MAERTS AP -> STA	 9.00		40.54
TCP_MAERTS AP -> STA	13.99		35.35


TCP_MAERTS AP -> STA	21.98		47.26	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	16.07		53.88	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	17.32		49.53	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	17.08		56.57	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	21.63		50.91	TCP_STREAM STA -> AP


TCP_STREAM AP -> STA	 1.58		49.03	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 5.36		46.49	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 8.71		40.88	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 4.72		45.95	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	12,29		39.31	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 4.68		46.43	TCP_MAERTS STA -> AP



Regards,
Andreas
