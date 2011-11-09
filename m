Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1KIIbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 03:31:04 -0500
Subject: Re: [PATCH] x86: Add amilo-rfkill driver for some Fujitsu-Siemens
 Amilo laptops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Martin =?UTF-8?Q?Ve=C4=8De=C5=99a?= <ja@marvec.org>,
	Alejandro Vidal Mata <alex14@gmail.com>,
	Javier Vidal Mata <javitu@gmail.com>,
	Tino Schmidt <mailtinoshomepage@gmx.net>,
	631664@bugs.debian.org
In-Reply-To: <1320817459.18929.50.camel@deadeye> (sfid-20111109_064459_718264_1D22260D)
References: <1320817459.18929.50.camel@deadeye>
	 (sfid-20111109_064459_718264_1D22260D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 09:30:58 +0100
Message-ID: <1320827458.3845.2.camel@jlt3.sipsolutions.net> (sfid-20111109_093108_846594_6F83474A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 05:44 +0000, Ben Hutchings wrote:

> +static bool init_blocked = false;
> +
> +/* Initial state set by 'radio' parameter, as in the fsaa1655g driver */
> +module_param_named(radio, init_blocked, invbool, 0);

I wonder what you need this for -- it shouldn't be necessary and the way
rfkill_init_sw_state() works might cause unexpected behaviour. I
recommend leaving that out, if you do leave it out rfkill will set the
desired state of the device as soon as the device is registered.

johannes

