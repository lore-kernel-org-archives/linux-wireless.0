Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50963 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3C0Raq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:30:46 -0400
Date: Wed, 27 Mar 2013 13:17:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: John Crispin <blogic@openwrt.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: make the driver build for Ralink SoC
Message-ID: <20130327171713.GD1868@tuxdriver.com> (sfid-20130327_183050_931263_73FD5652)
References: <1363808915-14278-1-git-send-email-blogic@openwrt.org>
 <3D4497AD-8992-47D6-BCF2-5D738B6AC9B4@gmail.com>
 <514AB846.9090407@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <514AB846.9090407@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 21, 2013 at 08:35:34AM +0100, John Crispin wrote:
> 
> >>Fix up the dependencies to make the driver actually compile on Ralink WiSoC.
> >>
> >>Signed-off-by: John Crispin<blogic@openwrt.org>
> >I don't think this is a proper way to handle this. rt2x00pci.c was only meant to be used for PCI devices; introducing the use of CONFIG_PCI in that file doesn't seem appropriate to me.
> >
> >Unfortunately I am away from my home computer, so I can't look at this properly until the weekend.
> >
> 
> Indeed not the cleanest patch ... after changing the config symbols
> I realized that that is not enough to make the driver actually work
> 
> It turns out that inside openwrt the compat-wireless package sets
> CONFIG_RT2800PCI=m to make the driver build and then applies the
> #ifdef'ery to rt2880pci.c
> 
> I will try to find the time today or tomorrow to have a closer look at this

Any more word on this?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
