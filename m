Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61312 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1HaRwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 13:52:14 -0400
Received: by qyk34 with SMTP id 34so674989qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 10:52:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110831141800.GB2474@tuxdriver.com>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain> <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de> <20110830014257.GI15771@broadcom.com>
 <4E5E214E.2060109@hauke-m.de> <20110831141800.GB2474@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 31 Aug 2011 10:46:04 -0700
Message-ID: <CAB=NE6VGyKZQugpZngPqoQSQLSSJ_Vcieme3nauy3Xt6ZCF+4g@mail.gmail.com> (sfid-20110831_195219_781098_9BD4CDF7)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Henry Ptasinski <henryp@broadcom.com>,
	Greg KH <gregkh@suse.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 7:18 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Aug 31, 2011 at 01:55:58PM +0200, Hauke Mehrtens wrote:
>
>> If brcmsmac gets merged it should support all braodcom softmac wireless
>> devices with ieee80211n support, this includes also the N-PHY devices
>> with SB-bus, otherwise ieee80211n support has to be added to b43 and
>> then I do not see any advantage over just using b43 and removing
>> brcmsmac. Will Broadcom support these older chip in brcmsmac and also
>> all new devices still missing now or has the community to add support
>> for these devices without any help by broadcom?
>
> This requirement seems rather artificial.  Vendors choose which devices
> they want to support.  Intel has abandoned devices (e.g. ipw2100,
> ipw2200, and iwlegacy), and arguably so has Atheros (e.g. ath5k).
> Why should Broadcom be compelled to support older devices simply
> because there is some overlap between brcmsmac and b43?  If they went
> down that path, would you then demand that they support the b43legacy
> devices as well?  Why not?
>
> The strategy of cramming all vaguely similar devices under "one"
> driver doesn't have a great track record IMHO.

Agreed.

> We have had to split
> iwlwifi, and may have to do so again. e1000 got split similarly,
> as did b43/b43legacy.

And I would hope someone would even split i915 driver too, having a
regression on every rc1 of the kernel seems rather ridiculous to me.

> I see no reason to compel a driver to support
> an extended range of hardware when there are reasonable dissimilarities
> between the devices.

Agreed here -- but one thing is to dedicate resources to supporting
old devices, which of course no silicon company wants to do, another
is to enable the community to help support older device. The later is
what I argue is reasonable and every silicon provider needs to work
harder at. At Atheros not only have we provided documentation to help
support ath5k but we even released firmware for our legacy Otus driver
-- and documentation. Do not tell me this is not possible, I simply do
not buy it -- you are simply not trying hard enough. Orphaning drivers
can be done better.

  Luis
