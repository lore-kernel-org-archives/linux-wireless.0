Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50237 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab0BBUpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 15:45:35 -0500
Date: Tue, 2 Feb 2010 15:36:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH] libertas: cfg80211 support
Message-ID: <20100202203643.GD2967@tuxdriver.com>
References: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100202000934.GA19847@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 02, 2010 at 01:09:46AM +0100, Samuel Ortiz wrote:
> 
> From: Holger Schurig <holgerschurig@googlemail.com>
> 
> We can get rid of the libertas wext, assoc and scan code.
> The cfg80211 support is almost complete, the main missing feature being mesh
> support. There are also a few cfg80211_ops handlers missing (tx_power,
> bss_change for example).
> Monitor and STA mode are supported  and the latter have been tested on open,
> WEP, WPA and WPA2 links. At connection time, the cfg80211 bss list has to be
> populated with the BSS we're trying to join.
> Also, passive and active (broadcast and directed) scanning have been tested
> (on a specific channel and on the whole band).
> 
> Signed-off-by: Holger Schurig <holgerschurig@gmail.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
> v1: scanning
> v2: + WEP, WPA, WPA2
> v3: + disconnect & MIC events, 11D region hint to cfg80211, auth_type TLV
> v4: + IBSS
>     + monitor mode
> v5: + Search the cfg80211 bss list for the right BSSID when connecting.
>     + Removed carrier off toggling when scanning.
>     + Slightly changed the scanning state machine: The scan worker is
> scheduled from the scan response handler, and we're checking for scan_channel
> to know if a scan is currently running.
>     + Implemented RTS and fragmentation threshold.
>     + Use the recently exported cfg80211_find_ie() routine.
> 
> In my opinion, the only missing feature (besides some small wext settings) is
> mesh, but I think this patch is ready for wireless-testing.

I'm happy to have libertas support cfg80211.  But doesn't this remove
the mesh support that the OLPC guys still use?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
