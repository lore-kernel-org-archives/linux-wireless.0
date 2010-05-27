Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab0E0Xbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 19:31:45 -0400
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
From: reinette chatre <reinette.chatre@intel.com>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BFD1ED0.9050309@digadd.de>
References: <4BF795EB.9070902@digadd.de>
	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 16:31:45 -0700
Message-ID: <1275003105.2091.20102.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Wed, 2010-05-26 at 06:14 -0700, Christian P. Schmidt wrote:
> On 05/24/2010 09:34 PM, reinette chatre wrote:
> > On Sat, 2010-05-22 at 01:29 -0700, Christian P. Schmidt wrote:
> >> However, even with the new card, I could not make any kernel from 2.6.32
> >> to 2.6.34 connect to any of my access points. Those are a Telekom DSL
> >> router and a Juniper NetScreen 5GT Wireless. I tried WEP64, WPA, WPA2,
> >> and even no encryption at all. My laptop with an Intel WiFi Link 5300
> >> has no problems whatsoever in any of the modes.
> > 
> > Could you please post some logs captured during your association
> > attempts? Were there any errors in your logs? In addition to this,
> > having mac80211 verbose debugging enabled will help and also
> > wpa_supplicant logs. That will give us a place to start.
> > 
> > Reinette
> > 
> 
> wpa_supplicant isn't particularly verbose:

It does become verbose when you enable debugging. Next time you need to
do this then you can try the "-dddt" option. Not right now though since
we can focus on the driver and mac80211 logs for now.

> [66242.538545] wlan0: direct probe to 00:10:db:a1:69:20 (try 1)
> [66242.738028] wlan0: direct probe to 00:10:db:a1:69:20 (try 2)
> [66242.938033] wlan0: direct probe to 00:10:db:a1:69:20 (try 3)
> [66243.138029] wlan0: direct probe to 00:10:db:a1:69:20 timed out
> [66243.142031] phy1: device now idle
> 
> I kind of feel that no packets are sent, since I can't see them on the
> firewall, even with packet dumps, not even association attempts.

We can look into this more by enabling TX debugging and general
debugging. Could you please reload driver with "modprobe iwlagn
debug=0x40843fff" and rerun your test?

Reinette


