Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45126 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2LSTcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 14:32:39 -0500
Message-ID: <1355945507.5373.2.camel@cumari.coelho.fi> (sfid-20121219_203243_313306_69363A0D)
Subject: Re: wl12xx (ol_R5.SP3.05) drivers + firmware (ol_R5.SP3.05) doesn't
 work on WL1271 (HW PG 2.0)
From: Luciano Coelho <coelho@ti.com>
To: "Zigman, Eran" <eranz@ti.com>, Girish Bn <Girish.BN@lnties.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Dec 2012 21:31:47 +0200
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D1CB484@POCITMSEXMB02.LntUniverse.com>
References: <45566970CF58C74CB52107862E0541CD1D1CB484@POCITMSEXMB02.LntUniverse.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eran,

Can you please check Girish's email below and help him with this?

Thanks!

--
Luca.

On Wed, 2012-12-19 at 14:41 +0000, Girish Bn wrote:
> Hi,
> 
> We are client is using the Jorjin WG7310-00 WLAN/BT/FM Module for one of the WLAN server module.
> We are porting the Linux open source drivers to WL1271 based Jorjin module. Our kernel version is 2.6.28.2 and processor is LPC3130. The PG ver of Wl1271 is 2.
> Recently we have back ported the wl12xx drivers from the TI-OpenLink site
> We have taken the wl12xx drivers from https://github.com/TI-OpenLink/wl12xx and branch r5_jb and tag ol_R5.SP3.05
> Also we had taken the firmware from https://github.com/TI-OpenLink/ti-utils and branch r5_jb and tag ol_R5.SP3.05
> The supplicant also was taken from https://github.com/TI-OpenLink/hostap and branch r5_jb and tag ol_R5.SP3.05
> 
> We using the multi-role feature of the driver.
> We had specifically taken above package as we wanted the AP channel switch functionality. This feature handles a particular case like if you started the STA on Channel X and also you will start AP (P2P Group Owner) on the same channel (Channel X). Now if you change the channel of Station to Channel(Y), the driver automatically will take care of restarting the AP(P2P GO) on the same channel(Channel Y).
> 
> We are facing issue with this package and the drivers won't work properly for us.
> The major issues seen with this package are
> 1. We able to do the scan and connect to an encrypted network.  But when we run DHCP client on wlan0 to get the IP address from the Access Point, the driver throws "wl12xx: Beacon loss detected" message and the connection breaks and the driver gets into SCAN mode and will try to reconnect to the Access Point. Eventually we don't receive the IP address from the Access Point.
> 2. I was able to start the Station and AP role on the same channel. But the after stating the AP role, station role will be disconnected automatically and I won't be able to do scan and connection on STA.
> 3. Also cannot connect to my System which is acting as P2P Group Owner(AP) from any other Wi-Fi device like iPhone/Laptop or any other. The issue is seen when System is set to P2P GO either using Single Role firmware only or using Multi-role firmware.
> 
> We suspect the issue with the above versions of (ol_R5.SP3.05) wl127x firmware and surprisingly all the above three issues are NOT seen when I use the below firmware versions (which is quite old)
> Single Role (SR):  Rev 6.3.7.0.105
> Multi-Role(MR): Rev 6.5.5.0.21
> 
> 
> The firmware versions taken from https://github.com/TI-OpenLink/ti-utils and branch r5_jb and tag ol_R5.SP3.05 are
> Single Role (SR):  Rev 6.3.10.0.132
> Multi-Role (MR): Rev 6.5.7.0.42
> 
> Can you let us know whether Wl1271 hw PG Ver 2.0 can run the ol_R5.SP3.05 firmware successfully or any hardware limitations with Wl1271?
> Any suggestions on the above issues will be greatly helpful
> 
> 
> Thanks & Regards,
> Girish
> L&T IES,
> KIADB Industrial Area,
> Hebbal-Hootagalli, Mysore - 570 018
> Telephone :  DID+91-821-2405552
> Mobile: +91-9741206402
> E-mail ID :Girish.BN@lnties.com
> www.lnties.com
> 
> This mail is classified as :
> (  ) L&T IES Proprietary
> (  ) L&T IES Confidential
> (X) L&T IES Internal Use
> ( ) L&T IES General Business
> 
> Larsen & Toubro Limited
> 
> www.larsentoubro.com
> 
> This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

