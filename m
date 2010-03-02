Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0CBA2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 19:28:01 -0500
Date: Mon, 1 Mar 2010 19:28:00 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vasanth.Thiagarajan@Atheros.com,
	Senthilkumar.Balasubramanian@Atheros.com
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
Message-ID: <20100302002759.GH8069@bombadil.infradead.org>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19336.46643.733555.555640@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2010 at 11:35:39AM +0530, Sujith wrote:
> Support for AR9271 chipset.
> 
> Features:
> 
>  * Station mode
>  * IBSS mode
>  * Monitor mode
>  * Legacy support
>  * HT support
>  * TX/RX 11n Aggregation
>  * HW encryption
>  * LED
> 
> For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>

Awesome stuff, looks great for AR9271 support.

My only immediate nit-pick before getting this merged is lib.o being
linked twice to both ath9k and ath9k_htc instead just dumping the stuff
into the ath9k_common module as I noted in the other thread.

Apart from that there's one long term objective which I noticed
was removed from my initial implementation approach. On this driver
the the hif/htc code linked all together while I had these separated.
The reason for separation was in the future different buses would be
supported and so a different HIF transport would be required. The
typical HTC Atheros driver tends to bundle HTC together and re-build
HTC for a new driver sort of how you've used lib.o for ath9k and
ath9k_htc only that each htc.o would be modified to suit each new
driver and firmware API. I think that's pointless and gross and tried
to work on a way HTC can exist as a registrar, sharing all things HTC
that are possible. Consider PCI support for a device similar to AR9271
with, say a AR9280 MAC and radios. In such a case (and very possible)
we'd need an HIF PCI added, so you will need to eventually address
separation anyway.

Its fine to address this when we cross that bridge though.

  Luis
