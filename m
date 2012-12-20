Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:17242 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2LTLGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:06:08 -0500
Date: Thu, 20 Dec 2012 12:06:02 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Kalle Valo <kvalo@adurom.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: allow to load
 EEPROM data via firmware API
Message-ID: <20121220110602.GA13055@localhost.localdomain> (sfid-20121220_120612_713803_DB78E565)
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
 <1355847743-16659-2-git-send-email-juhosg@openwrt.org>
 <20121218222226.GB4825@localhost.localdomain>
 <50D18A5A.2020505@openwrt.org>
 <87d2y5umko.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d2y5umko.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2012 at 10:58:31AM +0200, Kalle Valo wrote:
> Gabor Juhos <juhosg@openwrt.org> writes:
> 
> >> Since we use completion here, why we can not just use normal synchronous
> >> version of request_firmware? I heard of request_firmware drawbacks, so
> >> this approach can be correct. Just want to know if we do not complicate
> >> things not necessarily here.
> >
> > If the driver is built into the kernel, then the synchronous version
> > would fail because user-space is not up during probe time.
> 
> Didn't udev/systemd guys finally fix their software? At least I recall
> seeing such claims on g+.

Udev broke and later fixed request_firmware when driver is compiled as
module. Here we avoid problem when driver is compiled into kernel
(problem which was there from very beginning) - no userspace available
so request_firmware fail. But since everyone are using modules, nobody
cares.

Openwrt must use modules too, since it use compat-wireless, right? So
I'm not sure if it worth to use request_firmware_nowait. Especially
like that with completion, which block ->probe. As long kernel does
not probes devices in parallel, we block whole boot, and deadlock since
probe wait for userspace.

Gabor, did you test your patches ?

Stanislaw
