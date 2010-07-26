Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44188 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab0GZWUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 18:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100726211424.GA5197@srcf.ucam.org>
References: <1276859156.19554.2.camel@maxim-laptop> <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop>
	<20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop>
	<1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux>
	<1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux>
	<20100726211424.GA5197@srcf.ucam.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Jul 2010 15:20:23 -0700
Message-ID: <AANLkTimn1XvpfUrgdgkO-E3kX55fz7N8w+_24Lz1ySLn@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 2:14 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jul 26, 2010 at 02:06:51PM -0700, Luis R. Rodriguez wrote:
>
>> No, ASPM must be enabled by the Systems Integrator through the BIOS, there are
>> other settings that have to be taken care of like modifying some PCI entrance and
>> exit latency timers, the number of FTS packets we send to exit L0s, amongst
>> other things. If a user selectively enables L1 but the BIOS had it disabled on
>> the device it may not work correctly.
>
> That's really the job of the driver.

The problem is that sometimes tweaks need to be done on the PCI
controller/root complex, not the PCIE device/endpoint. Today these
sort of changes *are* handled by the respective  systems
integrator/BIOS team and varies depending on the root complex used.
Atheros does not handle these at all in the driver.

> If the ASPM policy is set to
> powersave, the fadt doesn't indicate that ASPM should be disabled and
> the bus's _OSC method grants full control then the kernel will enable
> whatever combination of L states meet the latency constraints. If the
> hardware has additional constraints then the hardware-specific driver
> needs to handle them.

This makes sense but Is there an API for this?

> We don't rely on the BIOS to set up ASPM states. Nor does Windows.

Understood, but today some tweaks seem to be done on the BIOS
depending on the endpoint / root complex.

  Luis
