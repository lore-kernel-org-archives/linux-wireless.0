Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56740 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3GIJkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 05:40:22 -0400
Message-ID: <1373362817.21065.191.camel@cumari.coelho.fi> (sfid-20130709_114025_519183_4A697FE0)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
From: Luciano Coelho <coelho@ti.com>
To: =?ISO-8859-1?Q?Jos=E9?= Miguel =?ISO-8859-1?Q?Gon=E7alves?=
	<jose.goncalves@inov.pt>
CC: Arik Nemtsov <arik@wizery.com>, <linux-wireless@vger.kernel.org>
Date: Tue, 9 Jul 2013 12:40:17 +0300
In-Reply-To: <51DBD904.6020007@inov.pt>
References: <51DB0ACC.7050800@inov.pt>
	  <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
	  <51DB4195.8090103@inov.pt>
	  <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
	 <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-09 at 10:33 +0100, José Miguel Gonçalves wrote:
> On 09-07-2013 10:09, Luciano Coelho wrote:
> >>> wlcore: Beacon loss detected. roles:0xff
> >> This one is possibly a FW version issue. I'd give it a go with the
> >> latest FW in TI's git:
> >> https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware
> > More specifically, try the hw/firmware/wl127x-fw-4-sr.bin and the
> > hw/firmware/wl127x-fw-4-mr.bin (if you're using multirole).  Note that
> > you need to rename them to wl127x-fw-5-sr.bin and wl127x-fw-5-mr.bin,
> > respectively.
> >
> > What we have in the linux-firmware git at the moment are versions
> > 6.3.10.0.133 (singlerole) and 6.5.7.0.42 (multirole).  The new ones in
> > TI's github repo are 6.3.10.0.136 and 6.5.7.0.46.
> >
> > If the new firmwares solve your problem, please let me know and I'll
> > push them to the linux-firmware git repo.
> 
> Just to clarify. I was using the latest firmware files from 
> linux-firmware and the driver picks the file wl127x-fw-5-sr.bin which is 
> Rev 6.3.10.0.133. So are you saying that I should install the 
> wl127x-fw-4-sr.bin from TI's github repo named as wl127x-fw-5-sr.bin and 
> give it a try?

Exactly.  The name used with TI's forked kernel hasn't update the
version number to 5, so you need to rename it manually.  When the
firmware boots, you should see Rev. 6.3.10.0.136 printed out.

You may also want to update the mr version, if you'll use P2P, or other
multirole scenarios.

--
Cheers,
Luca.

