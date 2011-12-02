Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab1LBEkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 23:40:03 -0500
Subject: Re: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
References: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 19:42:34 -0800
Message-ID: <1322797354.13074.11.camel@wwguy-huron> (sfid-20111202_054011_272562_1B6B0376)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hmm, this is a good catch, I don't believe anyone  here ever test with
this. Thank you so much for letting us know.

Wey



On Thu, 2011-12-01 at 20:29 -0800, Nikolay Martynov wrote:
> Hi.
> 
>   I have an intel 5300 card running on latest compat-wireless.
>   If I do:
> echo "tx start 8" >
> /sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status
>   I get two pages of kernel stack trace and complete freeze, no
> messages left in any logs after reboot.
>   I looks like driver doesn't correctly check that this tid is
> actually supported when it comes from mac80211 layer.
>   This doesn't seem like a huge issue, just an annoying one.
> 
>   Please let me knoe if I can provide any more information.
>   Thanks.
> 


