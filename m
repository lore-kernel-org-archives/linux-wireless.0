Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:52954 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXHEMce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 08:32:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.inf.tu-dresden.de (8.13.7/8.13.7) with ESMTP id l75Bp91X000586
	for <linux-wireless@vger.kernel.org>; Sun, 5 Aug 2007 13:51:09 +0200 (CEST)
Received: from mail.inf.tu-dresden.de ([127.0.0.1])
 by localhost (mail.inf.tu-dresden.de [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28944-06 for <linux-wireless@vger.kernel.org>;
 Sun,  5 Aug 2007 13:51:09 +0200 (CEST)
Received: from [192.168.55.10] (p54B36A0A.dip.t-dialin.net [84.179.106.10])
	(authenticated bits=0)
	by mail.inf.tu-dresden.de (8.13.7/8.13.7) with ESMTP id l75Bp4Nm000573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 5 Aug 2007 13:51:05 +0200 (CEST)
From: Joerg Hermsdorf <joerg.hermsdorf@inf.tu-dresden.de>
To: linux-wireless@vger.kernel.org
Subject: mac80211 and WPA
Date: Sun, 5 Aug 2007 13:50:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200708051350.57161.joerg.hermsdorf@inf.tu-dresden.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After some hours of struggling, I can successfully connect  the 'Intel =
PRO/=20
Wireless 3945ABG' device of my ThinkPad T60p, on Kernel 2.6.22.1 using =
the=20
iwlwifi driver, via an WPA encrypted connection to my access point.=20
The point is, I used 'wpa_supplicant' for this. My question is now, was=
n't the=20
mac80211 subsystem designed to get rid of things like wpa_supplicant?
Is there already an other way to configure the iwlwifi driver for WPA/W=
PA2,=20
without wpa_supplicant? If so, how? Using 'iwpriv'? I did not find any =
docs=20
or howtos for configuring iwlwifi drivers to use WPA.

--------------------------------
Here's how I did it for now:
I got the iwlwifi driver (version 0.1.8) from http://intellinuxwireless=
=2Eorg/=20
together with the microcode image (version iwlwifi-3945-ucode-2.14.1.5)=
=2E It=20
compiles without errors and loading the iwl3945 kernel module works fin=
e and=20
brings up the 'wlan0' interface. Well, only the wlan LED on my ThinkPad=
 does=20
not light!

I can use iwconfig to setup the device to connect to open and WEP encry=
pted=20
access points. To connect to WPA encrypted access points I had to addit=
onally=20
setup wpa_supplicant using the 'wext' driver (Linux wireless extensions=
=20
(generic)).

Now calling=20

# wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf

successfully connects to my WPA2 encrypted access point.
-----------------------------------------





Regards,
J=C3=B6rg
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
