Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbeB0Jgb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 04:36:31 -0500
Date: Tue, 27 Feb 2018 12:36:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 7/8] staging: wilc1000: fix line over 80 char in
 wilc_wlan_cfg_set()
Message-ID: <20180227093617.jrqqh7frjuv4rodp@mwanda> (sfid-20180227_103635_533185_EC82C016)
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
 <1519662722-15761-8-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519662722-15761-8-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 26, 2018 at 10:02:01PM +0530, Ajay Singh wrote:
> Fix 'line over 80 character' issue found by checkpatch.pl script.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 223bf8b..acf7591 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1230,6 +1230,8 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
>  	wilc->cfg_frame_offset = offset;
>  
>  	if (commit) {
> +		unsigned long tmp = msecs_to_jiffies(CFG_PKTS_TIMEOUT);

Again.  This "tmp" is a bad name here.  "tmp" can be a good name, and
I use it all the time, but *here* it is a bad name.

regards,
dan carpenter
