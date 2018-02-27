Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeB0JvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 04:51:12 -0500
Date: Tue, 27 Feb 2018 12:50:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 7/8] staging: wilc1000: fix line over 80 char in
 wilc_wlan_cfg_set()
Message-ID: <20180227095058.gocqor2olavevtdo@mwanda> (sfid-20180227_105129_722607_F132D8BF)
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
> +
>  		netdev_dbg(vif->ndev,
>  			   "[WILC]PACKET Commit with sequence number %d\n",
>  			   wilc->cfg_seq_no);
> @@ -1239,8 +1241,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
>  		if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
>  			ret_size = 0;
>  
> -		if (!wait_for_completion_timeout(&wilc->cfg_event,
> -						 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
> +		if (!wait_for_completion_timeout(&wilc->cfg_event, tmp)) {


Also, it's not just the variable name I have an issue with.  I like that
I can see CFG_PKTS_TIMEOUT directly instead of having to look for it a
few lines back.  Don't add unecessary indirection.

So just leave this one as-is.  Or flip the "if (commit) " condition
around and do:

	if (!commit)
		return ret_size;

regards,
dan carpenter
