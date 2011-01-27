Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:46214 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751269Ab1A0QrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 11:47:21 -0500
Message-ID: <20110127164717.7220.qmail@stuge.se>
Date: Thu, 27 Jan 2011 17:47:17 +0100
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> I've received mini PCIe adapter to PCIe x1 slot to test notebook cards
> inserted into PC.  Unfortunately after inserting my Broadcom card to
> it, it is not detected in "lspci" at all.

Tried the various -A options?

linux-sysfs
linux-proc
intel-conf1
intel-conf2

The BIOS could be causing trouble. If intel-conf1 doesn't work then
try inserting any working PCIe card into the slot, note the bus:slot
it gets, and finally reboot with the wifi card and run:

lspci -A intel-conf1 -s bus:slot


//Peter
