Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.freemail.gr ([81.171.104.132]:36569 "EHLO smtp.freemail.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYKNNID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 08:08:03 -0500
From: Karakontakis Apostolos <akarako@freemail.gr>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: zd1211rw problem
Date: Fri, 14 Nov 2008 15:07:40 +0200
References: <200811130120.48659.akarako@freemail.gr> <20081113002804.GA11329@tuxdriver.com>
In-Reply-To: <20081113002804.GA11329@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netrolller.3d@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811141507.41076.akarako@freemail.gr> (sfid-20081114_140814_068845_DFB75097)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 November 2008 02:28:04 you wrote:
> On Thu, Nov 13, 2008 at 01:20:48AM +0200, Karakontakis Apostolos wrote:
> > Hi,
> >
> > I have recenetly bought a usb wireless stick that requires zd1211rw
> > driver (ZyDAS ZD1211B chipset).With kernel 2.6.24 it works ok but with
> > kernel 2.6.27.2 it dos not.
> >
> > 1. I have the latest firmware in /lib/firmware/zd1211
> > 2. i have CONFIG_MAC80211 and CONFIG_FW_LOADER = y
> > 3. i have CONFIG_ZD1211RW=m
> >
> > when i insert the module i get the following errors
> >
> > Nov 13 01:02:20 hakarako kernel: mac80211: Unknown parameter
> > `ieee80211_regdom'
>
> This parameter no longer exists for mac80211.  A similar parameter
> now exists for cfg80211, but the format is different.
>
> The mac80211 module isn't loading due to the unknown parameter.
>
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_free_hw Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown
> > symbol ieee80211_alloc_hw Nov 13 01:02:20 hakarako kernel: zd1211rw:
> > Unknown symbol
> > ieee80211_register_hw
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_tx_status_irqsafe
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_wake_queues
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_stop_queues
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_unregister_hw
> > Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
> > ieee80211_beacon_get Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown
> > symbol ieee80211_rx_irqsafe
>
> Since mac80211 didn't load, zd1211rw won't load.
>
> Remove that mac80211 option from modprobe.conf (and possibly add the
> equivalent parameter to cfg80211), the modprobe zd1211rw again.
>
> John

>>> Also, be sure to set CONFIG_MAC80211=m (not =y).

Thanks, it worked.
