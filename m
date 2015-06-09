Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51891 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbbFIHao (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 03:30:44 -0400
Message-ID: <1433835041.1892.3.camel@sipsolutions.net> (sfid-20150609_093048_203667_AE9891DB)
Subject: Re: [PATCH] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Date: Tue, 09 Jun 2015 09:30:41 +0200
In-Reply-To: <52abf3860d5941869a72b4ecf9c99616@SC-EXCH02.marvell.com>
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	 (sfid-20150604_065726_449748_FA29E81C) <1433598191.2467.65.camel@sipsolutions.net>
	 <52abf3860d5941869a72b4ecf9c99616@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 07:25 +0000, David Lin wrote:

> 1. That's interesting, why does a PCI(e) driver need OF?
> This driver will accept parameters in DTS file for band control,
> antenna setting and power table, to cater for different boards
> combination inside a system.

Ok. I saw some OF references at the very end, but then got a bit
side-tracked :)

> 2. Can you perhaps explain how the STA/AP firmware separation works?
> For this driver, the AP/STA mode will use the same single firmware
> binary, so there is no “separation” per se. The firmware will support
> AP/STA mode.

Hmm, interesting. It seemed that there were references in the code to
loading different firmware? Might want to look through for that.

> 3. Does this driver has any relation to mwifiex?
> Mwifiex is driver for Firmware-based MLME. It interfaces with firmware
> with 802.3 packets. Mwlwifi is the Host Soft AP/STA driver that works
> with mac80211.

Ok, so basically no relation - makes sense.

> 1. Directory name “mwlwifi”.
> This is to be consistent with some predecessor. For example, Intel
> uses iwlwifi, realtek uses rtlwifi. We do not see a need to change it.
> This will make sure we keep the original project mwlwifi on openwrt
> folder remain intact, while we continue to maintain them the same
> way/pace.

That's fine.

> 2. Interface with F/W.
> F/W used by this driver is also used by other marvell’s drivers.

Yeah, but I'm not saying you should change the interface, I'm just
saying you need to properly endian-annotate it. That won't actually
change the binary interface, but will make the driver more robust.

> 3. AMPDU related code.
> It has been well tested and leveraged from mwl8k. We may enhance it in
> future, but please accept the current code status for now.

I'm not really sure it's correct, but I guess I can't really comment too
much on it.

johannes

