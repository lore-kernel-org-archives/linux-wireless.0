Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:47907 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYLJSJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 13:09:23 -0500
Date: Wed, 10 Dec 2008 18:09:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
Message-ID: <20081210180918.GA14782@srcf.ucam.org> (sfid-20081210_190926_668063_F283BFF1)
References: <20081210150935.GA10927@srcf.ucam.org> <1228929529.15837.34.camel@johannes.berg> <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de> <1228930643.15837.48.camel@johannes.berg> <20081210175102.GA14282@srcf.ucam.org> <1228932343.15837.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228932343.15837.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 07:05:43PM +0100, Johannes Berg wrote:

> Does the wireless driver get the notification about this from the
> hardware, like it would if this was a real physical switch?

Yes.

> Then it's probably pretty simple: provide a rfkill struct from the 
> driver that updates hard-kill and provide a second rfkill struct for 
> the platform device that doesn't get hard-killed, but also provide a 
> soft-kill input form the platform device. That way, you can toggle 
> that button, but you can also software-enable the platform rfkill 
> device and that in turn re-enables the wifi-rfkill "hw" switch device.

Right. That's prety close to the current situation.
 
> If we need to tie them together in software it gets more complicated
> though.

I think we can avoid that, thankfully.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
