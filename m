Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab0CCSS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 13:18:26 -0500
Subject: Re: iwl4965: 11a channels disabled in current wireless-testing
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <201003022047.10196.helmut.schaa@googlemail.com>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	 <201003011927.53208.helmut.schaa@googlemail.com>
	 <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
	 <201003022047.10196.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 10:18:24 -0800
Message-ID: <1267640304.15761.121.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Tue, 2010-03-02 at 11:47 -0800, Helmut Schaa wrote:
> That's the only regulatory event I get:
> 
> 1267558985.672513: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
> 
> When I set the reg domain to DE via iw I get:
> 
> 1267559015.166161: regulatory domain change: set to DE by a user request
> 
> However all previously disabled channels are still disabled.
> Reloading iwlagn afterwards gives the following again:
> 
> 1267559087.050649: regulatory domain change: set to DE by a user request
> 
> And afterwards the 11a channels and 12+13bg are enabled (passive scanning
> only, but that is fine) again.
> 
> I have no clue what's happening here.

Me neither. 

I too have a 4965 and its channels appear fine under the world
regulatory domain. Specifically:

$ iw reg get
country 00:
	(2402 - 2472 @ 40), (3, 20)
	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS

$ iw phy phy0 info
Wiphy phy0
	Band 1:
[...]
			* 2412 MHz [1] (15.0 dBm)
			* 2417 MHz [2] (15.0 dBm)
			* 2422 MHz [3] (15.0 dBm)
			* 2427 MHz [4] (15.0 dBm)
			* 2432 MHz [5] (15.0 dBm)
			* 2437 MHz [6] (15.0 dBm)
			* 2442 MHz [7] (15.0 dBm)
			* 2447 MHz [8] (15.0 dBm)
			* 2452 MHz [9] (15.0 dBm)
			* 2457 MHz [10] (15.0 dBm)
			* 2462 MHz [11] (15.0 dBm)
			* 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
			* 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
[...]

	Band 2:
[...]
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (disabled)
			* 5280 MHz [56] (disabled)
			* 5300 MHz [60] (disabled)
			* 5320 MHz [64] (disabled)
			* 5500 MHz [100] (disabled)
			* 5520 MHz [104] (disabled)
			* 5540 MHz [108] (disabled)
			* 5560 MHz [112] (disabled)
			* 5580 MHz [116] (disabled)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (disabled)
			* 5680 MHz [136] (disabled)
			* 5700 MHz [140] (disabled)

Hopefully Luis can see why your channels are not showing up correctly.

Reinette


