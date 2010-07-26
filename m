Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60758 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0GZWbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 18:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <20100726222909.GA6773@srcf.ucam.org>
References: <1276952554.3332.3.camel@maxim-laptop> <1276961564.5173.12.camel@maxim-laptop>
	<20100726201322.GI14855@tux> <1280177362.3721.7.camel@maxim-laptop>
	<20100726210651.GJ14855@tux> <1280179033.3721.15.camel@maxim-laptop>
	<20100726212543.GA5424@srcf.ucam.org> <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
	<20100726222113.GA6487@srcf.ucam.org> <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
	<20100726222909.GA6773@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 15:31:28 -0700
Message-ID: <AANLkTinysGjYS7RKN4X_7T2q+rw_-OWdn-UJYM0poWXu@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 3:29 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jul 26, 2010 at 03:26:37PM -0700, Luis R. Rodriguez wrote:
>
>> What I meant was that the PCI config space would already have L1
>> enabled if L1 worked, so I don't see why we would need to nitpick out
>> specifics here. All Atheros PCIE chips should work with L1. The advise
>> given is to disable L0s though. I believe AR2425 would be one which
>> likely had L0s enabled but requires it to be disabled. Not sure of
>> others. But this is why I am saying this can be done globally for all
>> ath5k chipsets.
>
> If L1 is set but the chip is pre-PCIe 1.1 then we'll disable L1 unless
> the driver tells us that it's functional. The .inf from the Windows
> driver seemed to suggest that only a subset of the chips re-enabled L1
> there, but if it's ok in general then that's a straightforward one-line
> patch.

But why can't we just rely on what the device already has on its PCI
config space and only ensure to disable L0s?

  Luis
