Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:39605 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab1FDM4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 08:56:54 -0400
Received: from [195.4.92.11] (helo=1.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #2)
	id 1QSqPM-0005HI-CX
	for linux-wireless@vger.kernel.org; Sat, 04 Jun 2011 14:56:52 +0200
Received: from p54a193b8.dip0.t-ipconnect.de ([84.161.147.184]:54185 helo=mail.maya.org)
	by 1.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #5)
	id 1QSqPM-0006RS-2C
	for linux-wireless@vger.kernel.org; Sat, 04 Jun 2011 14:56:52 +0200
Message-ID: <4DEA2BA6.1080309@01019freenet.de> (sfid-20110604_145659_725682_E1D2B211)
Date: Sat, 04 Jun 2011 14:57:10 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: broken PTK rekeying under high network load
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!


Problem: PTK (and sometimes GTK-rekeying) is broken under high network
load. The high network load is produced with netperf:

while true ;
do
  netperf -t TCP_STREAM -H host
  netperf -t TCP_MAERTS -H host
  netperf -t TCP_SNDFILE -H host
done

During rekeying, mostly of PTK, the 4 way handshake is broken, because
hostapd doesn't get the last answer from supplicant. Supplicant itself
thinks, all would be fine - PTK rekeying would be ready.


Goal:
Near down the component, which is responsible for the broken PTK rekeying.
The following tests all where done with a WPA2 / PSK / ieee80211n / 40
MHz bandwith, 2,4 GHz based connection and a PTK rekeying delta of 50 s
configured on hostapd.
hwcrypt was switched off in hardware for hostapd.

I did the tests with different components. The result can be found in
the table below.



Components:

Hardware for accesspoint:

A1) Linksys WMP600N (rt2800pci)

or

A2) Atheros ar9285 (ath9k)


Hardware for Supplicant:

H1) WUSB600Nv2

H2) Atheros ar9285


Drivers for Supplicant

D1) wpa_supplicant with wext

D2) wpa_supplicant with nl80211

D3) rt3572sta without wpa_supplicant




1. test

accesspoint	Hardware for 	Driver for
		supplicant	supplicant	Rekeying
--------------------------------------------------------
A1		H1		D1		broken
A1		H1		D3		fine
A1		H2		D1		broken
A1		H2		D2		broken

A2		H1		D1		broken
A2		H1		D3		fine


fine means: Rekeying never broke during > 1,5 h.
broken means: Rekeying was broken after the first or no later then fifth
incidence.


Summary:

Rekeying is fine as long as no wpa_supplicant / wext / or nl80211
framework is used on the supplicant.
The rt3572sta-driver without wpa_supplicant works just fine - as expected.

The problem could be in the wireless framework or in wpa_supplicant -
that's what I cannot say.


But I could see one big difference between the handling of the rekying
by wpa_supplicant and rt3572sta-driver:
the rt3572sta-driver stops the datastream during rekeying. This is about
half a second.
With wpa_supplicant, I can't see this stop. It stops after the rekeying
has been broken because of deauthentication.
The following reauthentication takes much longer and sometimes doesn't
work at all.


Could somebody please look at this problem? If you have some more
questions - please ask - I'll try to answer them.


Andreas
