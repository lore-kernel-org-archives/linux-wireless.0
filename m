Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52376 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdFVWB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:01:26 -0400
Date: Fri, 23 Jun 2017 00:01:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Geoff Lansberry <geoff@kuvee.com>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: trf7970a: fix check of clock frequencies, use &&
 instead of ||
Message-ID: <20170622220121.GB21214@zurbaran.ger.intel.com> (sfid-20170623_000159_001708_7DB5DEFF)
References: <20170424133603.3697-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170424133603.3697-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Mon, Apr 24, 2017 at 02:36:02PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The "or" condition (clk_freq != TRF7970A_27MHZ_CLOCK_FREQUENCY) ||
> (clk_freq != TRF7970A_13MHZ_CLOCK_FREQUE) will always be true because
> clk_freq cannot be equal to two different values at the same time. Use
> the  && operator instead of || to fix this.
> 
> Detected by CoverityScan, CID#1430468 ("Constant expression result")
> 
> Fixes: 837eb4d21ecde7 ("NFC: trf7970a: add device tree option for 27MHz clock")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/trf7970a.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
