Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930AbYJ1PUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 11:20:34 -0400
Date: Tue, 28 Oct 2008 08:18:22 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
Message-ID: <20081028151822.GA8783@kroah.com> (sfid-20081028_162038_803823_EE837448)
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com> <20081023111103.GB5979@tesla> <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com> <49071272.8050700@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49071272.8050700@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 02:24:02PM +0100, Joerg Albert wrote:
> On 10/28/2008 12:35 AM, Luis R. Rodriguez wrote:
>
>> This is now fixed on the master branch, also the branch "for-upstream"
>> does a lot of cleanup I thought you may like before stuffing it into
>> staging like removing all KERNEL_VERSION checks, all wireless
>> extensions checks, some compile warnings, removal of compat, dos2unix,
>> use utf-8, etc. Unfortunately this still requires a specific version
>> of wpa_supplicant but it seems it works. Not sure what bars you have
>> for staging at this point.
>
> I was a bit disappointed to find binary-only firmware inside the driver 
> (HalPlus/OTUS_FB50/{hpfwbu,hpfwuinit}.c which is downloaded into the device 
> during startup (initially thought this to be a complete OpenSource driver 
> :-(

Binary firmware for a device does make the driver still "open source"
except for how some people intrepret it.

It is legal from a kernel standpoint though, and so it is fine to add to
the kernel as-is.

> Unless the attitude towards binary chunks inside the Linux kernel have 
> changed, I guess these should be moved into userspace using the 
> firmware_class driver to access it.

Yes they should, patches gladly accepted :)

thanks,

greg k-h
