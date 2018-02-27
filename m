Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51046 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbeB0JfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 04:35:25 -0500
Date: Tue, 27 Feb 2018 12:35:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 6/8] staging: wilc1000: fix line over 80 char in
 wilc_wlan_handle_rxq()
Message-ID: <20180227093505.iq3xy5j4roixbs4n@mwanda> (sfid-20180227_103531_513912_8D22CBD3)
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
 <1519662722-15761-7-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519662722-15761-7-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 26, 2018 at 10:02:00PM +0530, Ajay Singh wrote:
> Fix 'line over 80 character' issue found by checkpatch.pl script.
> Refactor wilc_wlan_handle_rxq() code to remove the checkpatch.pl
> warnings.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 46 ++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 74b80ad..223bf8b 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -798,6 +798,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
>  			u32 header;
>  			u32 pkt_len, pkt_offset, tp_len;
>  			int is_cfg_packet;
> +			int tmp;
>  

Heh.  Nope.  Don't do this.  You've just create a "tmp" variable to hold
many different types of random long values...  It makes the code less
readable.

Just break it up into separate functions.

regards,
dan carpenter
