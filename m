Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:37701 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYLJRvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:51:09 -0500
Date: Wed, 10 Dec 2008 17:51:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
Message-ID: <20081210175102.GA14282@srcf.ucam.org> (sfid-20081210_185115_022677_19FE9EC1)
References: <20081210150935.GA10927@srcf.ucam.org> <1228929529.15837.34.camel@johannes.berg> <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de> <1228930643.15837.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228930643.15837.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 06:37:23PM +0100, Johannes Berg wrote:

> Ok. I think the fundamental flaw here is assuming that there's just a
> single state. There isn't. The device can be turned off in hardware (in
> which case sw won't be able do anything about it, but we want to know)
> or in software (which we want to handle). Pretending that there's just a
> single state that's either hw-off, sw-off or on is plain wrong. The
> device can be hw-off and sw-off at the same time, and then if you turn
> off the hw-off button it won't turn on (however, unless your system
> integrator totally screwed up, you won't have a hw and a sw button on
> your system)

They may not be physical buttons, but we can often control this anyway. 
For instance, my HP has a button that will perform a hardware disable of 
the wifi card. However, I can control that button's state through 
software with the hp-wmi driver. The way we currently handle that (and, 
I think, the only way we *can* handle that) is to provide two separate 
rfkill interfaces - one tied to the wireless device, one tied to the 
platform device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
