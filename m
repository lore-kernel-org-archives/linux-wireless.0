Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33382 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbcA2QLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 11:11:09 -0500
Received: by mail-wm0-f53.google.com with SMTP id l66so73634181wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 08:11:08 -0800 (PST)
Subject: Re: Move wlan-ng out of staging?
To: ksenija.stanojevic@gmail.com,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Solomon Peachy <pizza@shaftnet.org>
References: <56AB8C90.2050909@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <56AB8F18.9000909@gmail.com> (sfid-20160129_171114_683762_C6AA6DFD)
Date: Fri, 29 Jan 2016 17:11:04 +0100
MIME-Version: 1.0
In-Reply-To: <56AB8C90.2050909@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2016 05:00 PM, Xose Vazquez Perez wrote:
> Ksenija wrote:
> 
>> I'm helping Greg do a bit of cleanup in the staging tree, I noticed that
>> wlan-ng driver is maybe ready to be moved out of staging. Are there
>> any TODO tasks left to do beside checkpatch.pl clean-up?
> 
> Its FAQ was very clear: ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/FAQ
> [archived at http://puppylinux.dreamhosters.com/wireless/linux-wlan-org_FAQ.txt ]
> 
> --cut--
> Q: When will linux-wlan-ng be merged into the mainline kernel?
> 
> 	Short answer:  Never.
> 
> 	First, the linux-netdev people will soundly reject this driver.
> 	I don't begrudge them for this; indeed in their position I'd do
> 	exactly the same.  It's a sound engineering decision.
> 
> 	linux-wlan-ng is obselete, and effort spent fixing it is better
> 	spent elsewhere.  You can't even buy the hardware any longer.
> 
> 	The original design for linux-wlan-ng was to separate the 802.11
> 	stack from the actual hardware driver.  This added a lot of
> 	complexity, but would greatly ease the pain of supporitng
> 	multiple hardware types.  Unfortunately, the implementation was
> 	turned out to be somewhat flawed, and hardware manufaturers went
> 	away from the thick-mac model, leaving linux-wlan-ng overly
> 	complex for what it did.
> 
> 	(Ironically, the linux kernel is adopting a similar
> 	 separation model, but it is a long way off from being ready)
> 
> 	So why not rewrite linux-wlan-ng to be more suitable, the
> 	enterprising reader may ask?
> 
> 	The kernel already has two drivers for prism2 (cs/pci/plx)
> 	hardware -- hostap and orinoco. linux-wlan-ng basically
> 	has three features not present in kernel drivers:
> 	
> 		1) USB support
> 		2) nearly complete implemettion of the 802.11 MIB/MLME
> 		3) Firmware-based AP support
> 	
> 	(3) requires an expensive license that isn't even available any
> 	longer, as the hostap mode works far better -- and is already
> 	supported by in-kernel drivers.
> 
> 	(2) would need to be removed or completely rewritten in order to
> 	be merged, as it does not fit within existing kernel APIs, and
> 	it would be effectively merging new kernel APIs.
> 
> 	(1) Is the only truly unique thing that linux-wlan-ng does that
> 	is generally needed any more.
> 
> 	To merge it into the kernel, we'd need to strip out (2), which
> 	would necessitate a complete rewrite -- to the point where
> 	writing a new driver from scratch is easier.
> 
> 	Basically, it would take far less effort to add USB
> 	support to the in-kernel drivers than it would to make
> 	linux-wlan-ng acceptable to be merged.
> 
> 	In other words, the short answer is:  Never.
> --end--
> 

Detailed info in these threads:
https://marc.info/?l=linux-wlan-user&m=125122113309475
https://marc.info/?l=linux-wireless&m=138384105903345
