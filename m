Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:63344 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdKFADr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 19:03:47 -0500
Date: Mon, 6 Nov 2017 01:03:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: s3fwrn5: make array match static const, reduces
 object code size
Message-ID: <20171106000343.GC27831@zurbaran.ger.intel.com> (sfid-20171106_010401_780954_EBA8C075)
References: <20170919142515.23196-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170919142515.23196-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Tue, Sep 19, 2017 at 03:25:15PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the read-only array match on the stack, instead make
> it static const.  Makes the object code smaller by over 310 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    8304	   1084	    128	   9516	   252c	drivers/nfc/s3fwrn5/firmware.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>    7894	   1180	    128	   9202	   23f2	drivers/nfc/s3fwrn5/firmware.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/nfc/s3fwrn5/firmware.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
