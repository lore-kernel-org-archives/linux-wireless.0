Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46680 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbeBSI4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 03:56:16 -0500
Date: Mon, 19 Feb 2018 11:56:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 04/12] staging: wilc1000: fix open parenthesis alignment
 mismatch in wilc_parse_network_info()
Message-ID: <20180219085602.i3gxyofwraimiptw@mwanda> (sfid-20180219_095620_336296_397DCC7D)
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
 <1518793909-15573-5-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518793909-15573-5-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 16, 2018 at 08:41:41PM +0530, Ajay Singh wrote:
> Fix "Alignment should match open parenthesis" issue found by
> checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index e98fc8e..2e2187b 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -320,8 +320,8 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
>  		get_ssid(msa, network_info->ssid, &network_info->ssid_len);
>  		get_BSSID(msa, network_info->bssid);
>  
> -		network_info->ch = get_current_channel_802_11n(msa,
> -							rx_len + FCS_LEN);
> +		network_info->ch = get_current_channel_802_11n(msa, rx_len
> +							       + FCS_LEN);

Greg has already applied this which is fine, but I probably would have
left this as is.  Normally a rule is that the '+' character should be on
the first line, and also it's slightly easier to read when the argument
is one one line instead of split across two.

But it doesn't matter much either way.  We'll probably end up
re-writing great swaths of this code.

regards,
dan carpenter
