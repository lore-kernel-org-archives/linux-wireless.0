Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:53949 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab2AYISP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 03:18:15 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rpy3X-0004zA-CG
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 09:18:11 +0100
Received: from localhost ([::1]:44311 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rpy3S-0008Vn-OK
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 09:18:11 +0100
Received: from [195.4.92.15] (port=55853 helo=5.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rpy0j-00073f-Sc
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 09:15:17 +0100
Received: from [2002:4fde:14a5:2:5054:ff:feb8:40bd] (port=48401 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rpy0j-000776-Ec
	for linux-wireless@vger.kernel.org; Wed, 25 Jan 2012 09:15:17 +0100
Message-ID: <4F1FBA09.3000003@01019freenet.de> (sfid-20120125_091824_231554_79681FDF)
Date: Wed, 25 Jan 2012 09:15:05 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k get's completely knocked out by rt3572 device
References: <4F1EF618.6080108@01019freenet.de> <13411135.eH6opTgxBo@helmutmobil.site>
In-Reply-To: <13411135.eH6opTgxBo@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

I repeated the test with some more systematic to get a chance to get a
deeper view on what is going on.

The test was done using netperf with the following two calls:

netperf -t TCP_MAERTS -H host -l 60
netperf -t TCP_STREAM -H host -l 60


The test is done with two different notebooks as STA:

notebook ath9k:
built-in ar9285 device, intel core i5 processor, linux 3.2.1 / 64 bit
kernel.

notebook rt3572:
WUSB600Nv2 WLAN USB stick (inserted horizontally into the USB port of
the back of the notebook), intel celeron M processor, linux 2.6.37.6 /
32 bit kernel, Ralink rt5572sta.


AP:
rt2860 based pci device (Linksys WMP600N) with compat-wireless-3.3-rc1-2
with all recent patches incl. "mac80211: revert: retry sending failed
BAR frames later instead of tearing down aggr" with linux 3.1.4 / 64 bit
smp.



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
			desk		chair

TCP_STREAM STA -> AP	57.10		
TCP_STREAM STA -> AP			55.22

TCP_STREAM STA -> AP	 2.52		49.97
TCP_STREAM STA -> AP	 2.84		49.94
TCP_STREAM STA -> AP	 3.82		47.09
TCP_STREAM STA -> AP	 4.27		47.57
TCP_STREAM STA -> AP	 2.28		48.89


TCP_MAERTS AP -> STA			65.39
TCP_MAERTS AP -> STA	91.65

TCP_MAERTS AP -> STA	14.06		51.07
TCP_MAERTS AP -> STA	 6.55		59.78
TCP_MAERTS AP -> STA	18.87		49.62
TCP_MAERTS AP -> STA	10.73		56.63

TCP_MAERTS AP -> STA	30.28		35.33	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	31.65		32.83	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	32.05		34.23	TCP_STREAM STA -> AP

TCP_STREAM AP -> STA	 0.12		66.23	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 0.10		69.89	TCP_MAERTS STA -> AP

----------------------------------------------------------------------

The position of the notebooks was changed:

			ath9k		rt3572
			chair		desk

TCP_STREAM STA -> AP	29.27		
TCP_STREAM STA -> AP			55.79

TCP_STREAM STA -> AP	interrupted	56.32
			system call
TCP_STREAM STA -> AP	interrupted	55.65
			system call

TCP_MAERTS AP -> STA			80.73
TCP_MAERTS AP -> STA	79.15
TCP_MAERTS AP -> STA	17.13		62.02
TCP_MAERTS AP -> STA	15.14		63.92
TCP_MAERTS AP -> STA	12.53		66.41
TCP_MAERTS AP -> STA	11.95		66.17

TCP_MAERTS AP -> STA	 8.44		50.19	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	 9.31		49.67	TCP_STREAM STA -> AP
TCP_MAERTS AP -> STA	11.24		46.72	TCP_STREAM STA -> AP

TCP_STREAM AP -> STA	 0.96		74.82	TCP_MAERTS STA -> AP
TCP_STREAM AP -> STA	 0.01		80.22	TCP_MAERTS STA -> AP



I'll try to repeat the complete test with another AP.


Regards,
Andreas
