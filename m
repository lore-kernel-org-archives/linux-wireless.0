Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27174 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdKEXyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 18:54:18 -0500
Date: Mon, 6 Nov 2017 00:54:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] NFC: fix device-allocation error return
Message-ID: <20171105235414.GA27831@zurbaran.ger.intel.com> (sfid-20171106_005428_065974_45995B85)
References: <20170709110858.20331-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170709110858.20331-1-johan@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johan,

On Sun, Jul 09, 2017 at 01:08:58PM +0200, Johan Hovold wrote:
> A recent change fixing NFC device allocation itself introduced an
> error-handling bug by returning an error pointer in case device-id
> allocation failed. This is clearly broken as the callers still expected
> NULL to be returned on errors as detected by Dan's static checker.
> 
> Fix this up by returning NULL in the event that we've run out of memory
> when allocating a new device id.
> 
> Note that the offending commit is marked for stable (3.8) so this fix
> needs to be backported along with it.
> 
> Fixes: 20777bc57c34 ("NFC: fix broken device allocation")
> Cc: stable <stable@vger.kernel.org>	# 3.8
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  net/nfc/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks for the fix.

Cheers,
Samuel.
