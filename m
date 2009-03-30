Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out7.libero.it ([212.52.84.107]:59100 "EHLO
	cp-out7.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZC3Pae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 11:30:34 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
Date: Mon, 30 Mar 2009 17:29:27 +0200
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
References: <20090315202035.GC5246@makis> <200903292204.44260.rossi.f@inwind.it> <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
In-Reply-To: <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200903301729.28132.rossi.f@inwind.it> (sfid-20090330_173038_179296_CCE3556E)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 March 2009, Nick Kossifidis wrote:

> This patch introduces a function (and some helpers) to set 2 tables on
> hardware, it doesn't mess with the rest of the driver. I've tested it
> both on sta and ap scenarios with all the cards i have available and
> it worked fine. If you want to make more tests just disable parts of
> hw_txpower on phy.c, you can start by commenting out everything  below
>
> ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
>
> to skip the setting of tx power, if you comment out the whole function
> you'll disable the functionality that this patch adds.

I have discovered the problem. Inside ath5k_hx_txpower() it's called 
ath5k_setup_channel_powertable() where the gain curves of frequency 
piers are scanned (if I have understood correctly) to extract the data for 
the calibration of the current channel.

In particular, for the 5180MHz channel (the first of the A band), the function 
ath5k_get_linear_pcdac_min() is called with some critical data which generate 
an endless while loop.

Here are the bad numbers passed to ath5k_get_linear_pcdac_min():
* pwrL[0] = 4
* pwrL[1] = 4
* stepL[0] = 20
* stepL[1] = 35
and with this configuration the variable 'tmp' is never decremented inside the 
first while loop.

I suppose the data comes from the EEPROM. Is there an easy way to read the 
contents of the EEPROM regarding the calibration data for all the channels?

Fabio
