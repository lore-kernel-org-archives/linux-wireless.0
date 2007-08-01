Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2532 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762932AbXHABFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 21:05:45 -0400
Date: Tue, 31 Jul 2007 20:45:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Rate control over multiple devices
Message-ID: <20070801004543.GD4719@tuxdriver.com>
References: <46AFB779.4040003@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46AFB779.4040003@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2007 at 11:28:09PM +0100, Andy Green wrote:
> Hi folks -
> 
> Just seemed a little strange, maybe it is perfectly fine.
> 
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> PM: Adding info for No Bus:phy0
> PM: Adding info for No Bus:wmaster0
> wmaster0: Selected rate control algorithm 'iwl-3945-rs'
> 
> ...but then we add an rt73usb...
> 
> PM: Adding info for No Bus:phy1
> PM: Adding info for No Bus:wmaster1
> wmaster1: Selected rate control algorithm 'iwl-3945-rs' <----
> PM: Adding info for No Bus:wlan1
> usbcore: registered new interface driver rt73usb

This looks like the reverse of a dust-up we had a couple of months ago:

	http://marc.info/?l=linux-wireless&m=117875332512693&w=2

It is possible to change the rate control algorithm now via debugfs.
In the past someone proposed letting drivers request their default
rate scaling algorithm, and I think that makes a lot of sense.
Any thoughts?

John
-- 
John W. Linville
linville@tuxdriver.com
