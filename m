Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:30351 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHQJ6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 05:58:30 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1002516nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Aug 2008 02:58:28 -0700 (PDT)
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 11:58:25 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <059201c9004f$459ccc50$0b3ca8c0@gotws1589>
In-Reply-To: <059201c9004f$459ccc50$0b3ca8c0@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808171158.25501.IvDoorn@gmail.com> (sfid-20080817_115833_707622_3A65EA1D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 August 2008, Lars Ericsson wrote:
> > > 
> > > Have tried using the wpa_supplicant and got the -EBUSY from
> > > ieee80211_ioctl_siwmode().
> > 
> > As usual: The interface must be down when changing working mode.
> > 
> 
> The initial mode is 2. I do not know the source of that mode, might be a
> default.
> <7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, sdata->vif.type=2 

that is managed mode.

> Between 85.713698 and 85.821832 device is opened (1=netif_running(dev))
> <7>[   85.713698] LaE: ieee80211_ioctl_siwmode: 0=netif_running(dev)
> <7>[   85.713752] LaE: ieee80211_ioctl_siwmode: mode=2 
> <7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, sdata->vif.type=2 
> <6>[   85.713938] phy0 -> rt2x00lib_request_firmware: Info - Loading
> firmware file 'rt2561s.bin'.
> <6>[   85.724265] firmware: requesting rt2561s.bin
> <6>[   85.779042] phy0 -> rt2x00lib_request_firmware: Info - Firmware
> detected - version: 0.8.
> <7>[   85.821654] LaE: ieee80211_ioctl_giwrange: enter; 
> <7>[   85.821832] LaE: ieee80211_ioctl_giwrange: 1=netif_running(dev)
> 
> When wpa supplicant set the adhoc mode=1/type=3 the device is running and
> fails

to quota myself: "The interface must be down when changing working mode."

> <7>[   85.947991] LaE: ieee80211_ioctl_siwmode: mode=1 
> <7>[   85.948134] LaE: ieee80211_ioctl_siwmode: type=3, sdata->vif.type=2 
> <7>[   85.948433] LaE: ieee80211_ioctl_siwmode: type=3 
> 
> My work around was to ignore this situation and continue the mode change.

that is not correct, as I've stated already: The interface must be down when changing working mode.

> > > Two tests cases, but same behaviour:
> > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > 
> > Are any beacons going out? Is there anything in the logs which
> > indicates what is happening?
> > 
> 
> As you can se in the trace below, the configuration proceeds and the adhoc
> is created.
> The warnon might give some clues.

So how about those beacons? are they getting out?

ivo
