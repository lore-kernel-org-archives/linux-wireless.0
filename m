Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1H3GRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:17:39 -0400
Received: by pzk37 with SMTP id 37so9755284pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 23:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110830014257.GI15771@broadcom.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
	<20110827145003.GA9405@suse.de>
	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	<20110827152144.GA10126@suse.de>
	<20110830014257.GI15771@broadcom.com>
Date: Tue, 30 Aug 2011 08:17:38 +0200
Message-ID: <CACna6rynG8HoOZruSu1t=_GUZ+8mRcHCu46=eATjnBcDMGaO5A@mail.gmail.com> (sfid-20110830_081742_597461_DDAB6CE6)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/30 Henry Ptasinski <henryp@broadcom.com>:
> On Sat, Aug 27, 2011 at 08:21:44AM -0700, Greg KH wrote:
>> Ok, we don't want/accept duplicate drivers for the same devices (well, I
>> sure don't want that, we had it in the past in the USB subsystem and it
>> was a nightmare).
>>
>> So, as b43 was here first, it looks like brcmfmac is the only part that
>> should really move out of staging, right?
>>
>> Henry, thoughts?  Have you all been tracking the b43 support for the
>> past year?
>
> Greg,
>
> The brcmsmac driver supports full-rate 802.11n/HT operation on 20MHz channels,
> and has from the day we released it.  This includes 802.11n/HT rates and
> multiple spatial streams, and a number of additional 11n features such as
> A-MPDU and RIFS.  Current iperf testing on 20MHz channels with a BCM43224
> achieves greater than 70Mbps TCP throughput, using phy rates up to about
> 130Mbps.
>
> This contrasts with a maximum possible rate of 54Mbps/phy or 24Mbps TCP
> throughput for any driver that is legacy only and/or which doesn't support 11n
> optimizations such as aggregation of layer 2 PDUs (AMPDU).  802.11n operation
> can also achive greater range than legacy operation.
>
> b43 doesn't currently support 802.11n at all, so performance with b43 is
> limited to legacy 11g rates at best.

I agree, that's the biggest feature lacking in b43 and not started at
all. I want to work on this, but I'm just a single man having only 24
hours in his day. Right now I'm focusing on basic support for all the
cards the market has (it's LCN now).


> The brcmsmac driver supports 5GHz channels, including 802.11n operation in
> 5GHz.  b43 doesn't appear to currently support 5GHz.

I believe most of the code is in the place, I just don't have right
hardware (router) to test it. Please take a look at our PHY code,
there are proper checks for 2 vs. 5 GHz band and the tables contain
values for PHY / radio. It just needs enabling (in main.c IIRC) and
testing.


> The brcmsmac phy code also has full support for 802.11n/HT operation on 40MHz
> channels.  Some of the upper MAC layer settings (e.g. indicating 40MHz support
> to the stack) need updating in order to enable 40MHz channels, but all the
> critical phy support is present.
>
> The brcmsmac phy code is a direct derivative of the phy code used in our other
> drivers, which has been designed and *tested* to work properly over the full
> range of chip operating temperatures and fabrication process corners.
>
> The b43 driver uses a snapshot of the calibration values, that was obtained
> with a single (or few) chips in one environment, and applies those values
> across the board to all chips, regardless of process variations, in all
> environments.

Are you talking about our G-PHY, LP-PHY or N-PHY code? Can you show
where did we hardcode such a values? I believe we didn't so some tip
would be nice.

If you are talking about HT-PHY, this is *of course* true. I didn't
have any specs of reference source to write support for HT-PHY. I
wrote everything from MMIO dumps which is also kind of miracle it's
working at all.
I did it, because there isn't any Linux (at least x86/x86_64) driver
for HT-PHY. Desperate people having that (not-replaceable) card in
their MacBooks were trying ndiswrapper but that was causing frequent
lock ups. HT-PHY support is really experimental and I don't deny it.
Its just better than nothing (or ndiswrapper sometimes).


> The b43 driver doesn't implement transmit power control for the BCM43224 or
> BCM43225, and has various other unimplemented phy functions, e.g.:
>
>> void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>> {//TODO
>> }
>>
>> static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>> {//TODO
>> }
>>
>> static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
>>                                                         bool ignore_tssi)
>> {//TODO
>>         return B43_TXPWR_RES_DONE;
>> }
>>
>> ...
>>       b43err(dev->wl, "enabling tx pwr ctrl not implemented yet\n"); ...
>> ...
>
> etc.

I've just checked your wlc_phy_txpower_recalc_target_nphy. It's calling:
1) Trivial wlc_phy_txpwr_limit_to_tbl_nphy
2) More advanced wlc_phy_txpwrctrl_pwr_setup_nphy we have to implement
3) Already-implemented-in-b43 wlapi_bmac_mctrl
4) 50% implemented wlc_phy_txpwrctrl_enable_nphy

I can do this in 1 day.

-- 
Rafał
