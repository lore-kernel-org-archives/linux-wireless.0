Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3176 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZFABhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 21:37:37 -0400
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
From: Zhu Yi <yi.zhu@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1243771847.5248.10.camel@maxim-laptop>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <20090526222433.GA23972@bombadil.infradead.org>
	 <1243736227.3623.180.camel@debian>
	 <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
	 <1243752126.3623.375.camel@debian>  <1243771847.5248.10.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 09:29:28 +0800
Message-Id: <1243819768.3623.438.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 20:10 +0800, Maxim Levitsky wrote:
> This is a fullmac driver, thus if I understand correctly, it behaves
> on the outside more like an Ethernet adapter.

Depends on how you define "outside". From the user point of view: yes;
from the firmware point of view: no. Take a look at the new functions
ieee80211_data_{from|to}_8023 in cfg80211 and their usage in
iwmc3200wifi.

> This will mean that many things possible with normal softmac card
> won't be possible, like sending raw packets, etc...

See above.

> (and besides I belive that hardware is more or less the same,

The hardware is different as we mentioned it is a multicomm device.

> but more functionality is pushed down to firmware, and more firmware
> code equals to bigger probability of bugs that aren't possible to
> triage and solve easily.

That's the con. The pro is saving more host CPU power and portability.

> Does this device indicate that intel moves away from softmac devices,
> or this is a device that will mostly be used in some dedicated market
> sector (embedded devices for example)?

I think it should be capable for embedded devices as well as
desktop/laptops.

Thanks,
-yi

