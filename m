Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:59854 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750801AbeFDESN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 00:18:13 -0400
Date: Mon, 4 Jun 2018 06:18:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: fdp: fix signed less or equal zero check in u8
 max_size
Message-ID: <20180604041812.GB8977@zurbaran.ger.intel.com> (sfid-20180604_061858_243365_151E8CB2)
References: <20180130153359.524-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130153359.524-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Tue, Jan 30, 2018 at 03:33:59PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The u8 variable max_size is being assigned a return value from the
> call to nci_conn_max_data_pkt_payload_size that can return a -ve
> error return. Since max_size is a u8, the -ve check for the error will
> always be false. Fix this by making max_size an int type.
> 
> Detected using Coccinelle:
> drivers/nfc/fdp/fdp.c:208:5-13: WARNING: Unsigned expression compared
> with zero: max_size <= 0
> 
> Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/fdp/fdp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
