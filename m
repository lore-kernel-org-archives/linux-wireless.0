Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:36670 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KVTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 14:30:46 -0500
Date: Tue, 22 Nov 2011 19:30:44 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: platform-driver-x86@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Martin =?utf-8?B?VmXEjWXFmWE=?= <ja@marvec.org>,
	Alejandro Vidal Mata <alex14@gmail.com>,
	Javier Vidal Mata <javitu@gmail.com>,
	Tino Schmidt <mailtinoshomepage@gmx.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	631664@bugs.debian.org
Subject: Re: [PATCH v2] x86: Add amilo-rfkill driver for some
 Fujitsu-Siemens Amilo laptops
Message-ID: <20111122193044.GE5163@srcf.ucam.org> (sfid-20111122_203050_718514_CA1EAEF7)
References: <1321211202.18929.295.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321211202.18929.295.camel@deadeye>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 13, 2011 at 07:06:42PM +0000, Ben Hutchings wrote:

> +#define A1655_STATE_PORT	0x64
> +#define A1655_COMMAND_PORT	0x64
> +#define A1655_DATA_PORT		0x60

You'll need to synchronise with the i8042 driver here, otherwise things 
could go horribly wrong.

> +#define M7440_PORT1		0x118f
> +#define M7440_PORT2		0x118e

These ports are defined in the DSDT for one of these systems, but not 
referenced. I think a hardware-banging driver like this is probably the 
only interface.

Should be fine as long as you make sure you're not racing with the 
keyboard controller.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
