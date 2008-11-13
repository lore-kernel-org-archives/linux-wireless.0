Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44275 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYKMAbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 19:31:14 -0500
Date: Wed, 12 Nov 2008 19:28:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Karakontakis Apostolos <akarako@freemail.gr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw problem
Message-ID: <20081113002804.GA11329@tuxdriver.com> (sfid-20081113_013118_700329_0228B197)
References: <200811130120.48659.akarako@freemail.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811130120.48659.akarako@freemail.gr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:20:48AM +0200, Karakontakis Apostolos wrote:
> Hi,
> 
> I have recenetly bought a usb wireless stick that requires zd1211rw driver 
> (ZyDAS ZD1211B chipset).With kernel 2.6.24 it works ok but with kernel 
> 2.6.27.2 it dos not.
> 
> 1. I have the latest firmware in /lib/firmware/zd1211
> 2. i have CONFIG_MAC80211 and CONFIG_FW_LOADER = y
> 3. i have CONFIG_ZD1211RW=m
> 
> when i insert the module i get the following errors
> 
> Nov 13 01:02:20 hakarako kernel: mac80211: Unknown parameter 
> `ieee80211_regdom'

This parameter no longer exists for mac80211.  A similar parameter
now exists for cfg80211, but the format is different.

The mac80211 module isn't loading due to the unknown parameter.

> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_free_hw
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_alloc_hw
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
> ieee80211_register_hw
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
> ieee80211_tx_status_irqsafe
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
> ieee80211_wake_queues
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
> ieee80211_stop_queues
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
> ieee80211_unregister_hw
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_beacon_get
> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_rx_irqsafe

Since mac80211 didn't load, zd1211rw won't load.

Remove that mac80211 option from modprobe.conf (and possibly add the
equivalent parameter to cfg80211), the modprobe zd1211rw again.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
