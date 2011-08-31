Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58338 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1HaOaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:30:24 -0400
Date: Wed, 31 Aug 2011 10:18:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Henry Ptasinski <henryp@broadcom.com>, Greg KH <gregkh@suse.de>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110831141800.GB2474@tuxdriver.com> (sfid-20110831_163028_890951_E4727FE2)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de>
 <20110830014257.GI15771@broadcom.com>
 <4E5E214E.2060109@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E5E214E.2060109@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 01:55:58PM +0200, Hauke Mehrtens wrote:

> If brcmsmac gets merged it should support all braodcom softmac wireless
> devices with ieee80211n support, this includes also the N-PHY devices
> with SB-bus, otherwise ieee80211n support has to be added to b43 and
> then I do not see any advantage over just using b43 and removing
> brcmsmac. Will Broadcom support these older chip in brcmsmac and also
> all new devices still missing now or has the community to add support
> for these devices without any help by broadcom?

This requirement seems rather artificial.  Vendors choose which devices
they want to support.  Intel has abandoned devices (e.g. ipw2100,
ipw2200, and iwlegacy), and arguably so has Atheros (e.g. ath5k).
Why should Broadcom be compelled to support older devices simply
because there is some overlap between brcmsmac and b43?  If they went
down that path, would you then demand that they support the b43legacy
devices as well?  Why not?

The strategy of cramming all vaguely similar devices under "one"
driver doesn't have a great track record IMHO.  We have had to split
iwlwifi, and may have to do so again.  e1000 got split similarly,
as did b43/b43legacy.  I see no reason to compel a driver to support
an extended range of hardware when there are reasonable dissimilarities
between the devices.

> What are your plans in updating the PHY code in brcmsmac? As Rafał
> mentioned your closed source linux wifi driver (wl) is ~6 months ahead
> of brcmsmac now.

For the last ~6 months the Broadcom team has been working on getting
their driver out of staging.  I have to believe that they would have
rather been working on updating device support during that time.  I can
only presume that they would make that a priority in the long run.

How many times has b43 been > ~6 months behind on it's hardware
support?  Despite Rafał's recent heroic efforts at improving that,
I can't help but wonder how long will it be before b43 is again
dreadfully behind?

> Are you planing to replace your closed source linux driver with brcmsmac
> on normal x86 desktops and Linux SoCs and will you support brcmsmac as
> you did before with wl?

I'm guessing that their customers will decide this for them, if we
allow the customers to have a reasonable choice.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
