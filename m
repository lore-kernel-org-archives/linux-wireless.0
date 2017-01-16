Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdAPKHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:07:05 -0500
Date: Mon, 16 Jan 2017 11:04:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 04/14] rt2x00: rt2800lib: fix beacon generation on
 RT3593
Message-ID: <20170116100445.GA6968@redhat.com> (sfid-20170116_110708_635198_6B2A3117)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116030054.GA32187@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116030054.GA32187@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I looked more detail in the patches and now I think shared mem
and 16 hw beacons patches are not needed. Explanation is below.
Sorry for not pointing this before.

On Mon, Jan 16, 2017 at 04:01:14AM +0100, Daniel Golle wrote:
> From: Gabor Juhos <juhosg@openwrt.org>
> 
> On the RT3593 chipset, the beacon registers are located
> in the high 8KB part of the shared memory.
> 
> The high part of the shared memory is only accessible
> if it is explicitly selected. Add a helper function
> in order to be able to control the SHR_MSEL bit in
> the PBF_SYS_CTRL register. Also add a few more helper
> functions and use those to select the correct part of
> the shared memory before and after accessing the beacon
> registers.
> 
> The base addresses of the beacon registers are also
> different from the actually used values, so fix the
> 'rt2800_hw_beacon_base' function to return the correct
> values.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
<snip>
> +static inline bool rt2800_beacon_uses_high_mem(struct rt2x00_dev *rt2x00dev)
> +{
> +	if (rt2x00_rt(rt2x00dev, RT3593))
> +		return true;

I just check that RT3593 (USB) device send beacon on AP mode when it is
configured previous way. I believe on RT3883 old way of configuring
beacons will work as well.

This change is only needed if we have to configure more than 8 beacons
i.e. add support to more than 8 APs per device. However there is no
patch increasing number of supported AP to 16 (by changing max_ap_intf),
so apparently nobody use this feature.

Hence I believe shared mem and 16 hw beacons is not needed and I prefer
to not add support for 16 APs per device with cost of adding this
additional complexity to the driver.

Stanislaw
