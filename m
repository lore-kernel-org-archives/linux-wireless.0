Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51768 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1HaL4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:56:06 -0400
Message-ID: <4E5E214E.2060109@hauke-m.de> (sfid-20110831_135610_974669_37B5028F)
Date: Wed, 31 Aug 2011 13:55:58 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: Greg KH <gregkh@suse.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com> <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com> <20110827143513.GN3775@shale.localdomain> <20110827145003.GA9405@suse.de> <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com> <20110827152144.GA10126@suse.de> <20110830014257.GI15771@broadcom.com>
In-Reply-To: <20110830014257.GI15771@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 03:42 AM, Henry Ptasinski wrote:
> On Sat, Aug 27, 2011 at 08:21:44AM -0700, Greg KH wrote:
>> Ok, we don't want/accept duplicate drivers for the same devices (well, I
>> sure don't want that, we had it in the past in the USB subsystem and it
>> was a nightmare).
>>
>> So, as b43 was here first, it looks like brcmfmac is the only part that
>> should really move out of staging, right?
>>
>> Henry, thoughts?  Have you all been tracking the b43 support for the
>> past year?
> 
> Greg,
> 
> The brcmsmac driver supports full-rate 802.11n/HT operation on 20MHz channels,
> and has from the day we released it.  This includes 802.11n/HT rates and
> multiple spatial streams, and a number of additional 11n features such as
> A-MPDU and RIFS.  Current iperf testing on 20MHz channels with a BCM43224
> achieves greater than 70Mbps TCP throughput, using phy rates up to about
> 130Mbps.
> 
> This contrasts with a maximum possible rate of 54Mbps/phy or 24Mbps TCP
> throughput for any driver that is legacy only and/or which doesn't support 11n
> optimizations such as aggregation of layer 2 PDUs (AMPDU).  802.11n operation
> can also achive greater range than legacy operation.
> 

If brcmsmac gets merged it should support all braodcom softmac wireless
devices with ieee80211n support, this includes also the N-PHY devices
with SB-bus, otherwise ieee80211n support has to be added to b43 and
then I do not see any advantage over just using b43 and removing
brcmsmac. Will Broadcom support these older chip in brcmsmac and also
all new devices still missing now or has the community to add support
for these devices without any help by broadcom?

What are your plans in updating the PHY code in brcmsmac? As Rafał
mentioned your closed source linux wifi driver (wl) is ~6 months ahead
of brcmsmac now.

Are you planing to replace your closed source linux driver with brcmsmac
on normal x86 desktops and Linux SoCs and will you support brcmsmac as
you did before with wl?

> b43 doesn't currently support 802.11n at all, so performance with b43 is
> limited to legacy 11g rates at best.
> 
> The brcmsmac driver supports 5GHz channels, including 802.11n operation in
> 5GHz.  b43 doesn't appear to currently support 5GHz.
> 
> The brcmsmac phy code also has full support for 802.11n/HT operation on 40MHz
> channels.  Some of the upper MAC layer settings (e.g. indicating 40MHz support
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

If you would provide the community with some documentation or recent
code of your tested driver it would help to fix these issues.

Hauke
