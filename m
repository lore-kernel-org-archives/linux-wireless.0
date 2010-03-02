Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20516 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0CBDy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 22:54:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 19:54:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.37002.731064.872605@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 09:44:02 +0530
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
In-Reply-To: <20100302002759.GH8069@bombadil.infradead.org>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
	<20100302002759.GH8069@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Apart from that there's one long term objective which I noticed
> was removed from my initial implementation approach. On this driver
> the the hif/htc code linked all together while I had these separated.
> The reason for separation was in the future different buses would be
> supported and so a different HIF transport would be required. The
> typical HTC Atheros driver tends to bundle HTC together and re-build
> HTC for a new driver sort of how you've used lib.o for ath9k and
> ath9k_htc only that each htc.o would be modified to suit each new
> driver and firmware API. I think that's pointless and gross and tried
> to work on a way HTC can exist as a registrar, sharing all things HTC
> that are possible. Consider PCI support for a device similar to AR9271
> with, say a AR9280 MAC and radios. In such a case (and very possible)
> we'd need an HIF PCI added, so you will need to eventually address
> separation anyway.

I am not sure what your original approach was - but a new bus implementation
would just be a hif_bleh.c. HTC would remain unchanged for the most part.
Well almost, except if credit distribution is required, it would be added to HTC.

Or am I missing something ?

Sujith
