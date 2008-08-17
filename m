Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:57994 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYHQKZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 06:25:04 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>
Cc: <rt2400-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 12:25:09 +0200
Message-ID: <059301c90053$86f182f0$0b3ca8c0@gotws1589> (sfid-20080817_122509_943936_1843F7AD)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200808171158.25501.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sunday 17 August 2008, Lars Ericsson wrote:
> > > > 
> > > > Have tried using the wpa_supplicant and got the -EBUSY from
> > > > ieee80211_ioctl_siwmode().
> > > 
> > > As usual: The interface must be down when changing working mode.
> > > 
> > 
> > The initial mode is 2. I do not know the source of that 
> mode, might be a
> > default.
> > <7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, 
> sdata->vif.type=2 
> 
> that is managed mode.
> 
> > Between 85.713698 and 85.821832 device is opened 
> (1=netif_running(dev))
> > <7>[   85.713698] LaE: ieee80211_ioctl_siwmode: 0=netif_running(dev)
> > <7>[   85.713752] LaE: ieee80211_ioctl_siwmode: mode=2 
> > <7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, 
> sdata->vif.type=2 
> > <6>[   85.713938] phy0 -> rt2x00lib_request_firmware: Info - Loading
> > firmware file 'rt2561s.bin'.
> > <6>[   85.724265] firmware: requesting rt2561s.bin
> > <6>[   85.779042] phy0 -> rt2x00lib_request_firmware: Info 
> - Firmware
> > detected - version: 0.8.
> > <7>[   85.821654] LaE: ieee80211_ioctl_giwrange: enter; 
> > <7>[   85.821832] LaE: ieee80211_ioctl_giwrange: 
> 1=netif_running(dev)
> > 
> > When wpa supplicant set the adhoc mode=1/type=3 the device 
> is running and
> > fails
> 
> to quota myself: "The interface must be down when changing 
> working mode."

OK, I got that ;)

> 
> > <7>[   85.947991] LaE: ieee80211_ioctl_siwmode: mode=1 
> > <7>[   85.948134] LaE: ieee80211_ioctl_siwmode: type=3, 
> sdata->vif.type=2 
> > <7>[   85.948433] LaE: ieee80211_ioctl_siwmode: type=3 
> > 
> > My work around was to ignore this situation and continue 
> the mode change.
> 
> that is not correct, as I've stated already: The interface 
> must be down when changing working mode.
> 

I have to check if it is the mac80211 or the wpa_supplicant that is doing
wrong.

> > > > Two tests cases, but same behaviour:
> > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > 
> > > Are any beacons going out? Is there anything in the logs which
> > > indicates what is happening?
> > > 
> > 
> > As you can se in the trace below, the configuration 
> proceeds and the adhoc
> > is created.
> > The warnon might give some clues.
> 
> So how about those beacons? are they getting out?
> 

I will check that and come back as soon as the first issue is sorted out.
I might broke some logic when I was trying to change mode for an open
interface.

/Lars

