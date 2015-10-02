Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbbJBIpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 04:45:08 -0400
Date: Fri, 2 Oct 2015 10:43:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pascal Huerst <pascal.huerst@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2x00: Firmware loading vs. udev rules
Message-ID: <20151002084346.GA4149@redhat.com> (sfid-20151002_104515_073289_C06CC4B0)
References: <560ABE7B.1080109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560ABE7B.1080109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Sep 29, 2015 at 06:38:19PM +0200, Pascal Huerst wrote:
> on rt2x00 devices, firmware gets loaded in:
> 
> int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
> 
> which is called, when we start the interface by:
> 
> ifconfig wlan0 up
> 
> I need to lower tx power of the device and created a udev rule for that:
> 
> KERNEL=="wlan0", RUN+="/usr/sbin/iw dev wlan0 set txpower fixed 1800"
> 
> Obviously this does not work, since the firmware is not loaded, yet.

Well, I don't think it will work even when you do this after firmware
load due to issue on __ieee80211_recalc_txpower(), which do not work
for drivers that don't use channel context. Command may finish without
an error but tx power setting in driver will not be changed.

> Is there a reason, why the firmware is loaded so late and not earlier in
> probe or so?

Don't enable things that are not used.

> Can this be done in any other proper way I don't know about?
> I think the device should be ready for any operation, when the udev rule
> triggers, right?

Assuming channel context issue will be fixed, you can add script to
/etc/NetworkManager/dispatcher.d/ or on older system
use one of /etc/sysconfig/network-scripts scripts. I think systemd also
allow you to add a custom service, which can be triggered on network
start.

Stanislaw
